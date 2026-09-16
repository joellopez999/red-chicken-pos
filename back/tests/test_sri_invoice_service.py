"""Ecuador SRI: clave de acceso módulo-11 algorithm + XAdES-BES signature self-consistency.

No DB/app fixtures needed — these are pure-function / cryptographic round-trip checks.
"""
from __future__ import annotations

import base64
import datetime as dt
import hashlib
import unittest

from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding, rsa
from cryptography.x509.oid import NameOID
from lxml import etree

from app.sri_invoice_service import generar_clave_acceso, modulo11
from app.sri_signing import DS_NS, sign_factura_xml


def _self_signed_cert(private_key: rsa.RSAPrivateKey) -> x509.Certificate:
    name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "Test SRI Cert")])
    now = dt.datetime.now(dt.timezone.utc)
    return (
        x509.CertificateBuilder()
        .subject_name(name)
        .issuer_name(name)
        .public_key(private_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - dt.timedelta(days=1))
        .not_valid_after(now + dt.timedelta(days=1))
        .sign(private_key, hashes.SHA256())
    )


class TestModulo11(unittest.TestCase):
    def test_official_worked_example(self) -> None:
        # Ficha Técnica §5.2 worked example: "41261533" -> check digit 6.
        self.assertEqual(modulo11("41261533"), 6)

    def test_generar_clave_acceso_shape(self) -> None:
        clave = generar_clave_acceso(
            fecha_emision=dt.date(2026, 9, 16),
            ruc="1234567890001",
            ambiente=1,
            establecimiento="001",
            punto_emision="001",
            secuencial=1,
            codigo_numerico="12345678",
        )
        self.assertEqual(len(clave), 49)
        self.assertTrue(clave.isdigit())
        self.assertEqual(modulo11(clave[:48]), int(clave[48]))

    def test_rejects_bad_ruc(self) -> None:
        with self.assertRaises(ValueError):
            generar_clave_acceso(
                fecha_emision=dt.date(2026, 9, 16),
                ruc="123",
                ambiente=1,
                establecimiento="001",
                punto_emision="001",
                secuencial=1,
            )


class TestXadesBesSigning(unittest.TestCase):
    def test_signature_cryptographically_verifies(self) -> None:
        private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        certificate = _self_signed_cert(private_key)
        xml = (
            '<?xml version="1.0" encoding="UTF-8"?>'
            '<factura id="comprobante" version="1.0.0">'
            "<infoTributaria><ruc>1234567890001</ruc></infoTributaria>"
            "</factura>"
        )

        signed_xml = sign_factura_xml(xml, private_key, certificate)
        root = etree.fromstring(signed_xml.encode("utf-8"))
        ns = {"ds": DS_NS}

        signed_info = root.find(".//ds:Signature/ds:SignedInfo", namespaces=ns)
        signature_value_b64 = root.find(".//ds:Signature/ds:SignatureValue", namespaces=ns).text
        signature_bytes = base64.b64decode(signature_value_b64)
        signed_info_c14n = etree.tostring(signed_info, method="c14n", exclusive=False, with_comments=False)

        # Independently re-verify with the certificate's own public key (not signxml, not our
        # own signing code path) — proves the RSA-SHA1 sign + C14N round-trip is correct.
        certificate.public_key().verify(signature_bytes, signed_info_c14n, padding.PKCS1v15(), hashes.SHA1())

        # The enveloped document-reference digest must match the document with <ds:Signature> removed.
        doc_ref_digest = root.find(
            './/ds:Signature/ds:SignedInfo/ds:Reference[@URI="#comprobante"]/ds:DigestValue',
            namespaces=ns,
        ).text
        root_without_sig = etree.fromstring(signed_xml.encode("utf-8"))
        root_without_sig.remove(root_without_sig.find("ds:Signature", namespaces=ns))
        expected_digest = base64.b64encode(
            hashlib.sha1(
                etree.tostring(root_without_sig, method="c14n", exclusive=False, with_comments=False)
            ).digest()
        ).decode("ascii")
        self.assertEqual(doc_ref_digest, expected_digest)


if __name__ == "__main__":
    unittest.main()

"""XAdES-BES enveloped signing for SRI comprobantes electrónicos.

Manually builds the ds:Signature element to match the EXACT reference
structure published in the SRI's own technical spec ("Ficha Técnica:
Emisión de Comprobantes Electrónicos", Anexo 8 — "Ejemplo firma electrónica
bajo estándar XADES_BES"): a single xmlns:ds/xmlns:etsi declaration on the
Signature root, three References (SignedProperties, KeyInfo, whole document),
RSA-SHA1 / SHA1, no SignaturePolicyIdentifier (that's XAdES-EPES, not BES).

A generic third-party XAdES library was deliberately avoided here: its output
shape isn't guaranteed to match what SRI's validator expects, and SRI is known
to be strict about the exact structure. This mirrors the government's own
documented example byte-for-byte in structure.
"""

from __future__ import annotations

import base64
import hashlib
import secrets
from datetime import datetime, timedelta, timezone

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.asymmetric.rsa import RSAPrivateKey
from cryptography.hazmat.primitives.serialization import Encoding, pkcs12
from cryptography.x509 import Certificate
from lxml import etree

DS_NS = "http://www.w3.org/2000/09/xmldsig#"
ETSI_NS = "http://uri.etsi.org/01903/v1.3.2#"
C14N_ALGO = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
ENVELOPED_ALGO = "http://www.w3.org/2000/09/xmldsig#enveloped-signature"
RSA_SHA1_ALGO = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
SHA1_ALGO = "http://www.w3.org/2000/09/xmldsig#sha1"
SIGNED_PROPERTIES_TYPE = "http://uri.etsi.org/01903#SignedProperties"

EC_TZ = timezone(timedelta(hours=-5))  # Ecuador: fixed UTC-5, no DST


def load_p12(p12_bytes: bytes, password: str) -> tuple[RSAPrivateKey, Certificate]:
    private_key, certificate, _ = pkcs12.load_key_and_certificates(p12_bytes, password.encode("utf-8"))
    if private_key is None or certificate is None:
        raise ValueError("Certificado .p12 inválido: no se pudo extraer la llave privada o el certificado")
    return private_key, certificate  # type: ignore[return-value]


def _c14n(element: etree._Element) -> bytes:
    return etree.tostring(element, method="c14n", exclusive=False, with_comments=False)


def _sha1_b64(data: bytes) -> str:
    return base64.b64encode(hashlib.sha1(data).digest()).decode("ascii")


def _int_to_b64(value: int) -> str:
    n_bytes = (value.bit_length() + 7) // 8 or 1
    raw = value.to_bytes(n_bytes, "big")
    if raw[0] & 0x80:  # avoid the big-endian value being read as negative
        raw = b"\x00" + raw
    return base64.b64encode(raw).decode("ascii")


def sign_factura_xml(xml_str: str, private_key: RSAPrivateKey, certificate: Certificate) -> str:
    """Returns the enveloped XAdES-BES-signed XML string for a factura with id="comprobante"."""
    root = etree.fromstring(xml_str.encode("utf-8"))
    if root.get("id") != "comprobante":
        raise ValueError('root element must have id="comprobante" for the enveloped Reference')

    # Digest of the whole document BEFORE the signature exists (enveloped-signature transform).
    doc_digest = _sha1_b64(_c14n(root))

    suffix = secrets.token_hex(4)
    sig_id = f"Signature{suffix}"
    cert_id = f"Certificate{suffix}"
    object_id = f"{sig_id}-Object{suffix}"
    signedprops_id = f"{sig_id}-SignedProperties{suffix}"
    doc_ref_id = f"Reference-ID-{suffix}"
    signedprops_ref_id = f"SignedPropertiesID{suffix}"

    cert_der = certificate.public_bytes(Encoding.DER)
    cert_digest_b64 = _sha1_b64(cert_der)
    cert_b64 = base64.b64encode(cert_der).decode("ascii")
    issuer_name = certificate.issuer.rfc4514_string()
    serial_number = str(certificate.serial_number)
    public_numbers = certificate.public_key().public_numbers()
    modulus_b64 = _int_to_b64(public_numbers.n)
    exponent_b64 = _int_to_b64(public_numbers.e)

    nsmap = {"ds": DS_NS, "etsi": ETSI_NS}
    signature_el = etree.SubElement(root, f"{{{DS_NS}}}Signature", nsmap=nsmap)
    signature_el.set("Id", sig_id)

    # --- KeyInfo (attached first so its digest can be computed with correct namespace inheritance) ---
    key_info = etree.SubElement(signature_el, f"{{{DS_NS}}}KeyInfo")
    key_info.set("Id", cert_id)
    x509_data = etree.SubElement(key_info, f"{{{DS_NS}}}X509Data")
    etree.SubElement(x509_data, f"{{{DS_NS}}}X509Certificate").text = cert_b64
    key_value = etree.SubElement(key_info, f"{{{DS_NS}}}KeyValue")
    rsa_key_value = etree.SubElement(key_value, f"{{{DS_NS}}}RSAKeyValue")
    etree.SubElement(rsa_key_value, f"{{{DS_NS}}}Modulus").text = modulus_b64
    etree.SubElement(rsa_key_value, f"{{{DS_NS}}}Exponent").text = exponent_b64
    key_info_digest = _sha1_b64(_c14n(key_info))

    # --- Object > QualifyingProperties > SignedProperties ---
    object_el = etree.SubElement(signature_el, f"{{{DS_NS}}}Object")
    object_el.set("Id", object_id)
    qualifying_props = etree.SubElement(object_el, f"{{{ETSI_NS}}}QualifyingProperties")
    qualifying_props.set("Target", f"#{sig_id}")
    signed_props = etree.SubElement(qualifying_props, f"{{{ETSI_NS}}}SignedProperties")
    signed_props.set("Id", signedprops_id)

    signed_sig_props = etree.SubElement(signed_props, f"{{{ETSI_NS}}}SignedSignatureProperties")
    etree.SubElement(signed_sig_props, f"{{{ETSI_NS}}}SigningTime").text = datetime.now(EC_TZ).isoformat(
        timespec="seconds"
    )
    signing_cert = etree.SubElement(signed_sig_props, f"{{{ETSI_NS}}}SigningCertificate")
    cert_el = etree.SubElement(signing_cert, f"{{{ETSI_NS}}}Cert")
    cert_digest_el = etree.SubElement(cert_el, f"{{{ETSI_NS}}}CertDigest")
    dm = etree.SubElement(cert_digest_el, f"{{{DS_NS}}}DigestMethod")
    dm.set("Algorithm", SHA1_ALGO)
    etree.SubElement(cert_digest_el, f"{{{DS_NS}}}DigestValue").text = cert_digest_b64
    issuer_serial = etree.SubElement(cert_el, f"{{{ETSI_NS}}}IssuerSerial")
    etree.SubElement(issuer_serial, f"{{{DS_NS}}}X509IssuerName").text = issuer_name
    etree.SubElement(issuer_serial, f"{{{DS_NS}}}X509SerialNumber").text = serial_number

    signed_data_obj_props = etree.SubElement(signed_props, f"{{{ETSI_NS}}}SignedDataObjectProperties")
    data_obj_format = etree.SubElement(signed_data_obj_props, f"{{{ETSI_NS}}}DataObjectFormat")
    data_obj_format.set("ObjectReference", f"#{doc_ref_id}")
    etree.SubElement(data_obj_format, f"{{{ETSI_NS}}}Description").text = "contenido comprobante"
    etree.SubElement(data_obj_format, f"{{{ETSI_NS}}}MimeType").text = "text/xml"

    signed_props_digest = _sha1_b64(_c14n(signed_props))

    # --- SignedInfo (attached to signature_el so its C14N inherits the same ds/etsi declarations
    #     it will have in the final document — required for the signature to verify later). ---
    signed_info = etree.SubElement(signature_el, f"{{{DS_NS}}}SignedInfo")
    c14n_method = etree.SubElement(signed_info, f"{{{DS_NS}}}CanonicalizationMethod")
    c14n_method.set("Algorithm", C14N_ALGO)
    sig_method = etree.SubElement(signed_info, f"{{{DS_NS}}}SignatureMethod")
    sig_method.set("Algorithm", RSA_SHA1_ALGO)

    ref_sp = etree.SubElement(signed_info, f"{{{DS_NS}}}Reference")
    ref_sp.set("Type", SIGNED_PROPERTIES_TYPE)
    ref_sp.set("URI", f"#{signedprops_id}")
    dm = etree.SubElement(ref_sp, f"{{{DS_NS}}}DigestMethod")
    dm.set("Algorithm", SHA1_ALGO)
    etree.SubElement(ref_sp, f"{{{DS_NS}}}DigestValue").text = signed_props_digest

    ref_cert = etree.SubElement(signed_info, f"{{{DS_NS}}}Reference")
    ref_cert.set("URI", f"#{cert_id}")
    dm = etree.SubElement(ref_cert, f"{{{DS_NS}}}DigestMethod")
    dm.set("Algorithm", SHA1_ALGO)
    etree.SubElement(ref_cert, f"{{{DS_NS}}}DigestValue").text = key_info_digest

    ref_doc = etree.SubElement(signed_info, f"{{{DS_NS}}}Reference")
    ref_doc.set("Id", doc_ref_id)
    ref_doc.set("URI", "#comprobante")
    transforms = etree.SubElement(ref_doc, f"{{{DS_NS}}}Transforms")
    transform = etree.SubElement(transforms, f"{{{DS_NS}}}Transform")
    transform.set("Algorithm", ENVELOPED_ALGO)
    dm = etree.SubElement(ref_doc, f"{{{DS_NS}}}DigestMethod")
    dm.set("Algorithm", SHA1_ALGO)
    etree.SubElement(ref_doc, f"{{{DS_NS}}}DigestValue").text = doc_digest

    signed_info_c14n = _c14n(signed_info)
    signature_bytes = private_key.sign(signed_info_c14n, padding.PKCS1v15(), hashes.SHA1())
    signature_value_b64 = base64.b64encode(signature_bytes).decode("ascii")

    sig_value_el = etree.Element(f"{{{DS_NS}}}SignatureValue")
    sig_value_el.text = signature_value_b64

    # Reorder to match the reference example: SignedInfo, SignatureValue, KeyInfo, Object.
    signature_el.remove(signed_info)
    signature_el.remove(key_info)
    signature_el.remove(object_el)
    signature_el.append(signed_info)
    signature_el.append(sig_value_el)
    signature_el.append(key_info)
    signature_el.append(object_el)

    return etree.tostring(root, xml_declaration=True, encoding="UTF-8").decode("utf-8")

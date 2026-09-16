"""Fernet-based at-rest encryption for tenant-owned secrets.

Covers the SRI signing certificate (.p12 bytes + its password) and the Resend
API key. Keys are derived from SECRET_KEY, domain-separated per secret type
(same pattern as app.clock_qr_util), so a leak of one derived key cannot be
reused to decrypt another secret's ciphertext.
"""

from __future__ import annotations

import base64
import hashlib

from cryptography.fernet import Fernet, InvalidToken

from app.settings import settings


def _fernet_for_domain(domain: str) -> Fernet:
    key = base64.urlsafe_b64encode(
        hashlib.sha256(f"{settings.secret_key}:{domain}".encode()).digest()
    )
    return Fernet(key)


def encrypt_secret(value: str, domain: str) -> str:
    """Encrypts a plaintext string secret for storage; returns an ASCII token."""
    return _fernet_for_domain(domain).encrypt(value.encode("utf-8")).decode("ascii")


def decrypt_secret(stored: str | None, domain: str) -> str | None:
    """Decrypts a stored token; returns None if missing, invalid, or wrong key.

    Also tolerates legacy plaintext values written before encryption was
    introduced, so already-stored secrets keep working without a data migration.
    """
    if not stored or not stored.strip():
        return None
    try:
        return _fernet_for_domain(domain).decrypt(stored.strip().encode("ascii")).decode("utf-8")
    except (InvalidToken, ValueError, UnicodeError):
        return stored


def encrypt_bytes(data: bytes, domain: str) -> bytes:
    return _fernet_for_domain(domain).encrypt(data)


def decrypt_bytes(data: bytes, domain: str) -> bytes:
    """Decrypts stored bytes; returns the input unchanged if it isn't a valid
    Fernet token (legacy plaintext files written before encryption)."""
    try:
        return _fernet_for_domain(domain).decrypt(data)
    except InvalidToken:
        return data


SRI_CERT_PASSWORD_DOMAIN = "sri_certificate_password_v1"
SRI_CERT_FILE_DOMAIN = "sri_certificate_file_v1"
RESEND_API_KEY_DOMAIN = "resend_api_key_v1"

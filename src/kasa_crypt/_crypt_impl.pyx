import cython

from libc.stdlib cimport malloc


cdef extern from "crypt_wrapper.h":
    void _encrypt_into(const char * unencrypted, char * encrypted)
    void _decrypt_into(const char * encrypted, char * unencrypted)

cdef char* _decrypt(const char *encrypted):
    cdef char* unencrypted = <char *> malloc(sizeof(encrypted) + 1)
    if not unencrypted:
        return NULL  # malloc failed
    _decrypt_into(encrypted, unencrypted)
    return unencrypted

cdef char* _encrypt(const char *unencrypted):
    cdef char* encrypted = <char *> malloc(sizeof(unencrypted) + 1)
    if not encrypted:
        return NULL  # malloc failed
    _encrypt_into(unencrypted, encrypted)
    return encrypted

def encrypt(string: str) -> bytes:
    return _encrypt(string.encode('utf-8'))


def decrypt(string: bytes) -> str:
    return _decrypt(string).decode('utf-8')

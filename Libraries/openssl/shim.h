#ifndef __COPENSSL_SHIM_H__
#define __COPENSSL_SHIM_H__

#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/md4.h>
#include <openssl/md5.h>
#include <openssl/sha.h>
#include <openssl/hmac.h>
#include <openssl/rand.h>
#include <openssl/ripemd.h>
#include <openssl/pkcs12.h>
#include <openssl/x509v3.h>

__attribute__((swift_name("SSL_set_tlsext_host_name(_:_:)")))
static inline int shim_SSL_set_tlsext_host_name(const SSL *s, const char *name) {
	return SSL_set_tlsext_host_name(s, name);
};

#endif

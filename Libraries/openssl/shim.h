#ifndef __COPENSSL_SHIM_H__
#define __COPENSSL_SHIM_H__

#include "conf.h"
#include "evp.h"
#include "err.h"
#include "bio.h"
#include "ssl.h"
#include "md4.h"
#include "md5.h"
#include "sha.h"
#include "hmac.h"
#include "rand.h"
#include "ripemd.h"
#include "pkcs12.h"
#include "x509v3.h"

__attribute__((swift_name("SSL_set_tlsext_host_name(_:_:)")))
static inline int shim_SSL_set_tlsext_host_name(const SSL *s, const char *name) {
	return SSL_set_tlsext_host_name(s, name);
};

#endif

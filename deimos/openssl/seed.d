/*
 * Copyright (c) 2007 KISA(Korea Information Security Agency). All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * 2. Neither the name of author nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */
/* ====================================================================
 * Copyright (c) 1998-2007 The OpenSSL Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in
 *   the documentation and/or other materials provided with the
 *   distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *   software must display the following acknowledgment:
 *   "This product includes software developed by the OpenSSL Project
 *   for use in the OpenSSL Toolkit. (http://www.openssl.org/)"
 *
 * 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
 *   endorse or promote products derived from this software without
 *   prior written permission. For written permission, please contact
 *   openssl-core@openssl.org.
 *
 * 5. Products derived from this software may not be called "OpenSSL"
 *   nor may "OpenSSL" appear in their names without prior written
 *   permission of the OpenSSL Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *   acknowledgment:
 *   "This product includes software developed by the OpenSSL Project
 *   for use in the OpenSSL Toolkit (http://www.openssl.org/)"
 *
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 *
 * This product includes cryptographic software written by Eric Young
 * (eay@cryptsoft.com).  This product includes software written by Tim
 * Hudson (tjh@cryptsoft.com).
 *
 */


module deimos.openssl.seed;

import deimos.openssl._d_util;

public import deimos.openssl.opensslconf;
public import deimos.openssl.e_os2;
public import deimos.openssl.crypto;

version (OPENSSL_NO_SEED) {
  static assert(false, "SEED is disabled.");
}

// #ifdef AES_LONG /* look whether we need 'long' to get 32 bits */
// # ifndef SEED_LONG
// #  define SEED_LONG 1
// # endif
// #endif

// #if !defined(NO_SYS_TYPES_H)
// # include <sys/types.h>
// #endif

enum SEED_BLOCK_SIZE = 16;
enum SEED_KEY_LENGTH = 16;


extern (C):
nothrow:


struct seed_key_st {
// #ifdef SEED_LONG
//     c_ulong data[32];
// #else
    uint[32] data;
// #endif
}
alias seed_key_st SEED_KEY_SCHEDULE;

version(OPENSSL_FIPS) {
    void private_SEED_set_key(const(ubyte[SEED_KEY_LENGTH])* rawkey, SEED_KEY_SCHEDULE* ks);
}
void SEED_set_key(const(ubyte[SEED_KEY_LENGTH])* rawkey, SEED_KEY_SCHEDULE* ks);

void SEED_encrypt(const(ubyte[SEED_BLOCK_SIZE])* s, ubyte[SEED_BLOCK_SIZE]* d, const(SEED_KEY_SCHEDULE)* ks);
void SEED_decrypt(const(ubyte[SEED_BLOCK_SIZE])* s, ubyte[SEED_BLOCK_SIZE]* d, const(SEED_KEY_SCHEDULE)* ks);

void SEED_ecb_encrypt(const(ubyte)* in_, ubyte* out_, const(SEED_KEY_SCHEDULE)* ks, int enc);
void SEED_cbc_encrypt(const(ubyte)* in_, ubyte* out_,
        size_t len, const(SEED_KEY_SCHEDULE)* ks, ubyte[SEED_BLOCK_SIZE]* ivec, int enc);
void SEED_cfb128_encrypt(const(ubyte)* in_, ubyte* out_,
        size_t len, const(SEED_KEY_SCHEDULE)* ks, ubyte[SEED_BLOCK_SIZE]* ivec, int* num, int enc);
void SEED_ofb128_encrypt(const(ubyte)* in_, ubyte* out_,
        size_t len, const(SEED_KEY_SCHEDULE)* ks, ubyte[SEED_BLOCK_SIZE]* ivec, int* num);

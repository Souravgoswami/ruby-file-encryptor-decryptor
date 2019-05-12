# ruby-file-encryptor-decryptor
Ruby File Encryptor and Decryptor. Must Read the Warnings Before Using.

## This is under development 🚧

## Features ⛑
*Ruby File Encryptor-Decryptor* uses OpenSSL to encrypt and decrypt your files with AES-128-CBC.

## Warnings ⚠️
+ Before running, make sure you are encrypting and decrypting the write file.
+ After a file has been over written, it is **irreversible**.
+ I shall not be held responsible for any losses.
+ This comes under GPL Version 3.0 without any warranty.

## Working 👨‍🏭👩‍🏭
+ *Ruby File Encryptor-Decrytor* uses AES encryption to encrypt your files.
+ The Keys are 16 bits, generated randomly and appended to the end of the file.
+ If you encrypted one of your file, you have to decrypt only with the decrypt module. Any other software or self written programs won't work unless you replicate the decrypt module.
+ Ecryption is irreversible. If you overwrite a file. It's gone without the decrypt module. So be very careful.

## Usage:

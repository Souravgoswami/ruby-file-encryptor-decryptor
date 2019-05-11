Kernel.require_relative('encrypt')
Kernel.require_relative('decrypt')

encryptfile = File.join(Encrypt::PATH, 'kelly-jean-684988-unsplash.jpg')

# We will be encrypting and decrypting the same file
# Encrypt.file(filename, output_file_name)
# If the output_file is same as input_file, then don't pass output_file argument

p "Encrypted #{encryptfile}" if Encrypt.file(encryptfile)     # or `p "Encrypted #{encryptfile}" if Encrypt.file(encryptfile, encryptfile)'

# Decrypt.file(filename, output_file_name)
# If the output_file is same as input_file, then don't pass output_file argument, just liek Encrypt.file method.
p "Decrypted #{encryptfile}" if Decrypt.file(encryptfile)

# We can see all the files in a directory before encrypting just to be sure
p Encrypt.show_files_in_directory(Encrypt::PATH, 'example.rb')

# WARNING: THE FOLLOWING IS VERY DANGEROUS OPERATIONS. PLEASE DO IT WITH CARE
# Encrypt all the files including this file but except crypt.rb
# Encrypt.files_in_directory(Encrypt::PATH)

# Decrypt all the files including this file but except crypt.rb
# Decrypt.files_in_directory(Decrypt::PATH)

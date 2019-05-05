require_relative('crypt')

encryptfile = File.join(PATH, 'kelly-jean-684988-unsplash.jpg')

# We will be encrypting and decrypting the same file
# Encrypt.file(filename, output_file_name)
p "Encrypted #{encryptfile}" if Encrypt.file(encryptfile, encryptfile)

# Decrypt.file(filename, output_file_name)
p "Decrypted #{encryptfile}" if Decrypt.file(encryptfile, encryptfile)

# We can see all the files in a directory before encrypting
# puts Encrypt.show_files_in_directory(PATH)

# WARNING: THE FOLLOWING IS VERY DANGEROUS OPERATIONS. PLEASE DO IT WITH CARE
# Encrypt all the files including this file but except crypt.rb
# Encrypt.files_in_directory(PATH)

# Decrypt all the files including this file but except crypt.rb
# Decrypt.files_in_directory(PATH)

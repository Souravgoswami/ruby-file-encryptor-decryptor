#!/usr/bin/ruby -w
require 'openssl'
STDOUT.sync = STDERR.sync = true

module Encrypt
	define_singleton_method(:file) do |input_file, output_file|
		@key = Array.new(32) { rand(99..99).chr }

		cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
		cipher.key = @key.select.with_index { |x, i| i.odd? }.join

		begin
			x = cipher.update(File.read(input_file)) << cipher.final << "#{@key.join}"

		rescue Errno::ENOENT => e
			warn "#{e}"
			warn "Please make sure the file exists"
		else
			File.write(output_file, x)
			x[0...-32]
		end
	end

	define_singleton_method(:files_in_directory) do |directory|
		files = Dir.children(directory)
		files.delete(File.basename(__FILE__))

		files.each do |el|
			puts "Encrypting #{el}"
			file(File.join(directory, el), File.join(directory, el))
		end
	end

	define_singleton_method(:show_files_in_directory) do |directory|
		files = Dir.children(directory)
		files.delete(File.basename(__FILE__))
		files
	end
end

module Decrypt
	define_singleton_method(:file) do |input_file, output_file|
		file = File.read(input_file)
		head, key = file[0...-32], file[-32..-1].chars.select.with_index { |x, i| i.odd? }.join

		decipher = OpenSSL::Cipher.new('AES-128-CBC')
		decipher.decrypt

		begin
			decipher.key = key
			x = decipher.update(head) << decipher.final

		rescue OpenSSL::Cipher::CipherError => e
			Warning.warn "Error Occurred: #{e.to_s.split.map(&:capitalize).join(' ')}\n"

			Warning.warn "#{input_file} Doesn't look like an encrypted file\n" if e.to_s == 'wrong final block length'
			Warning.warn "#{key} - is not a valid key\n" if e.to_s == 'bad decrypt'

		rescue ArgumentError
			Warning.warn "An Error Occurred - Are you sure the key #{key} is valid?"

		else
			File.write(output_file, x)
			x
		end
	end

	define_singleton_method(:files_in_directory) do |directory|
		files = Dir.children(directory)
		files.delete(File.basename(__FILE__))

		files.each do |el|
			puts "Decrypting #{el}"
			filename = File.join(directory, el)
			file(filename, filename)
		end
	end
end

PATH = File.dirname(__FILE__)

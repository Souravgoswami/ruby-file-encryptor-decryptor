#!/usr/bin/ruby -w
require 'openssl'
STDOUT.sync = true

module Decrypt
	PATH ||= File.dirname(__FILE__)
	EXCLUDE ||= [File.join(File.basename(__FILE__)), 'encrypt.rb']
	DECIPHER ||= OpenSSL::Cipher.new('AES-128-CBC').decrypt

	define_singleton_method(:file) do |input_file, output_file = nil|
		output_file = input_file unless output_file

		begin
			raise RuntimeError if File.zero?(input_file)
			file = IO.read(input_file)
			head, key = file[0...-32], file[-32..-1].chars.select.with_index { |x, i| i.odd? }.join
			DECIPHER.key = key
			x = DECIPHER.update(head) << DECIPHER.final
			File.write(output_file, x)
			x

		rescue OpenSSL::Cipher::CipherError => e
			Warning.warn "Error Occurred: #{e.to_s.split.map(&:capitalize).join(' ')}\n"
			Warning.warn "#{input_file} Doesn't look like an encrypted file\n" if e.to_s == 'wrong final block length'
			Warning.warn "#{key} - is not a valid key\n" if e.to_s == 'bad decrypt'
			 e

		rescue ArgumentError => e
			Warning.warn "!!! An Error Occurred - Are you sure the key #{key} is valid?"
			e

		rescue Errno::ENOENT => e
			Warning.warn "#{e}"
			Warning.warn "!!! Please Make Sure that the File #{input_file} Exists"
			e

		rescue Errno::EISDIR => e
			if File.directory?(input_file)
				Warning.warn "!!! Can't Decrypt a Directory.\n  >  Do You Want to Decrypt All the Contents of the Directory?"
				Warning.warn "  > Use `#{self}.files_in_directory(directory)' to Decrypt all the files\n\n"
			elsif File.directory?(output_file)
				Warning.warn "!!! You are Trying to Overwrite a Directory"
			end
			e

		rescue Errno::EACCES => e
			Warning.warn "!!! Permission Denied While Trying to Write to #{output_file}"
			e

		rescue RuntimeError => e
			Warning.warn "!!! #{input_file} is Empty. Can't Decrypt an Empty File"
			e
		end
	end

	define_singleton_method(:files_in_directory) do |directory, *exclude|
		show_files_in_directory(directory, exclude).each do |el|
			puts "Decrypting #{file = File.join(directory, el)}"
			file(file, file)
		end
	end

	define_singleton_method(:show_files_in_directory) do |directory, *exclude|
		Dir.children(directory).reject { |x| exclude.push(EXCLUDE).flatten.map(&:to_s).include?(x) }
	end
end

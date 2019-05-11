#!/usr/bin/ruby -w
require 'openssl'
STDOUT.sync = STDERR.sync = true


module Encrypt
	PATH ||= File.dirname(__FILE__)
	EXCLUDE ||= [File.join(File.basename(__FILE__)), 'decrypt.rb']
	CIPHER ||= OpenSSL::Cipher.new('AES-128-CBC').encrypt

	define_singleton_method(:file) do |input_file, output_file = nil|
		output_file = input_file unless output_file
			begin
				raise RuntimeError if File.zero?(input_file)
				@key = Array.new(32) { rand(99..99).chr }
				CIPHER.key = @key.select.with_index { |x, i| i.odd? }.join
				x = CIPHER.update(IO.read(input_file)) << CIPHER.final << "#{@key.join}"
				File.write(output_file, x)
				x[0...-32]

			rescue Errno::ENOENT => e
				Warning.warn "#{e}"
				Warning.warn '!!! Please make sure the file exists'
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

			rescue Errno::ENOTDIR => e
				Warning.warn "Make sure #{input_file} is a File"
				e

			rescue RuntimeError => e
				Warning.warn "!!! #{input_file} is Empty. Can't Encrypt an Empty File"
				e
			end
	end

	define_singleton_method(:files_in_directory) do |directory, *exclude|
		show_files_in_directory(directory, exclude).each do |file|
			puts "Encrypting #{(file = File.join(PATH, file))}"
			file(file, file)
		end
	end

	define_singleton_method(:show_files_in_directory) do |directory, *exclude|
		Dir.children(directory).reject { |x| exclude.push(EXCLUDE).flatten.map(&:to_s).include?(x) }
	end
end

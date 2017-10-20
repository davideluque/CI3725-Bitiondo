require_relative 'lexer.rb'
#!/usr/bin/env ruby

=begin
	Universidad Simon Bolivar
	CI3715: Traductores e Interpretadores

	@title Lexer del lenguaje Bitiondo

	@author David Cabeza 13-10191
	@author Fabiola Martinez 13-10838	

	@description 

=end

# MAIN
if __FILE__ == $0
	filename = ARGV[0]
	if !filename.include?".bto"
		puts "El programa tiene que ser en formato .bto"
		exit
	end
	lexer = Lexer.new(filename)
	lexer.readFile
	lexer.tokenizer
	lexer.printk
end
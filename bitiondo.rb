#!/usr/bin/env ruby

=begin
	Universidad Simon Bolivar
	CI3715: Traductores e Interpretadores

	@title Lexer del lenguaje Bitiondo

	@author David Cabeza 13-10191
	@author Fabiola Martinez 13-10838	

	@description Analizador lexicografico para el intepretador del Lenguaje Bitiondo

=end

class Lexer

	# Attributes

	# Methods
	# def initialize
	# 	correcTokens = Array.new
	# 	incorrecTokens = Array.new 
	# end

	def readFile(fileName)
		@fileName = fileName
		file = File.open(@fileName,"r")
		data = file.read
		
		data.each_line do |line|
			
			puts line

		end
 		
		file.close
		
		return data

	end
 
end

# MAIN
if __FILE__ == $0
	lexer = Lexer.new
	filename = ARGV[0]
	lexer.readFile(filename)
end
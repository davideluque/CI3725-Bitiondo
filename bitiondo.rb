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
	attr_reader :filename
	attr_reader :data
	attr_accessor :Tokens

	# Methods
	# def initialize
	# 	correcTokens = Array.new
	# 	incorrecTokens = Array.new 
	# end

	def initialize(filename)
		@filename = filename
		@tokens = []
		@line = 1
		@column = 1
	end

	def readFile
		file = File.open(@filename,"r")
		@data = file.read
 		
		file.close
		
		return true

	end

end

# MAIN
if __FILE__ == $0
	filename = ARGV[0]
	lexer = Lexer.new(filename)
	lexer.readFile
end
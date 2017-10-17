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
	attr_reader :tokensdict
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

		@tokensdict = {
			ignore: /\A#.+|\s+/,
			int: /\Aint\b/,
			bool: /\Abool\b/,
			true: /\Atrue\b/,
			false: /\Afalse\b/,
			bits: /\Abits\b/,
			plus: /\A\+/, #FIX
			minus: /\A\+/, #FIX
			mult: /\A\*/, #FIX
			# Construir expresiones regulares para detectar operadores
			bitsexpression: /\A0b[0-1]+/,
			beginbit: /\Abegin\b/,
			endbit: /\Aend\b/,
			input: /\Ainput\b/,
			output: /\Aoutput\b/,
			outputln: /\Aoutputln\b/,
			#string: Hacer
			ifcond: /\Aif\b/,
			elsecond: /\Aelse\b/,
			forcond: /\Afor\b/,
			numeric: /[0-9]+/,
			forbits: /\Aforbits\b/,
			as: /\Aas\b/,
			from: /\Afrom\b/,
			going: /\Agoing\b/,
			higher: /\Ahigher\b/,
			lower: /\Alower\b/,
			repeat: /\Arepeat\b/,
			whilecond: /\Awhile\b/,
			docond: /\Ado\b/,
			identifier: /\A[A-Za-z][A-Za-z0-9\_]*(?:\[[0-9]+\])?$/
		}

	end

	def readFile
		file = File.open(@filename,"r")
		@data = file.read
 		
		file.close
		
		return true

	end

	def tokenizer

		# Usar el contador de las columnas para ir eliminando cosas que se van encontrando de la línea
		# Colocar condicionales para cuando se encuentren cosas que ignorar (si no son cosas que ignorar
		# despues de verificar su correctitud u incorrectitud hay que gurdarlas)
		# ordenar el arreglo de tokens <- mas bonito y en base a precedencia
		# el arreglo de tokens falta por completar
		data.each_line do |line|
			tokensdict.each do |k,v|
				if (v.match(line))
					puts line
					puts k
				else
					puts "no match"
				end
			end
		
		end

	end

end

# MAIN
if __FILE__ == $0
	filename = ARGV[0]
	lexer = Lexer.new(filename)
	lexer.readFile
	lexer.tokenizer
end

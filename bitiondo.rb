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
	attr_accessor :filename
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
		@line = 0
		@column = 0

		@tokensdict = {
			# Numbers:
			numeric: /[0-9]+/,

			# Reserved words:
			beginbit: /\Abegin\b/,
			endbit: /\Aend\b/,
			ifcond: /\Aif\b/,
			elsecond: /\Aelse\b/,
			forcond: /\Afor\b/,
			forbits: /\Aforbits\b/,
			as: /\Aas\b/,
			from: /\Afrom\b/,
			going: /\Agoing\b/,
			higher: /\Ahigher\b/,
			lower: /\Alower\b/,
			whilecond: /\Awhile\b/,
			docond: /\Ado\b/,
			repeat: /\Arepeat\b/,
			input: /\Ainput\b/,
			output: /\Aoutput\b/,
			outputln: /\Aoutputln\b/,
			true: /\Atrue\b/,
			false: /\Afalse\b/,
			
			# Characters Chain
			
			# Simbols:
			plus: /\A\+\b/, 
			minus: /\A\-\b/, 
			mult: /\A\*\b/, 
			div: /\A\/\b/,

			# Data Type:
			int: /\Aint\b/,
			bool: /\Abool\b/,
			bits: /\Abits\b/,
			bitsexpression: /\A0b[0-1]+/,

			# Identifiers:
			identifier: /\A[A-Za-z][A-Za-z0-9\_]*(?:\[[0-9]+\])?$/

			# Character Unexpected
			ignore: /\A#.+|\s+/

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

			@line = @line + 1

			tokensdict.each do |k,v|
			
				if (v.match(line))
					puts "el match es "
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

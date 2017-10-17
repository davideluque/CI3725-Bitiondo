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
	attr_accessor :tokens
	attr_reader :data
	attr_reader :tokensdict
	attr_reader :ignore

	# Methods
	# def initialize
	# 	correcTokens = Array.new
	# 	incorrecTokens = Array.new 
	# end

	def initialize(filename)
		@filename = filename
		@tokens = []
		@lineno = 0
		@column = 0
		@ignore = /\A#.*|\A\s+/

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
			charchain: /\A"(\\.|[^\\"\n])*"/,
			
			# Simbols:
			plus: /\A\+/, 
			minus: /\A\-/, 
			mult: /\A\*/, 
			div: /\A\//,
			mod: /\A\%/,
			transform: /\A\@/,
			andbool: /\A\&\&/,
			orbool: /\A\|\|/,
			notbool: /\A\!/,
			lessthan: /\A\</,
			greaterthan: /\A\>/,
			lessthaneq: /\A\<\=/,
			greaterthaneq: /\A\>\=/,
			equal: /\A\=/,
			notequal: /\A\!\=/,
			notbits: /\A\~/,
			andbits: /\A\&/,
			orbits: /\A\|/,	
			exclusive: /\A\^/,
			rightshift: /\A>>/,
			leftshift: /\A<< /,
			left: /\A\[/,
			right: /\A\]/,
			bitrepres: /\A\$/,
			semicolon: /\A\;/,
			

			# Data Type:
			int: /\Aint\b/,
			bool: /\Abool\b/,
			bits: /\Abits\b/,
			bitsexpression: /\A0b[0-1]+/,

			# Identifiers:

			identifier: /\A[A-Za-z][A-Za-z0-9\_]*/
			#identifier: /\A[A-Za-z]\w*(?:\[\d+\])?$/

			# Character Unexpected
			ignore: /\A#.+|\s+/,

		}

	end

	def readFile
		file = File.open(@filename,"r")
		@data = file.read
 		
		file.close
		
		return true

	end

	def tokenizer

		# despues de verificar su correctitud u incorrectitud hay que gurdarlas)
		# ordenar el arreglo de tokens <- mas bonito y en base a precedencia
		# el arreglo de tokens falta por completar
		data.each_line do |line|

			@lineno = @lineno + 1
			@column = 1

			print "Linea ", @lineno, "\n"
	
			while line.length > 0
				
				if (line =~ @ignore)
					puts "Consegui algo para ignorar"
					puts @line
					puts $&
					@column = @column + $&.length
					line = line[$&.length..line.length]
					next

				else
					
					puts "Puede ser un error lexico o un token importante"

					tokensdict.each do |key, value|
						
						puts "Comienza la iteracion por el diccionario"
						puts key, value

						if (line =~ value)
							puts "Match con palabra buena jejeje..."
							puts $&
							tokens.push([$&, @line, @column])
							@column = @column + $&.length
							line = line[$&.length..line.length]
							break
						end
					
					end
				
				end
		
			end
			puts "Cambio de linea"
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

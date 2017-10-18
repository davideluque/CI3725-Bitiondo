#!/usr/bin/env ruby

=begin
	Universidad Simon Bolivar
	CI3715: Traductores e Interpretadores

	@title Lexer del lenguaje Bitiondo

	@author David Cabeza 13-10191
	@author Fabiola Martinez 13-10838	

	@description Analizador lexicografico para el intepretador del Lenguaje Bitiondo

=end

class Token

	attr_accessor :value, :type, :locationinfo, :is_correct
	attr_reader :tokenswithvalue

	def initialize(type, value=nil, line=0, column=0)
		@type = type
		@value = value
		@locationinfo = {
			line: line,
			column: column
		}
		@tokenswithvalue = ["string", "integer", "identifier", "bitsexpression"]
		@is_correct = true
	end

	def to_s
  	
  	if @is_correct
	  
	  	str = "#{@type} at line #{@locationinfo[:line]}, column #{@locationinfo[:column]}"
	  	if (@tokenswithvalue.include?@type)
	  		str = str + " with value `#{@value}`"
	  	end
  	
  	else
  		str = "Error: Se encontró un caracter inesperado \"#{@value}\" en la Línea #{@locationinfo[:line]}, Columna #{@locationinfo[:column]}."
  	end

  	return str

  end

end

class Lexer

	# Attributes
	attr_accessor :filename, :tokens
	attr_reader :data, :tokensdict, :ignore 

	def initialize(filename)
		@filename = filename
		@tokens = []
		@incorrecttokens = []
		@lineno = 0
		@column = 0
		@programIsCorrect = true
		@ignore = /\A#.*|\A\s+/

		@tokensdict = {

			bitsexpression: /\A0b[0-1]+/,

			# Numbers:
			integer: /\A[0-9]+/,

			# Reserved words:
			begin: /\Abegin\b/,
			end: /\Aend\b/,
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
			
			# Strings:
			string: /\A"(\\.|[^\\"\n])*"/,
			
			# Symbols:

			# Unary
			leftbracket: /\A\[/,
			rightbracket: /\A\]/,
			notbool: /\A\!/,
			notbits: /\A\~/,
			bitrepres: /\A\$/,
			transform: /\A\@/,
			minus: /\A\-/, 

			# Binary
			mult: /\A\*/, 
			div: /\A\//,
			mod: /\A\%/,
			plus: /\A\+/, 
			leftshift: /\A<</,
			rightshift: /\A>>/,
			lessthan: /\A\</,
			lessthaneq: /\A\<\=/,
			greaterthan: /\A\>/,
			greaterthaneq: /\A\>\=/,
			equalcompare: /\A\=\=/,
			notequal: /\A\!\=/,
			andbits: /\A\&/,
			exclusive: /\A\^/,
			orbits: /\A\|/,	
			andbool: /\A\&\&/,
			orbool: /\A\|\|/,

			assign: /\A\=/,
			leftpar: /\A\(/,
			rightpar: /\A\)/,
			comma: /\A,/,
			semicolon: /\A\;/,
			
			# Data Type:
			int: /\Aint\b/,
			bool: /\Abool\b/,
			bits: /\Abits\b/,

			# Identifiers:
			identifier: /\A[A-Za-z][A-Za-z0-9\_]*/
		}

	end

	def readFile

		file = File.open(@filename,"r")
		@data = file.read
 		
		file.close
		
		return true

	end

	def tokenizer

		data.each_line do |line|

			@lineno = @lineno + 1
			@column = 1

			while line.length > 0
				
				matches = false

				if (line =~ @ignore)
					matches = true
					@column = @column + $&.length
					line = line[$&.length..line.length]
					next

				else

					tokensdict.each do |key, value|

						if (line =~ value)
							matches = true
							tk = Token.new(key.to_s, $&, @lineno, @column)
							@tokens.push(tk)
							@column = @column + $&.length
							line = line[$&.length..line.length]
							break

						end

					end
						
					if !(matches)
						@programIsCorrect = false
						tk = Token.new(nil, line[0], @lineno, @column)
						tk.is_correct = false
						@incorrecttokens.push(tk)
						@column = @column + 1
						line = line[1..line.length]
					end
				
				end
		
			end
				
		end

	end

	def printk
		if (@programIsCorrect)
			tokens.each do |tk|
	  		puts tk.to_s
			end

		else
			@incorrecttokens.each do |tk|
				puts tk.to_s
			end
		
		end
	
	end

end

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

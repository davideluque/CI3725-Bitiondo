#! /usr/bin/ruby

############################################################
# Universidad Simón Bolívar
# CI3175: Traductores e interpretadores
# 
# Bitiondo
#
# Análisis sintáctico y árbol sintáctico abstracto
# 
# David Cabeza 13-10191 <13-10191@usb.ve>
# Fabiola Martínez 13-10838 <13-10838@usb.ve>
############################################################

class StatementsAndInstructionsBlockNode

	attr_reader :ident

	def initialize(statements, instructions)
		@statements = statements
		@instructions = instructions
		@ident = "  "
	end

	def printAST(ident = "  ")
		puts "BEGIN"
		@statements.printAST(@ident)
		@instructions.printAST(@ident)
		puts "END"
		return
	end
end

class StatementsBlockNode

	attr_reader :ident

	def initialize(statements)
		@statements = statements
		@ident = "  "
	end

	def printAST(ident = "  ")
		puts "BEGIN"
		puts "Hola soy declaraciones como estas"
		puts "END"
	end
end

class InstructionsBlockNode

	attr_reader :ident

	def initialize(instructions)
		@instructions = instructions
		@ident = "  "
	end

	def printAST(ident = "  ")
		puts "BEGIN"
		puts "Hola soy instrucciones como estas"
		puts "END"
	end
end

class EmptyBlockNode

	attr_reader :ident

	def initialize
		@ident = "  "
	end

	def printAST(ident = "  ")
		puts "BEGIN"
		puts "END"
	end
end

class StatementsNode

	attr_reader :ident

	def initialize(statementsNode, statementNode)
		@statementsNode = statementsNode
		@statementNode = statementNode
		@ident = "  "
	end

	def printAST(ident = "  ")
		@statementsNode.printAST(ident+@ident)
		@statementNode.printAST(ident+@ident)
	end
end

class StatementNode

	attr_reader :ident

	def initialize(type, identifier, exp1 =nil, exp2 =nil)
		@type = type
		@identifier = identifier
		@exp1 = exp1
		@exp2 = exp2
	end

	def printAST(ident)
		puts "DECLARE"
		puts "#{@ident} type: #{@type.type}"
		puts "#{@ident} variable: #{@identifier.value}"
		if exp1 then
			puts "#{@ident} size:"
			puts "#{@ident} const_#{@exp1.type}:  #{@exp1.value}"
		end
		if exp2 then
			puts "#{@ident} value:"
			puts "#{@ident} const_#{@exp2.type}: #{@exp2.value}"
		end
	end
end

class TypeNode
	def initialize (type)
		@type = type
	end
end

class ConstExpressionNode

	def initialize(value, type)
		@value = value
		@type = type
	end

end
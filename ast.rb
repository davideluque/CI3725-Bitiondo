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

	def printAST(ident = "")
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

	def printAST(ident = "")
		puts "BEGIN"
		@statements.printAST(ident+"  ")
		puts "END"
	end
end

class InstructionsBlockNode

	attr_reader :ident

	def initialize(instructions)
		@instructions = instructions
		@ident = "  "
	end

	def printAST(ident = "")
		puts "BEGIN"
		@instructions.printAST(ident)
		puts "END"
	end
end

class EmptyBlockNode

	attr_reader :ident

	def initialize
		@ident = "  "
	end

	def printAST(ident = "")
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

	def printAST(ident)
		@statementsNode.printAST(ident)
		@statementNode.printAST(ident)
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
		puts "#{ident}DECLARE"
		puts "#{ident+ident}type: #{@type.type}"
		puts "#{ident+ident}variable: #{@identifier.value}"
		if @exp1
			if @exp2 then

				if @exp2 == "nosize" then
					puts "#{ident+ident}value:"
					puts "#{ident+ident+ident}const_#{@exp1.type}: #{@exp1.value.value}"
				else
					puts "#{ident+ident}size:"
					puts "#{ident+ident+ident}const_#{@exp1.type}: #{@exp1.value.value}"
					puts "#{ident+ident}value:"
					puts "#{ident+ident+ident}const_#{@exp2.type}: #{@exp2.value.value}"
				end
			
			else
				puts "#{ident+ident}size:"
				puts "#{ident+ident+ident}const_#{@exp1.type}: #{@exp1.value.value}"
			end
		end
	end
end

class InstructionsNode

	attr_reader :ident

	def initialize(instructionsNode, instructionNode)
		@instructionsNode = instructionsNode
		@instructionNode = instructionNode
		@ident = "  "
	end

	def printAST(ident)
		@instructionsNode.printAST(ident)
		@instructionNode.printAST(ident)
	end
end

class AssignationNode

	def initialize(identifier, exp1, exp2=nil)
		@identifier = identifier
		@exp1 = exp1
		@exp2 = exp2
	end

	def printAST(ident)
		puts "#{ident}ASSIGN"
		puts "#{ident+ident}variable: #{@identifier.value}"
		if !@exp2
			puts "#{ident+ident}value:"
			puts "#{ident+ident+ident}const_#{@exp1.type}: #{@exp1.value.value}"
		else
			puts "#{ident+ident}position:"
			puts "#{ident+ident+ident}const_#{@exp1.type}: #{@exp1.value.value}"
			puts "#{ident+ident}value:"
			puts "#{ident+ident+ident}const_#{@exp2.type}: #{@exp2.value.value}"
		end
	end
end

class InputNode

	def initialize(identifier)
		@identifier = identifier
	end

	def printAST(ident)
		puts "#{ident}INPUT"
		puts "#{ident+ident}element:"
		puts "#{ident+ident+ident}variable: #{@identifier.value}"
	end

end

class OutputNode

	def initialize(type, expressions)
		@type = type
		@expressions = expressions
	end

	def printAST(ident)
		puts "#{ident}#{@type}"
		puts "#{ident+ident}elements:"
		@expressions.printAST(ident)
	end

end

class ExpressionsNode

	attr_reader :ident

	def initialize(expressionsNode, expressionNode)
		@expressionsNode = expressionsNode
		@expressionNode = expressionNode
		@ident = "  "
	end

	def printAST(ident)
		@expressionsNode.printAST(ident)
		@expressionNode.printAST(ident)
	end
end


class ConstExpressionNode

	attr_reader :type, :value

	def initialize(value, type)
		@value = value
		@type = type
	end

	def printAST(ident)
		if @type == "identifier"
			@type = "variable"
		end
		puts "#{ident+ident+ident}#{@type}: #{@value.value}"
	end

end
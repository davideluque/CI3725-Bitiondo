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
					@exp1.printAST(ident)
				else
					puts "#{ident+ident}size:"
					@exp1.printAST(ident)
					puts "#{ident+ident}value:"
					@exp2.printAST(ident)
				end
			
			else
				puts "#{ident+ident}size:"
				@exp1.printAST(ident)
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
			@exp1.printAST(ident)
		else
			puts "#{ident+ident}position:"
			@exp1.printAST(ident)
			puts "#{ident+ident}value:"
			@exp2.printAST(ident)
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

class ConditionalNode

	def initialize(expression, ins1, ins2=nil)
		@expression = expression
		@ins1 = ins1
		@ins2 = ins2
	end

	def printAST(ident)
		puts "#{ident}CONDITIONAL"
		puts "#{ident+ident}CONDITION:"
		@expression.printAST(ident)
		puts "#{ident+ident}INSTRUCTION:"
		@ins1.printAST(ident)
		if @ins2
			puts "#{ident+ident}OTHERWISE:"
			@ins2.printAST(ident)
		end
	end
end

class ForLoopNode

	def initialize(assignation, exp1, exp2, instruction)
		@assignation = assignation
		@exp1 = exp1
		@exp2 = exp2
		@instruction = instruction
	end

	def printAST(ident)
		puts "#{ident}FOR LOOP"
		puts "#{ident+ident}INITIALIZATION:"
		@assignation.printAST(ident)
		puts "#{ident+ident}CONDITION:"
		@exp1.printAST(ident)
		puts "#{ident+ident}VARIABLE UPDATE:"
		@exp2.printAST(ident)
		puts "#{ident+ident}INSTRUCTION:"
		@instruction.printAST(ident)
	end
end

class ForLoopNode

	def initialize(assignation, exp1, exp2, instruction)
		@assignation = assignation
		@exp1 = exp1
		@exp2 = exp2
		@instruction = instruction
	end

	def printAST(ident)
		puts "#{ident}FOR LOOP"
		puts "#{ident+ident}INITIALIZATION:"
		@assignation.printAST(ident)
		puts "#{ident+ident}CONDITION:"
		@exp1.printAST(ident)
		puts "#{ident+ident}VARIABLE UPDATE:"
		@exp2.printAST(ident)
		puts "#{ident+ident}INSTRUCTION:"
		@instruction.printAST(ident)
	end
end

class ForbitsLoopNode

	def initialize(exp1, identifier, exp2, direction, instruction)
		@exp1 = exp1
		@identifier = identifier
		@exp2 = exp2
		@direction = direction
		@instruction = instruction
	end

	def printAST(ident)
		puts "#{ident}FORBITS LOOP"
		puts "#{ident+ident}BITS EXPRESSION:"
		@exp1.printAST(ident)
		puts "#{ident+ident}IDENTIFIER:"
		puts "#{ident+ident+ident}value: #{@identifier.value}"
		puts "#{ident+ident}FROM:"
		@exp2.printAST(ident)
		puts "#{ident+ident}GOING:"
		puts "#{ident+ident+ident}value: #{@direction.value}"
		puts "#{ident+ident}INSTRUCTION:"
		@instruction.printAST(ident)
	end
end

class RepeatWhileLoopNode

	def initialize(ins1, expression, ins2 =nil)
		@expression = expression
		@ins1 = ins1
		@ins2 = ins2
	end

	def printAST(ident)
		puts "#{ident}REPEAT LOOP"
		puts "#{ident+ident}INSTRUCTION:"
		@ins1.printAST(ident)
		puts "#{ident+ident}WHILE:"
		@expression.printAST(ident)
		if @ins2 then
			puts "#{ident+ident}DO:"
			@ins2.printAST(ident)			
		end

	end

end

class WhileLoopNode

	def initialize(expression, instruction)
		@expression = expression
		@instruction = instruction
	end

	def printAST(ident)
		puts "#{ident}WHILE LOOP"
		puts "#{ident+ident}WHILE:"
		@expression.printAST(ident)
		puts "#{ident+ident}DO:"
		@instruction.printAST(ident)
	end

end

class ConstExpressionNode

	attr_reader :type, :value

	def initialize(value, type)
		@value = value
		@type = type
	end

	def printAST(ident)
		puts "#{ident+ident+ident}#{@type}: #{@value.value}"
	end

end

class BinExpressionNode

	def initialize(leftoperand, rightoperand, operator)
		@leftoperand = leftoperand
		@rightoperand = rightoperand
		@operator = operator
	end

	def printAST(ident)
		puts "#{ident}BIN_EXPRESSION:"
		puts "#{ident+ident}operator: #{@operator}"
		puts "#{ident+ident}left operand:"
		@leftoperand.printAST(ident)
		puts "#{ident+ident}right operand:"
		@rightoperand.printAST(ident)
	end

end

class UnaryExpressionNode

	def initialize(operand, operator)
		@operand = operand
		@operator = operator
	end

	def printAST(ident)
		puts "#{ident}UNARY_EXPRESSION:"
		puts "#{ident+ident}operand:"
		@operand.printAST(ident)
		puts "#{ident+ident+ident}operator: #{@operator}"
	end

end

class AccessNode

	def initialize(identifier, expression)
		@identifier = identifier
		@expression = expression
	end

	def printAST(ident)
		puts "#{ident}ACCESSOR"
		puts "#{ident+ident}variable: #{@identifier.value}"
		puts "#{ident+ident}position:"
		@expression.printAST(ident)
	end

end
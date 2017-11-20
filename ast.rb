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

# The classes in this file are nodes that are instantiated by the parser file. 
# These classes contain a "print" function which is responsible for making the 
# appropriate printing for each node in the requested format of the syntax tree.

# Each class has a meaning depending on the path it is taking. Their names 
# indicate the meaning of each node.

# For more information about the meaning of each node, see the file parser.y

class BlockNode

	attr_accessor :statements, :instructions

	def initialize(statements, instructions)
		@statements = statements
		@instructions = instructions
	end

	def printAST(indent="")
		puts "#{indent}BEGIN"
		if @statements
			@statements.printAST(indent+"  ")
		end
		if @instructions
			@instructions.printAST(indent+"  ")
		end
		puts "#{indent}END"
		return
	end

	def check(parentTable)
		t = SymbolTable.new(parentTable)
		
		if @statements
			@statements.check(t)
		end

		if @instructions
			puts "Voy a checar por instructions"
			@instructions.check(t)
		end

	end

end
 
class StatementsNode

	attr_accessor :statementsNode, :statementNode

	def initialize(statementsNode, statementNode)
		@statementsNode = statementsNode
		@statementNode = statementNode
	end

	def printAST(indent)
		@statementsNode.printAST(indent)
		@statementNode.printAST(indent)
	end

	def check(table)
		@statementsNode.check(table)
		@statementNode.check(table)
	end

end

class StatementNode

	def initialize(type, identifier, size, value)
		@type = type
		@identifier = identifier
		@size = size
		@value = value
	end

	def printAST(indent)
		puts "#{indent}DECLARE"
		puts "#{indent+"  "}type: #{@type.type}"
		puts "#{indent+"  "}variable: #{@identifier.value}"
		if @size
			puts "#{indent+"  "}size:"
			@size.printAST(indent+"    ")
		end
		if @value
			puts "#{indent+"  "}value:"
			@value.printAST(indent+"    ")
		end
	end

	def check(table)

		# Checking for variables of type int a; bits b[2];
		if not @size and not @value

		# Case: Variable has been declared before
			if table.isMember(@identifier.value)
				# Types are the same

				if @type.value == table.find(@identifier.value).type
					puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: La variable '#{@identifier.value}' ya ha sido declarada en este alcance"
					return
				end

				# Types are different
				table.update(@identifier.value, @type.type, nil, nil)
				return

			end

			table.insert(@identifier.value, @type.type, nil, nil)
			return

		end

		# Checking for variables of type bool a = false;
		if not @size
			if @type.type == @value.type
				table.insert(@identifier.value, @type.type, nil, @value.value)
			end
		end

		#puts "Me llamaron pa chequear estas cositas papi"
		#puts "#{@type.type} #{@identifier.value} #{@size}"
		#puts "#{@type} #{@identifier} #{@size} #{@value}"
		puts "Por cierto, me mandaron esta tabla por parametro que hagoooo"
		puts table
	end

end

class InstructionsNode

	attr_reader :indent

	def initialize(instructionsNode, instructionNode)
		@instructionsNode = instructionsNode
		@instructionNode = instructionNode
		@indent = "  "
	end

	def printAST(indent)
		@instructionsNode.printAST(indent)
		@instructionNode.printAST(indent)
	end

	def check(parentTable)
		@instructionsNode.check(parentTable)
		@instructionNode.check(parentTable)
	end

end

class AssignationNode

	def initialize(identifier, position, value)
		@identifier = identifier
		@position = position
		@value = value
	end

	def printAST(indent)
		puts "#{indent}ASSIGN"
		puts "#{indent+"  "}variable: #{@identifier.value}"
		
		if @position
			puts "#{indent+"  "}position:"
			@position.printAST(indent+"    ")
		end
	
		puts "#{indent+"  "}value:"
		@value.printAST(indent+"    ")
	end

end

class InputNode

	def initialize(identifier)
		@identifier = identifier
	end

	def printAST(indent)
		puts "#{indent}INPUT"
		puts "#{indent+"  "}element:"
		puts "#{indent+"    "}variable: #{@identifier.value}"
	end

end

class OutputNode

	def initialize(type, expressions)
		@type = type
		@expressions = expressions
	end

	def printAST(indent)
		puts "#{indent}#{@type}"
		puts "#{indent+"  "}elements:"
		@expressions.printAST(indent+"    ")
	end

end

class ExpressionsNode

	attr_reader :indent

	def initialize(expressionsNode, expressionNode)
		@expressionsNode = expressionsNode
		@expressionNode = expressionNode
		@indent = "  "
	end

	def printAST(indent)
		@expressionsNode.printAST(indent)
		@expressionNode.printAST(indent)
	end
end

class ConditionalNode

	def initialize(expression, ins1, ins2=nil)
		@expression = expression
		@ins1 = ins1
		@ins2 = ins2
	end

	def printAST(indent)
		puts "#{indent}CONDITIONAL"
		puts "#{indent+"  "}CONDITION:"
		@expression.printAST(indent+"    ")
		puts "#{indent+"  "}INSTRUCTION:"
		@ins1.printAST(indent+"    ")
		if @ins2
			puts "#{indent+"  "}OTHERWISE:"
			@ins2.printAST(indent+"    ")
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

	def printAST(indent)
		puts "#{indent}FOR LOOP"
		puts "#{indent+"  "}INITIALIZATION:"
		@assignation.printAST(indent+"    ")
		puts "#{indent+"  "}CONDITION:"
		@exp1.printAST(indent+"    ")
		puts "#{indent+"  "}VARIABLE UPDATE:"
		@exp2.printAST(indent+"    ")
		puts "#{indent+"  "}INSTRUCTION:"
		@instruction.printAST(indent+"    ")
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

	def printAST(indent)
		puts "#{indent}FORBITS LOOP"
		puts "#{indent+"  "}BITS EXPRESSION:"
		@exp1.printAST(indent+"    ")
		puts "#{indent+"  "}IDENTIFIER:"
		puts "#{indent+"    "}value: #{@identifier.value}"
		puts "#{indent+"  "}FROM:"
		@exp2.printAST(indent+"    ")
		puts "#{indent+"  "}GOING:"
		puts "#{indent+"    "}value: #{@direction.value}"
		puts "#{indent+"  "}INSTRUCTION:"
		@instruction.printAST(indent+"    ")
	end
end

class RepeatWhileLoopNode

	def initialize(ins1, expression, ins2 =nil)
		@expression = expression
		@ins1 = ins1
		@ins2 = ins2
	end

	def printAST(indent)
		puts "#{indent}REPEAT LOOP"
		puts "#{indent+"  "}INSTRUCTION:"
		@ins1.printAST(indent+"    ")
		puts "#{indent+"  "}WHILE:"
		@expression.printAST(indent+"    ")
		if @ins2 then
			puts "#{indent+"  "}DO:"
			@ins2.printAST(indent+"    ")			
		end

	end

end

class WhileLoopNode

	def initialize(expression, instruction)
		@expression = expression
		@instruction = instruction
	end

	def printAST(indent)
		puts "#{indent}WHILE LOOP"
		puts "#{indent+"  "}WHILE:"
		@expression.printAST(indent+"    ")
		puts "#{indent+"  "}DO:"
		@instruction.printAST(indent+"    ")
	end

end

class ConstExpressionNode

	attr_reader :type, :value

	def initialize(value, type)
		@value = value
		@type = type
	end

	def printAST(indent)
		puts "#{indent}#{@type}: #{@value.value}"
	end

	def check(table)
		if @type != "variable"
			return @type
		end
		if tabla.lookup(@value)
			return tabla.find(@value).type
		puts "Error. Variable no declarada. No se encontro ni en las tablas padres."
	end

end

class BinExpressionNode

	def initialize(leftoperand, rightoperand, operator)
		@leftoperand = leftoperand
		@rightoperand = rightoperand
		@operator = operator
	end

	def printAST(indent)
		puts "#{indent}BIN_EXPRESSION:"
		puts "#{indent+"  "}operator: #{@operator}"
		puts "#{indent+"  "}left operand:"
		@leftoperand.printAST(indent+"    ")
		puts "#{indent+"  "}right operand:"
		@rightoperand.printAST(indent+"    ")
	end

	def check(table)
		if @leftoperand.check(table) == @rightoperand.check(table)
			puts "Tenemos el mismo tipo"
			return
		end
		puts "No tenemos el mismo tipo"
	end

end

class UnaryExpressionNode

	def initialize(operand, operator)
		@operand = operand
		@operator = operator
	end

	def printAST(indent)
		puts "#{indent}UNARY_EXPRESSION:"
		puts "#{indent+"  "}operand:"
		@operand.printAST(indent+"    ")
		puts "#{indent+"  "}operator: #{@operator}"
	end

	def check(table)
		if operand.check(table) != "variable"
			return 	operand.check(table)
		end
		if tabla.lookup(@value)
			return tabla.find(@value).type
		puts "Error. Variable no declarada. No se encontro ni en las tablas padres."
	end

end

class AccessNode

	def initialize(identifier, expression)
		@identifier = identifier
		@expression = expression
	end

	def printAST(indent)
		puts "#{indent}ACCESSOR"
		puts "#{indent+"  "}variable: #{@identifier.value}"
		puts "#{indent+"  "}position:"
		@expression.printAST(indent+"    ")
	end

end
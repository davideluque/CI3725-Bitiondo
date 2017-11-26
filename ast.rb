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

#-----------------------------------------------------------
#
#-----------------------------------------------------------
class BlockNode

	attr_accessor :statements, :instructions

	def initialize(statements, instructions)
		@statements = statements
		@instructions = instructions
	end

#-----------------------------------------------------------
# 
#-----------------------------------------------------------
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

#-----------------------------------------------------------
# 
#-----------------------------------------------------------
	def check(parentTable)
		t = SymbolTable.new(parentTable)
		
		if @statements
			@statements.check(t)
		end

		if @instructions
			@instructions.check(t)
		end

	end

end

#-----------------------------------------------------------
# 
#-----------------------------------------------------------
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

	def initialize(type, identifier, value, size)
		@type = type
		@identifier = identifier
		@value = value
		@size = size
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
		
		# Case: Variable has been declared before
		if table.isMember(@identifier.value)
			puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: La variable '#{@identifier.value}' ya ha sido declarada en este alcance"
			return
		end

		# Variable hasnt been declared before, insert in table proper way
		if not @size and not @value
			puts @type.type
			if @type.type == "int"
				return table.insert(@identifier.value, @type.type, 0, nil)
			elsif @type.type == "bool"
				return table.insert(@identifier.value, @type.type, "false", nil)
			end
		end

		# Checking for variables of type bool a = false;
		if not @size
			if @type.type == @value.check(table)
				if @value.instance_of? BinExpressionNode or @value.instance_of? UnaryExpressionNode
					return table.insert(@identifier.value, @type.type, @value.value, nil)
				elsif @value.instance_of? ConstExpressionNode
					return table.insert(@identifier.value, @type.type, @value.value.value, nil)
				end 
			else
				puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: El tipo #{@type.type} de la declaración no coincide con el tipo de la asignación"
				return			
			end
		end

		if @size and @value

			if @value.check(table) != "bits"
				puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: El tipo #{@type.type} de la declaración no coincide con el tipo de la asignación"
				return table.insert(@identifier.value, @type.type, @size.value, @value.value)
			else

			end

		end

		if @size
			if @type.value != "bits"
				puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: La variable #{@identifier.value} no puede ser declarada con el tipo #{@type.type}"
				return
			elsif @size.check(table) != "int"
				puts "Error en línea #{@type.locationinfo[:line]}, columna #{@type.locationinfo[:column]}: El tamaño debe ser un entero"
			else
					val = "0b"
					for n in 1..Integer(@size.value.value)
						val = val + "0"
					end
					return table.insert(@identifier.value, @type.type, val, @size.value.value)
			end
		end

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

	attr_reader :identifier, :position, :value

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

	def check(table)

		if not @position
			if not table.lookup(@identifier.value)
				puts "No esta declarada. No puedes asignar"
				return
			end

		end

		if @position and @position.check(table) != "int"
			puts "La posicion no es un entero"
			return
		end

		if table.find(@identifier.value).type != @value.check(table)
			puts "Tipos que no coinciden"
			return
		end

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

	def check(table)
		if not table.lookup(@identifier.value)
			puts "Error: la variable #{@identifier.value} no fue declarada."
		end
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

	def check(table)
	 @expressions.check(table)
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

	def check(table)
		@expressionsNode.check(table)
		@expressionNode.check(table)
		return "Varias"
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

	def check(table)
		if @expression.check(table) != "bool"

			if @expression.instance_of? BinExpressionNode
				puts "Error en línea #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:line]}, columna #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:column]}: Instrucción 'if' espera expresion de tipo 'bool'"
			elsif @expression.instance_of? UnaryExpressionNode
				puts "Error en línea #{@expression.operand.value.locationinfo[:line]}, columna #{@expression.operand.value.locationinfo[:column]}: Instrucción 'if' espera expresion de tipo 'bool'"
			elsif
				@expression.instance_of? ConstExpressionNode
					puts "Error en línea #{@expression.value.locationinfo[:line]}, columna #{@expression.value.locationinfo[:column]}: Instrucción 'if' espera expresion de tipo 'bool'"
			else
				puts "Instruccion 'if' espera expresion de tipo 'bool'"
			end
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

	def check(table)
		
		# ----------------------TO DO------------------------- 
		# Buscarle un uso a esta tabla de símbolos
		# ----------------------------------------------------
		# The for loop has its own table with the loop variable
		t = SymbolTable.new(table)
		
		# Get assignation needed parameters
		id = @assignation.identifier.value
		pos = @assignation.position
		val = @assignation.value

		# Case: Assignation is like b[0] = 1;
		if pos
			puts "Error en línea #{@assignation.identifier.locationinfo[:line]}, columna #{@assignation.identifier.locationinfo[:column]}: Inicialización de #{id} incorrecta."
			return
		end

		# Case: Variable has been declared before
		if t.lookup(id)
			puts "Error: Variable #{id} declarada anteriormente"
			return
		end


		# Case: assignation is not integer
		if val.check(table) != "int"
			puts "Error en el for, la asignación no es un entero"
			return
		#elsif val.instance_of? BinExpressionNode

			#t.lookup(val.value.value)
		#	puts "Variable asignada en el for no declarada"
		#	return
		end

		# After making sure that the identifier was properly declarated 
		# in the for scope, make sure that the condition is boolean and 
		# identifier is detected as a declared variable if used in the 
		# condition.
		table.insert(id, val.check(table), val, nil)

		if @exp1.check(table) != "bool"
			puts "Error en línea #{findLeftMostOperand(@exp1).value.locationinfo[:line]}, columna #{findLeftMostOperand(@exp1).value.locationinfo[:column]}: El tipo de la condición debe ser booleano"
			return 
		end

		# identifier is not itself a symbol for this scope.
		table.delete(id)

		if @exp2.check(table) != "int"
			puts "Error en línea #{findLeftMostOperand(@exp2).value.locationinfo[:line]}, columna #{findLeftMostOperand(@exp2).value.locationinfo[:column]}: El tipo de la expresión que actualiza la variable (paso) debe ser entero"
		end

		@instruction.check(table)

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

	def check(table)
		if @expression.check(table) != "bool"

			if @expression.instance_of? BinExpressionNode
				puts "Error en línea #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:line]}, columna #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			elsif @expression.instance_of? UnaryExpressionNode
				puts "Error en línea #{@expression.operand.value.locationinfo[:line]}, columna #{@expression.operand.value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			elsif
				@expression.instance_of? ConstExpressionNode
					puts "Error en línea #{@expression.value.locationinfo[:line]}, columna #{@expression.value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			else
				puts "Instruccion 'while' espera expresion de tipo 'bool'"
			end
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

	def check(table)
		if @expression.check(table) != "bool"

			if @expression.instance_of? BinExpressionNode
				puts "Error en línea #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:line]}, columna #{findLeftMostOperand(@expression.leftoperand).value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			elsif @expression.instance_of? UnaryExpressionNode
				puts "Error en línea #{@expression.operand.value.locationinfo[:line]}, columna #{@expression.operand.value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			elsif
				@expression.instance_of? ConstExpressionNode
					puts "Error en línea #{@expression.value.locationinfo[:line]}, columna #{@expression.value.locationinfo[:column]}: Instrucción 'while' espera expresion de tipo 'bool'"
			else
				puts "Instruccion 'while' espera expresion de tipo 'bool'"
			end
		end
	end
end

class BinExpressionNode

	attr_reader :leftoperand, :rightoperand, :operator, :value

	def initialize(leftoperand, rightoperand, operator)
		@leftoperand = leftoperand
		@rightoperand = rightoperand
		@operator = operator
		@value = "#{@leftoperand.value} #{@operator} #{@rightoperand.value}"
		
		# Key is operand, array[0] is left expected operator, 
		# array[1] is right expected operator, array[2] is result
		# type
		@validOperations = {
			
			'sum'=> 	['PLUS', 'int', 'int', 'int'],
			'sub'=> 	['MINUS', 'int', 'int', 'int'],
			'mul'=> 	['MULTIPLICATION', 'int', 'int', 'int'],
			'div'=> 	['DIVISION', 'int', 'int', 'int'],
			'mod'=> 	['MODULUS', 'int', 'int', 'int'],

			'lt'=> 	['LESSTHAN', 'int', 'int', 'bool'],
			'gt'=> 	['GREATERTHAN', 'int', 'int', 'bool'],
			'lte'=> 	['LESSTHANEQUAL', 'int', 'int', 'bool'],
			'gte'=> 	['GREATERTHANEQUAL', 'int', 'int', 'bool'],

			'eqint'=> ['ISEQUAL', 'int', 'int', 'bool'],			
			'difint'=> ['ISNOTEQUAL', 'int', 'int', 'bool'],
			'eqbool'=> ['ISEQUAL', 'bool','bool', 'bool'],
			'difbool'=> ['ISNOTEQUAL', 'bool', 'bool', 'bool'],
			'eqbits'=> ['ISEQUAL', 'bits','bits', 'bool'],
			'difbits'=> ['ISNOTEQUAL', 'bits', 'bits', 'bool'],

			'andbit'=> 	['ANDBITS', 'bits', 'bits', 'bits'],
			'orbit'=> 	['ORBITS', 'bits', 'bits', 'bits'],
			'excl'=> 	['TRANSFORM', 'bits', 'bits', 'bits'],
			'rshift'=> ['LEFTSHIFT', 'bits', 'int', 'bits'],
			'lshift'=> ['RIGHTSHIFT', 'bits', 'int', 'bits'],

			'and'=> 	['ANDBOOL', 'bool', 'bool', 'bool'],
			'or'=> 	['ORBOOL', 'bool', 'bool', 'bool'],
		}
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

		operandoDeclarado = true

		if @leftoperand.check(table) == "variable"
			if table.lookup(@leftoperand.value.value)
				leftType = table.find(@leftoperand.value.value).type
				puts leftType
			else
				operandoDeclarado = false
				puts "Error en línea #{findLeftMostOperand(@leftoperand).value.locationinfo[:line]}, columna #{findLeftMostOperand(@leftoperand).value.locationinfo[:column]}: El operando #{@leftoperand.value.value} no fue declarado"
				return
			end
		else
			leftType = @leftoperand.check(table)
		end

		if @rightoperand.check(table) == "variable"
			if table.lookup(@rightoperand.value.value)
				rightType = table.find(@rightoperand.value.value).type
			else
				operandoDeclarado = false
				puts "Error en línea #{findLeftMostOperand(@rightoperand).value.locationinfo[:line]}, columna #{findLeftMostOperand(@rightoperand).value.locationinfo[:column]}: El operando #{@rightoperand.value.value} no fue declarado"
				return
			end
		else
			rightType = @rightoperand.check(table)	
		end

		if operandoDeclarado
			@validOperations.each do |op, value|
				if leftType == value[1] and @operator == value[0] and rightType == value[2]
					return value[3]
				end
			end
		end

		if @leftoperand.instance_of? BinExpressionNode
			puts "Error en línea #{findLeftMostOperand(@leftoperand).value.locationinfo[:line]}: #{@operator} no puede funcionar con estos tipos"
			return

		elsif @leftoperand.instance_of? UnaryExpressionNode
			puts "Error: #{@operator} no puede funcionar con estos tipos"
			return
		else
			puts "Error en línea #{findLeftMostOperand(@leftoperand).value.locationinfo[:line]}, columna #{@leftoperand.value.locationinfo[:column]}: #{@operator} no puede funcionar con estos tipos"
			return
		end
	end

end

class UnaryExpressionNode

	attr_reader :operand, :operator, :value

	def initialize(operand, operator)
		@operand = operand
		@operator = operator
		@value = "#{operator} #{operand}"
	
		@validUnaryOperations = {

			'-'=> ['UMINUS', 'int', 'int'],
			'@'=> ['TRANSFORM', 'int', 'bits'],
			'!'=> ['NOT', 'bool', 'bool'],
			'$'=> ['BITREPRESENTATION', 'bits', 'int'],
			'~'=> ['NOTBITS', 'bits', 'bits']
		}
	end

	def printAST(indent)
		puts "#{indent}UNARY_EXPRESSION:"
		puts "#{indent+"  "}operand:"
		@operand.printAST(indent+"    ")
		puts "#{indent+"  "}operator: #{@operator}"
	end

	def check(table)
		
		operandoDeclarado = true

		if @operand.check(table) == "variable"
			if table.lookup(@operand.value.value)
				type = table.find(@operand.value.value).type
			else
				operandoDeclarado = false
				puts "Error: El operando #{@rightoperand.value.value} no fue declarado"
				return
			end
		else
			type = @operand.check(table)	
		end

		if operandoDeclarado
			@validUnaryOperations.each do |op, value|
				if type == value[1] and @operator == value[0]
					return value[2]
				end
			end
		end

		puts "Error en línea #{@operand.value.locationinfo[:line]}, columna #{@operand.value.locationinfo[:column]}: #{@operator} no puede funcionar con estos tipos"
		return

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

		if table.lookup(@value.value)
			if table.find(@value.value).value
				return table.find(@value.value).type
			else
				return "variable"
			end
		else
			return "variable"
		end

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

def findLeftMostOperand(leftOperand)

	if leftOperand.instance_of? ConstExpressionNode
		return leftOperand
	else
		if leftOperand.instance_of? BinExpressionNode
			return findLeftMostOperand(leftOperand.leftoperand)
		elsif leftOperand.instance_of? UnaryExpressionNode
			return findLeftMostOperand(leftOperand.operand)	
		else
			return leftOperand
		end
	end
end

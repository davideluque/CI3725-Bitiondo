#! /usr/bin/ruby

############################################################
# Universidad Simón Bolívar
# CI3175: Traductores e interpretadores
# 
# Bitiondo
#
# Gramática libre de contexto para Bitiondo
# 
# David Cabeza 13-10191 <13-10191@usb.ve>
# Fabiola Martínez 13-10838 <13-10838@usb.ve>
############################################################

class Parser

	# Precedence for tokens in Bitiondo
  prechigh
    right '['
    left ']'
    right '$' '@' '!' '~' UMINUS
    left '*' '/' '%'
    left '+' '-'
    left '<<' '>>'
    nonassoc '<' '<=' '>' '>='
    left '==' '!='
    left '&'
    left '^'
    left '|'
    left '&&'
    left '||'
  preclow

	# Valid token list in Bitiondo
	token '[' ']' '!' '~' '$' '@' UMINUS '*' '/' '%' '+' '-' '<<' '>>' '<' 
		  	'<=' '>' '>=' '==' '!=' '&' '^' '|' '&&' '||' '=' '(' ')' ',' 'bitexpr' 
		  	'integer' 'begin' 'end' 'if' 'else' 'for' 'forbits' 'as' 'from' 'going' 
		  	'higher' 'lower' 'while' 'do' 'repeat' 'input' 'output' 'outputln' 'true' 
		  	'false' 'string' ';' 'identifier' 'bool' 'int' 'bits'

	start S

	# Definition of context-free grammar admitted by Bitiondo
	rule

		# Initial rule. General structure of bitiondo
		S
		: BLOCK {result = val[0]}
		;

		# Blocks in bitiondo are defined by begin and end keywords
		BLOCK
		: 'begin' STATEMENTS INSTRUCTIONS 'end' {result = StatementsAndInstructionsBlockNode.new(val[1], val[2])}
		| 'begin' STATEMENTS 'end' 							{result = StatementsBlockNode.new(val[1])}
		| 'begin' INSTRUCTIONS 'end' 						{result = InstructionsBlockNode.new(val[1])}
		| 'begin' 'end' 												{result = EmptyBlockNode.new}
		;

		# Statements rule. Bitiondo can have several statements or one
		STATEMENTS
		: STATEMENTS STATEMENT {result = StatementsNode.new(val[0], val[1])}
		| STATEMENT 						{result = val[0]}
		;

		STATEMENT
		: TYPE 'identifier' ';' 																	{result = StatementNode.new(val[0], val[1])}
		| TYPE 'identifier' '=' EXPRESSION ';'  									{result = StatementNode.new(val[0], val[1], val[3], 'nosize')}
		| TYPE 'identifier' '[' EXPRESSION ']' ';' 								{result = StatementNode.new(val[0], val[1], val[3])} 
		| TYPE 'identifier' '[' EXPRESSION ']' '=' EXPRESSION ';' {result = StatementNode.new(val[0], val[1], val[3], val[6])}
		;

		TYPE
		: 'int' {result = val[0]}
		| 'bool' {result = val[0]}
		| 'bits' {result = val[0]}
		;

		INSTRUCTIONS
		: INSTRUCTIONS INSTRUCTION {result = InstructionsNode.new(val[0], val[1])}
		| INSTRUCTION {result = val[0]}
		;

		INSTRUCTION
		: BLOCK {result = val[0]}
		| ASSIGNATION {result = val[0]}
		| INPUT {result = val[0]}
		| OUT {result = val[0]}
		| CONDITIONAL {result = val[0]}
		| FOR {result = val[0]}
		| FORBITS {result = val[0]}
		| WHILE {result = val[0]}
		;

		ASSIGNATION
		: 'identifier' '=' EXPRESSION ';' {result = AssignationNode.new(val[0], val[2])}
		| 'identifier' '[' EXPRESSION ']' '=' EXPRESSION ';' {result = AssignationNode.new(val[0], val[2], val[5])}
		;

		INPUT
		: 'input' 'identifier' ';' {result = InputNode.new(val[1])}
		;	

		OUT
		: 'output' EXPRESSIONS ';' {result = OutputNode.new('OUTPUT', val[1])}
		| 'outputln' EXPRESSIONS ';' {result = OutputNode.new('OUTPUTLN', val[1])}
		;

		EXPRESSIONS
		: EXPRESSIONS ',' EXPRESSION {result = ExpressionsNode.new(val[0], val[2])}
		| EXPRESSION {result = val[0]}
		;

		CONDITIONAL
		: 'if' '(' EXPRESSION ')' INSTRUCTION {result = ConditionalNode.new(val[2], val[4])}
		| 'if' '(' EXPRESSION ')' INSTRUCTION 'else' INSTRUCTION {result = ConditionalNode.new(val[2], val[4], val[6])}
		;

		FOR
		: 'for' '(' ASSIGNATION EXPRESSION ';' EXPRESSION ')' INSTRUCTION {result = ForNode.new(val[2], val[3], val[5], val[7])}
		;

		FORBITS
		: 'forbits' EXPRESSION 'as' 'identifier' 'from' EXPRESSION 'going' DIRECTION INSTRUCTION {result = ForbitsNode.new(val[1], val[3], val[5], val[7], val[8])}
		;

		DIRECTION
		: 'higher' {result = val[0]}
		| 'lower' {result = val[0]}
		;

		WHILE
		: 'repeat' INSTRUCTION 'while' '(' EXPRESSION ')' 'do' INSTRUCTION {result = WhileNode.new(val[0], val[1], val[4], val[7])}
		| 'while' '(' EXPRESSION ')' 'do' INSTRUCTION {result = WhileNode.new(val[0], val[2], val[5])}
		| 'repeat' INSTRUCTION 'while' '(' EXPRESSION ')' {result = WhileNode.new(val[0], val[1], val[4])}
		;

		EXPRESSION
		: EXPRESSION '*' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| EXPRESSION '/' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'DIVISION')}
		| EXPRESSION '%' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MODULUS')}
		| EXPRESSION '+' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'PLUS')}
		| EXPRESSION '-' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MINUS')}
		| EXPRESSION '<<' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'LEFTSHIFT')}
		| EXPRESSION '>>' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'RIGHTSHIFT')}
		| EXPRESSION '<' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'LESSTHAN')}
		| EXPRESSION '<=' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'LESSTHANEQUAL')}
		| EXPRESSION '>' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'GREATERTHAN')}
		| EXPRESSION '>=' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'GREATERTHANEQUAL')}
		| EXPRESSION '==' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'ISEQUAL')}
		| EXPRESSION '!=' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'ISDIFFERENT')}
		| EXPRESSION '&' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'BOOLEANAND')}
		| EXPRESSION '^' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| EXPRESSION '|' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'BOOLEAN OR')}
		| EXPRESSION '&&' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| EXPRESSION '||' EXPRESSION 	{result = BinExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| '!' EXPRESSION 							{result = UnaryExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| '~' EXPRESSION 							{result = UnaryExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| '$' EXPRESSION 							{result = UnaryExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| '@' EXPRESSION 							{result = UnaryExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| '-' EXPRESSION =UMINUS 			{result = UnaryExpressionNode.new(val[0], val[2], 'MULTIPLICATION')}
		| 'identifier' 								{result = ConstExpressionNode.new(val[0], "identifier")}
		| 'integer' 									{result = ConstExpressionNode.new(val[0], "int")}
		| 'bitexpr' 									{result = ConstExpressionNode.new(val[0], "bits")}
		| 'true' 											{result = ConstExpressionNode.new(val[0], "const")}
		| 'false' 										{result = ConstExpressionNode.new(val[0], "const")}
		| 'string' 										{result = ConstExpressionNode.new(val[0], "string")}
		| 'identifier' '[' EXPRESSION ']' {puts val}
		;

end

---- header

require_relative "ast.rb"

class SyntacticError < RuntimeError

	def initialize(token)
		@token = token
	end

	def to_s
		"ERROR: unexpected token '#{@token.type}' at line #{@token.locationinfo[:line]}, column #{@token.locationinfo[:column]}"
	end

end

---- inner

def initialize(lexer)
    @lexer = lexer
end

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end

def next_token
    if @lexer.has_next_token then
        token = @lexer.next_token;
        return [token.type,token]
    else
        return nil
    end
end

def parse
    do_parse
end
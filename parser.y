#!/usr/bin/env ruby

# Universidad Simon Bolivar
# CI3715: Traductores e Interpretadores
#
# Gramática libre de contexto para Retina
#
# author David Cabeza 13-10191
# author Fabiola Martinez 13-10838	
#
# description Análisis sintáctico y árbol sintáctico abstracto

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

	# Definition of context-free grammar admitted by Bitiondo
	rule

		# Initial rule. General structure of bitiondo
		S
		: BLOCK {result = S_node.new(val[1])}
		;

		DECLARATIONS
		: DECLARATIONS DECLARATION {result = [val[0]]}
		| DECLARATION
		;

		DECLARATION
		: TYPE 'identifier' ';'
		| TYPE ASSIGNATION
		| TYPE BITSDECLARATION 
		;

		BITSDECLARATION
		: TYPE 'identifier' '[' EXPRESSION ']' ';'
		| TYPE 'identifier' '[' EXPRESSION ']' '=' 'bitexpr' ';'
		;

		TYPE
		: 'int'
		| 'bool'
		| 'bits'
		;

		INSTRUCTIONS
		: INSTRUCTIONS INSTRUCTION
		| INSTRUCTION
		;

		INSTRUCTION
		: BLOCK
		| ASSIGNATION
		| INPUT
		| OUT
		| CONDITIONAL
		| FOR
		| FORBITS
		| WHILE
		;

		BLOCK
		: 'begin' DECLARATIONS INSTRUCTIONS 'end'
		| 'begin' DECLARATIONS 'end'
		| 'begin' INSTRUCTIONS 'end'
		| 'begin' 'end' {puts val[0]}
		;

		ASSIGNATION
		: 'identifier' '=' EXPRESSION ';'
		| 'identifier' '[' EXPRESSION ']' '=' EXPRESSION ';'
		;

		INPUT
		: 'input' 'identifier' ';'
		;	

		OUT
		: 'output' EXPRESSIONS ';'
		| 'outputln' EXPRESSIONS ';'
		;

		EXPRESSIONS
		: EXPRESSIONS ',' EXPRESSION
		| EXPRESSION
		;

		CONDITIONAL
		: 'if' '(' EXPRESSION ')' INSTRUCTION
		| 'if' '(' EXPRESSION ')' INSTRUCTION 'else' INSTRUCTION
		;

		FOR
		: 'for' '(' ASSIGNATION EXPRESSION ';' EXPRESSION ')' INSTRUCTION
		;

		FORBITS
		: 'forbits' EXPRESSION 'as' 'identifier' 'from' EXPRESSION 'going' DIRECTION INSTRUCTION
		;

		DIRECTION
		: 'higher'
		| 'lower'
		;

		WHILE
		: 'repeat' INSTRUCTION 'while' '(' EXPRESSION ')' 'do' INSTRUCTION
		| 'while' '(' EXPRESSION ')' 'do' INSTRUCTION
		| 'repeat' INSTRUCTION 'while' '(' EXPRESSION ')'
		;

		EXPRESSION
		: EXPRESSION '*' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '/' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'INTEGER DIVISION', val[1])}
		| EXPRESSION '%' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MODULUS', val[1])}
		| EXPRESSION '+' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'PLUS', val[1])}
		| EXPRESSION '-' EXPRESSION 		{result = Arith_bin_expr_node.new(val[0], val[2], 'SUBSTRACTION', val[1])}
		| EXPRESSION '<<' EXPRESSION 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '>>' EXPRESSION {result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '<' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '<=' EXPRESSION 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '>' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '>=' EXPRESSION 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '==' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '!=' EXPRESSION 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '&' EXPRESSION 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '^' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '|' EXPRESSION 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '&&' EXPRESSION 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| EXPRESSION '||' EXPRESSION 				{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		| '!' EXPRESSION
		| '~' EXPRESSION
		| '$' EXPRESSION
		| '@' EXPRESSION
		| '-' EXPRESSION =UMINUS
		| 'identifier'
		| 'integer'
		| 'bitexpr'
		| 'true'
		| 'false'
		| 'string'
		;

end

---- header

require_relative "lexer.rb"
require_relative "ast.rb"

class SyntacticError < RuntimeError

	def initialize(token)
		@token = token
	end

	def to_s
		puts "ERROR: unexpected token {$} at line {$}"

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
#!/usr/bin/env ruby

=begin
	Universidad Simon Bolivar
	CI3715: Traductores e Interpretadores

	@title Gramática libre de contexto para Retina

	@author David Cabeza 13-10191
	@author Fabiola Martinez 13-10838	

	@description Análisis sintáctico y árbol sintáctico abstracto

=end

class Parser:

	# Precedence for tokens in Bitiondo
	prechigh
		left MULT DIV 
	preclow

	# Valid token list in Bitiondo
	token BITSEXPR INTEGER BEGIN END IF ELSE FOR FORBITS AS 
				FROM GOING HIGHER LOWER WHILE DO REPEAT INPUT
				OUTPUT OUTPUTLN TRUE FALSE STRING LEFTBR RIGHTBR
				NOTBITS BITREPR TRANSFORM MINUS MULT DIV MOD PLUS
				LEFTSHFT RIGHTSHFT LTEOP GTEOP LTOP GTOP ECOP NOTEQOP
				NOTOP AND ANDBITS EXCL OR ORBITS ASSIGNOP LPARENTH
				RPARENTH COMMA SEMICOLON INT BOOL BITS IDENTIFIER
				STRING

	# Definition of context-free grammar admitted by Bitiondo
	rule

		# Initial rule. General structure of bitiondo
		S
		: BEGIN main END {result = S_node.new(val[1])}
		;

		main
		: declarations reproducer {result = Main_node.new(val[0], val[1])}
		| reproducer							{result = Main_node.new(nil, val[0])}
		;

		declarations
		: declaration declarations {result = [val[0]]}
		| declaration
		;

		declaration
		: tipo IDENTIFIER SEMICOLON
		| tipo assignation
		| bitsdeclaration 
		;

		bitsdeclaration
		: BITS IDENTIFIER LEFTBR INTEGER RIGHTBR SEMICOLON
		| BITS IDENTIFIER LEFTBR INTEGER RIGHTBR ASSIGNOP BITSEXPR SEMICOLON
		;

		tipo
		: INT
		| BOOL
		;

		reproducer
		: instruction reproducer
		|
		;

		instruction
		: block
		| assignation
		| input
		| out
		| conditional
		| for
		| forbits
		| while
		|
		;

		block
		: BEGIN main END
		|
		;

		assignation
		: IDENTIFIER ASSIGNOP expr SEMICOLON
		;

		input
		: IDENTIFIER SEMICOLON
		;	

		out
		: output SEMICOLON
		| outputln SEMICOLON
		;

		output
		: multiexpr 
		;

		multiexpr
		: expr COMMA multiexpr | expr
		;

		outputln
		: multiexpr
		;

		conditional
		: IF LPARENTH expr RPARENTH insdec
		| IF LPARENTH expr RPARENTH insdec ELSE insdec
		;

		insdec
		: instruction
		| declaration
		;

		for
		: FOR LPARENTH assignation expr SEMICOLON INTEGER RPARENTH insdec
		;

		forbits
		: FORBITS expr AS IDENTIFIER FROM INTEGER GOING direction insdec
		;

		direction
		: HIGHER
		| LOWER
		;

		while
		: REPEAT insdec WHILE LPARENTH expr RPARENTH DO insdec
		| WHILE LPARENTH expr RPARENTH DO insdec
		| REPEAT insdec WHILE LPARENTH expr RPARENTH
		;

		expr
		: expr MULT expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr DIV expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'INTEGER DIVISION', val[1])}
		: expr MOD expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MODULUS', val[1])}
		: expr PLUS expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'PLUS', val[1])}
		: expr MINUS expr 		{result = Arith_bin_expr_node.new(val[0], val[2], 'SUBSTRACTION', val[1])}
		: expr LEFTSHFT expr 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr RIGHTSHFT expr {result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr LTOP expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr LTEOP expr 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr GTOP expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr GTEOP expr 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr ECOP expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr NOTEQOP expr 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr ANDBITS expr 	{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr EXCL expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr ORBITS expr 		{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr AND expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr OR expr 				{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: expr MULT expr 			{result = Arith_bin_expr_node.new(val[0], val[2], 'MULTIPLICATION', val[1])}
		: NOTBOOL expr
		: NOTBITS expr
		: BITREPR expr
		: TRANSFORM expr
		: MINUS expr =UMINUS
		: IDENTIFIER
		: INTEGER
		: BITSEXPR
		: TRUE
		: FALSE
		: STRING
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
	raise SyntacticError
end


# def next_token
# 	if @lexer.
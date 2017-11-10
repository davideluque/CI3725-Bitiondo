#!/usr/bin/env ruby

=begin
	Universidad Simon Bolivar
	CI3715: Traductores e Interpretadores

	@title Gramática libre de contexto para Retina

	@author David Cabeza 13-10191
	@author Fabiola Martinez 13-10838	

	@description Análisis sintáctico y árbol sintáctico abstracto

=end

class AST

	def print_ast
			
	end

end


class S_node:

	attr_accessor :main

	def initialize main
		@main = main
	end

	def print_ast
		puts "BEGIN"
		@main.print_ast("    ")
		puts "END"
	end

end

class Main_node:

	def initialize declarations, reproducer:
		@decl = declarations
		@repr = reproducer
	end

	def print_ast ident

		if @decl
		@decl.print_ast(ident + "    ")
		end

		@repr.print_ast(ident + "    ")

	end

end


class Declarations:

	def print_ast ident:

		CICLO POR CADA TOKEN DECLARADO

		puts

end
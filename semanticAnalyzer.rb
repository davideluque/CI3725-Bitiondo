#! /usr/bin/ruby

############################################################
# Universidad Simón Bolívar
# CI3175: Traductores e interpretadores
# 
# Bitiondo
#
# Analizador semántico para Bitiondo
#
# 
# David Cabeza 13-10191 <13-10191@usb.ve>
# Fabiola Martínez 13-10838 <13-10838@usb.ve>
############################################################

#require_relative "symtable.rb"

class SemanticAnalyzer

	def initialize(ast)
		@ast = ast
		#@symTable = SymTable.new
	end

	def analyze

		handler(@ast)

	end

	def handler ast
		if ast.statements
			puts ast.statements
		end
		if ast.instructions
		puts ast.instructions
		end
	end

end 
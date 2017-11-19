#! /usr/bin/ruby

############################################################
# Universidad Simón Bolívar
# CI3175: Traductores e interpretadores
# 
# Bitiondo
#
# Tabla de símbolos para Bitiondo
#
# 
# David Cabeza 13-10191 <13-10191@usb.ve>
# Fabiola Martínez 13-10838 <13-10838@usb.ve>
############################################################

#-----------------------------------------------------------
# Simbolos para la tabla de símbolos
#-----------------------------------------------------------
class Symbol

	attr_reader	:name, :type, :value, :size

	def initialize(name, type, value, size)
		@name = name
		@type = type
		@value = value
		@size = size
	end

	def getName()
		return @name
	end

	def getType()
		return @type
	end

	def getValue()
		return @value
	end

	def getSize()
		@size ? return @size : return
	end

end

#-----------------------------------------------------------
# Tabla de Símbolos
#-----------------------------------------------------------
class SymbolTable

	def new(scope, parentTable)
		@symTable = Hash.new
		@scope = scope
		@parentTable = parentTable
	end

	def insert(name, type, value, size)

		if size
			s = Symbol.new(name, type, value, size)
			symTable[:name] = s
			return true
		else
			s = Symbol.new(name, type, value)
			symTable[:name] = s
			return true
		end

		return false
	
	end

	def delete(name)
		return @symTable.delete(name)
	end

	# def update()

	# end

	# def isMember()

	# end

	# def find()

	# end

end
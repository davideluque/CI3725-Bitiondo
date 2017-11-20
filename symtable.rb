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

# class Tree

# 	attr_reader :

# end

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
		if @size
			return @size
		end
		return
	end

end

#-----------------------------------------------------------
# Tabla de Símbolos
#-----------------------------------------------------------
class SymbolTable

	def initialize(parentTable)
		@symTable = Hash.new
		#@scope = scope
		@parentTable = parentTable
	end

	def insert(name, type, value, size)

		if value
			
			if size
				s = Symbol.new(name, type, value, size)
				symTable[:name] = s
				return true
			end
			
			s = Symbol.new(name, type, value, nil)
			return true

		elsif not value
			
			if size
				s = Symbol.new(name, type, nil, size)
				return true
			end

			s = Symbol.new(name, type, nil, nil)
			return true
		end

		return false
	
	end

	def delete(name)
		return @symTable.delete(name)
	end

	def update(name, type, value, size)
		insert(name, type, value, size)
	end

	def isMember()
		return @symTable.has_key?(name)
	end

	def find(name)
		if @symTable.has_key?(name)
			return @symTable[:name]
		end
		return false 
	end

end
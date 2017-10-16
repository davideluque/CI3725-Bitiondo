#!/usr/bin/env ruby

=begin
Universidad Simon Bolivar
Traductiores e Interpretadores

@title Analizador lexico grafico para el intepretador del Lenguaje Bitiondo

@autor David Cabeza 13-10191
@autor Fabiola Martinez 13-10838	

=end

# def initialize
# 	correcTokens = Array.new
# 	incorrecTokens = Array.new 
# end

def readFile(fileName)
	@fileName = fileName
	file = File.open(@fileName,"r")
	data = file.read
	
	data.each_line do |line|
		
		tokenArray = line.split

		tokenArray.each do |token|
			puts token
		end
	end 
	
	file.close
	
	return data
end

def match(fileName)

	data = readFile(fileName)
	
end

readFile("entrada.txt")



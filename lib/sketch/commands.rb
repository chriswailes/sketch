# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	Command definitions.

require 'pp'

module Sketch
	module Commands
		
		##################
		# Infrestructure #
		##################
		
		@commands = Hash.new
		
		def self.command(key, &block)
			@commands[key] = block
		end
		
		def self.call(key)
			key = key.to_sym
			
			if @commands.key?(key)
				@commands[key].call
			else
				puts "Invalid command: #{key}"
			end
		end
		
		########
		# Data #
		########
		
		INIT_FILES = [
			'AUTHORS',
			'LICENSE',
			'README.md',
			'TODO',
			
			'.gitignore',
			'.sketch'
		]
		
		############
		# Commands #
		############
		
		command :init do
			pp CONFIG
		end
	end
end

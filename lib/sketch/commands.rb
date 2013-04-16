# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	Command definitions.

require 'pp'

module Sketch
	module Commands
		
		###########
		# Classes #
		###########
		
		class Command
			def initialize
			
			end
		end
		
		##################
		# Infrestructure #
		##################
		
		@commands = Hash.new
		
		def self.command(name, *rest, &block)
			@commands[name] = Command.new(name, *rest, &block)
		end
		
		def self.call(name)
			name = name.to_sym
			
			if @commands.key?(name)
				@commands[name].call
			else
				puts "Invalid command: #{name}"
			end
		end
		
		########
		# Data #
		########
		
		INIT_FILES = {
			'AUTHORS'		=> ->() { "#{CONFIG.author} <#{CONFIG.author_email}>" },
			'LICENSE'		=> ->() { LICENSES[CONFIG.license] },
			'README.md'	=> ->() {},
			'TODO'		=> ->() {},
			
			'.gitignore'	=> ->() { CONFIG.language_module.gitignore },
			'.sketch'		=> ->() { CONFIG.dump_project_config }
		}
		
		############
		# Commands #
		############
		
		command :init,
			[:language, "Project's main language"],
			[:working_path, "Project's root directory", FileUtils.pwd],
			"Initialize a project directory with general project files and language specific files." do
			
			project_init_files = INIT_FILES.clone.update CONFIG.language_module.init_files
			
			pp project_init_files.keys
		end
		
		####################
		# Helper Functions #
		####################
		
	end
end

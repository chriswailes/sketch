# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	Command definitions.

require 'fileutils'
require 'pp'

module Sketch
	module Commands
		
		###########
		# Classes #
		###########
		
		class Command
			def initialize(name, *params, help, block)
				@name	= name
				@params	= params.map { |p| Parameter.new(*p) }
				@help	= help
				@block	= block
			end
			
			class Parameter
				attr_reader :name
				attr_reader :default
				
				def initialize(name, help, default = nil)
					@name	= name
					@help	= help
					@default	= default
				end
				
				def print_help(max_length, singleton)
					print "\t" unless singleton
					printf "\t%-#{max_length}s - %s\n", @name, @help
				end
				
				def to_s
					if @default
						"<#{@name}>"
					else
						"[#{@name}]"
					end
				end
			end
			
			def call
				@params.each do |p|
					if not ARGV.empty?
						CONFIG.set(p.name, ARGV.shift)
						
					else
						if p.default
							CONFIG.set(p.name, p.default)
						else
							raise "No value provided for #{p.name}."
						end
					end
					
					
				end
				
				@block.call
			end
			
			def print_help(singleton = false)
				print "\t" unless singleton
				
				print "#{@name} "
				@params.each { |p| print "#{p.to_s} " }
				puts "- #{@help}"
				
				max_param_length = @params.inject(0) { |max, p| if max < p.name.length then p.name.length else max end }
				
				@params.each { |p| p.print_help(max_param_length, singleton) }
				puts
			end
		end
		
		##################
		# Infrestructure #
		##################
		
		@commands = Hash.new
		
		def self.command(name, *params, &block)
			@commands[name] = Command.new(name, *params, block)
		end
		
		def self.call(name)
			if name.nil?
				puts 'No command given.'
				puts
				 
				if @commands.key?(:help)
					@commands[:help].call
				end
			else
				name = name.to_sym
			
				if @commands.key?(name)
					@commands[name].call
				else
					puts "No such command: #{name}"
				end
			end
		end
		
		########
		# Data #
		########
		
		INIT_FILES = {
			'AUTHORS'		=> ->() { "#{CONFIG.author} <#{CONFIG.author_email}>" },
			'LICENSE'		=> ->() { LICENSES[CONFIG.license].body.call },
			'README.md'	=> ->() {},
			'TODO'		=> ->() {},
			
			'.gitignore'	=> ->() { CONFIG.language_module.gitignore },
			'.sketch'		=> ->() { CONFIG.dump_project_config }
		}
		
		############
		# Commands #
		############
		
		command :foo,
			'A temp helper command.' do
			
			pp CONFIG
		end
		
		command :help,
			[:command, 'The command to print help information for.', :all],
			'Print help for commands.' do
			
			if CONFIG.command and CONFIG.command != :all
				if @commands.key?(CONFIG.command.to_sym)
					@commands[CONFIG.command.to_sym].print_help(true)
				else
					puts "No such command: #{CONFIG.command}"
				end
				
			else
				puts 'Usage: sketch [command] <command arguments>'
				puts
				puts 'Commands:'
			
				@commands.each_value { |c| c.print_help }
			end
		end
		
		command :project,
			[:language, "The project's main language."],
			[:project_name, "The project's name."],
			[:working_path, "The project's root directory.  Defaults to pwd.", FileUtils.pwd],
			"Initialize a project directory with general project files and language specific files." do
			
			project_dirs = CONFIG.language_module.init_dirs
			
			project_files = INIT_FILES.clone.update CONFIG.language_module.init_files
			
			# puts "Working path:"
			# puts CONFIG.working_path
			
			Dir.mkdir(CONFIG.working_path) if not Dir.exist?(CONFIG.working_path)
			Dir.chdir CONFIG.working_path
			
			# puts "Creating the following directories:"
			# project_dirs.each { |d| puts d }
			
			project_dirs.each { |d| Dir.mkdir d }
			
			# puts "Creating the following files:"
			# project_files.each_key { |f| puts f }
			
			project_files.each { |f, s| File.open(f, 'w') { |f| f.print(if s.is_a?(Proc) then s.() else s end) } }
			
			# puts "Doing the git stuff."
			`git init`
			`git add .`
			`git commit -m 'Initial commit for the #{CONFIG.project_name} project.'`
		end
	end
end

# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	Sketch language features for Ruby.

module Sketch
	module Ruby
		class << self
			def file_header(file_description = nil)
				t = Time.new
				
				<<EOF
# Author:		#{CONFIG.author} <#{CONFIG.author_email}>
# Project: 	#{CONFIG.project_long_name or CONFIG.project_name}
# Date:		#{t.year}/#{t.month}/#{t.day}
# Description:	#{file_description}
EOF
			end
		
			def gitignore
				<<EOF
pkg/*
doc/*
coverage/*

.yardoc/*

*.gem
EOF
			end
		
			def init_dirs
				[
					'bin',
					'lib',
					"lib/#{CONFIG.project_name.downcase}",
					'test'
				]
			end
		
			def init_files
				{
					'Rakefile' => begin
						file_header("#{CONFIG.project_name}'s Rakefile.") +
						<<EOF

##############
# Rake Tasks #
##############

# Gems
require 'rake/notes/rake_task'
require 'rake/testtask'
require 'bundler'

require File.expand_path("../lib/#{CONFIG.project_name.downcase}/version", __FILE__)

begin
	require 'yard'

	YARD::Rake::YardocTask.new do |t|
		t.options	= [
			'-e',		yardlib,
			'--title',	'#{CONFIG.project_long_name or CONFIG.project_name}',
			'-m',		'markdown',
			'-M',		'redcarpet',
			'-c',		'.yardoc/cache',
			'--private'
		]
		
		
		t.files	= Dir['lib/**/*.rb']
	end
	
rescue LoadError
	warn 'Yard is not installed. `gem install yard` to build documentation.'
end

Rake::TestTask.new do |t|
	t.libs << 'test'
	t.loader = :testrb
	t.test_files = FileList['test/ts_#{CONFIG.project_name.downcase}.rb']
end

# Bundler tasks.
Bundler::GemHelper.install_tasks

# Rubygems Taks
begin
	require 'rubygems/tasks'
	
	Gem::Tasks.new do |t|
		t.console.command = 'pry'
	end
	
rescue LoadError
	'rubygems-tasks not installed.'
end
EOF
					end,
				
					'Gemfile' => begin
						file_header("Gemfile for the #{CONFIG.project_name} project.") +
						<<EOF

source 'https://rubygems.org'

gemspec
EOF
					end,
				
					"#{CONFIG.project_name.downcase}.gemspec" => begin
						file_header("Gem specification for the #{CONFIG.project_name} project.") +
						<<EOF

require File.expand_path("../lib/#{CONFIG.project_name.downcase}/version", __FILE__)

Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	
	s.name		= '#{CONFIG.project_name}'
	s.version		= #{CONFIG.project_name}::VERSION
	s.summary		= '#{CONFIG.project_long_name}'
	s.description	= ''
	
	s.files = [
			'LICENSE',
			'AUTHORS',
			'README.md',
			'Rakefile',
			] +
			Dir.glob('lib/**/*.rb')
			
			
	s.require_path	= 'lib'
	
	s.author		= '#{CONFIG.author}'
	s.email		= '#{CONFIG.author_email}'
	s.homepage	= '#{CONFIG.project_website}'
	s.license		= '#{LICENSES[CONFIG.license].name}'
	
	s.required_ruby_version = '#{RUBY_VERSION}'
	
	################
	# Dependencies #
	################
	
	############################
	# Development Dependencies #
	############################
	
	s.test_files	= Dir.glob('test/tc_*.rb') + Dir.glob('test/ts_*.rb')
end
EOF
					end,
				
					"lib/#{CONFIG.project_name.downcase}.rb" => begin
						file_header("The root file for the #{CONFIG.project_name} project.") +
						<<EOF

module #{CONFIG.project_name}
	
end
EOF
					end,
				
					"lib/#{CONFIG.project_name.downcase}/version.rb" => begin
						file_header("This file specifies the version number of #{CONFIG.project_name}.") +
						<<EOF

module #{CONFIG.project_name}
	VERSION = '0.0.0'
end
EOF
					end,
				
					"test/ts_#{CONFIG.project_name.downcase}.rb" => begin
						file_header("This file contains the test suit for #{CONFIG.project_name}.  "+
							"It requires the individual tests from their respective files.")
					end
				}
			end
		end
	end
end

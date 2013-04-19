# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	This file holds code responsible for configuring a Sketch run.

# Standard library requires
require 'yaml'

# Sketch requires
require 'sketch/licenses'

module Sketch
	
	SKETCH_FILE		= '.sketch'
	USER_SKETCH_FILE	= File.expand_path "~/#{SKETCH_FILE}"
	
	class Config
		COMMAND_FIELDS = [
			:command,
			:filename,
			:working_path
		]
		
		GLOBAL_FIELDS = [
			:author,
			:author_email,
			:author_website
		]
		
		PROJECT_FIELDS = [
			:organization_name,
			:organization_website,
			
			:project_name,
			:project_long_name,
			:project_website,
			
			:language,
			:license
		]
		
		FIELDS = COMMAND_FIELDS + GLOBAL_FIELDS + PROJECT_FIELDS
		
		####################
		# Instance Methods #
		####################
		
		# Define accessors for each of the fields.
		FIELDS.each { |f| attr_accessor f }
		
		def dump_project_config
			YAML.dump PROJECT_FIELDS.inject(Hash.new) { |h, f| h[f] = self.send f; h }
		end
		
		def language_module
			case self.language
			when 'c', 'C'
				require 'sketch/c'
				C
				
			when 'ruby', 'Ruby'
				require 'sketch/ruby'	
				Ruby
				
			when 'scala', 'Scala'
				require 'sketch/scala'	
				Scala
			end
		end
		
		def parse_config(*spec)
			required_ops = spec.select { |o| not o.is_a?(Array) }
			
			if ARGV.length < required_ops.length
				raise ''
			end
		end
		
		def set(name, val)
			self.instance_variable_set("@#{name}".to_sym, val) if FIELDS.include?(name)
		end
		
		def update(hash)
			hash.each do |k, v|
				self.set(k.to_sym, v)
			end
		end
		
		def update_from_path
			raise 'Working path not set before update was called.' if not self.working_path
			
			wp = File.expand_path(self.working_path)
			
			while wp != ENV['home']
				local_sketch = File.join(wp, SKETCH_FILE)
				
				if File.exist? local_sketch
					self.update(YAML.load_file local_sketch)
					break
				else
					wp = File.dirname wp
				end
			end
		end
		
		def to_s
			FIELDS.inject(Hash.new) { |h, k| h[k] = self.send(k); h }.to_s
		end
	end
	
	# Create our configuration object.
	CONFIG = Config.new
	
	# Set the license to NCSA for now.
	CONFIG.license = :ncsa
	
	# Load the user's .sketch file if it is present.
	if File.exist?(USER_SKETCH_FILE)
		CONFIG.update(YAML.load_file USER_SKETCH_FILE)
	end
end

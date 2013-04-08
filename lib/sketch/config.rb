# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	This file holds code responsible for configuring a Sketch run.

# Standard library requires
require 'yaml'

module Sketch
	
	SKETCH_FILE		= '.sketch'
	USER_SKETCH_FILE	= File.expand_path "~/#{SKETCH_FILE}"
	
	class Config
		FIELDS = [
			:author,
			:author_email,
			:author_website,
		
			:project_name,
			:project_website,
			
			:working_path
		]
		
		####################
		# Instance Methods #
		####################
		
		# Define accessors for each of the fields.
		FIELDS.each { |f| attr_accessor f }
		
		def update(hash)
			hash.each do |k, v|
				self.instance_variable_set("@#{k}".to_sym, v) if FIELDS.include?(k.to_sym)
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
	
	# Load the user's .sketch file if it is present.
	if File.exist?(USER_SKETCH_FILE)
		pp (YAML.load_file USER_SKETCH_FILE)
		
		CONFIG.update(YAML.load_file USER_SKETCH_FILE)
	end
end

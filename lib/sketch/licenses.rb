# encoding: utf-8

# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project:	Sketch
# Date:		2013/04/08
# Description:	Various licenses that Sketch knows about.

module Sketch
	
	License = Struct.new :name, :body
	
	# Install the licenses.
	LICENSES = {
		ncsa: begin
			License.new 'University of Illinois/NCSA Open Source License',
				->() do
					if CONFIG.organization_name
						<<EOF
Copyright © #{Time.new.year} #{CONFIG.organization_name}. All rights reserved.

Developed by: #{CONFIG.organization_name}
#{CONFIG.organization_website}

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal with the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimers.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimers in the documentation and/or other materials provided with the distribution.
  3. Neither the names of #{CONFIG.organization_name}, nor the names of its contributors may be used to endorse or promote products derived from this Software without specific prior written permission.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE SOFTWARE.
EOF
					else
						<<EOF
Copyright © #{Time.new.year} #{CONFIG.author}. All rights reserved.

Developed by: #{CONFIG.author}
#{CONFIG.author_website}

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal with the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimers.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimers in the documentation and/or other materials provided with the distribution.
  3. Neither the names of the #{CONFIG.project_long_name or CONFIG.project_name} development team, nor the names of its contributors may be used to endorse or promote products derived from this Software without specific prior written permission.


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE SOFTWARE.
EOF
					end
				end
			end
	}
	
	# Create the aliases.
	LICENSES[:uofi] = LICENSES[:ncsa]
end

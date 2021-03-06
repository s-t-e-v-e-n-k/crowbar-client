#
# Copyright 2015, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "terminal-table"
require "json"

module Crowbar
  module Client
    module Formatter
      #
      # Formatter to properly print out arrays in different formats
      #
      class Array < Base
        def empty?
          options[:values].empty?
        end

        protected

        def process_table
          Terminal::Table.new(
            headings: options[:headings],
            rows: options[:values].zip
          )
        end

        def process_plain
          options[:values].join("\n")
        end

        def process_json
          JSON.pretty_generate(
            options[:values]
          )
        end
      end
    end
  end
end

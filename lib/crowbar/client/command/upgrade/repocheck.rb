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

module Crowbar
  module Client
    module Command
      module Upgrade
        #
        # Implementation for the upgrade repocheck command
        #
        class Repocheck < Base
          include Mixin::Format
          include Mixin::Filter
          include Mixin::UpgradeError

          def request
            @request ||= Request::Upgrade::Repocheck.new(
              args
            )
          end

          def execute
            request.process do |request|
              case request.code
              when 200
                formatter = Formatter::Nested.new(
                  format: provide_format,
                  headings: ["Status", "Value"],
                  values: Filter::Subset.new(
                    filter: provide_filter,
                    values: request.parsed_response
                  ).result
                )

                if formatter.empty?
                  err "No repochecks"
                else
                  say formatter.result
                  next unless provide_format == :table
                  say "Next step: 'crowbarctl upgrade admin'" if args.component == "crowbar"
                  say "Next step: 'crowbarctl upgrade services'" if args.component == "nodes"
                end
              else
                case args.component
                when "crowbar"
                  err format_error(
                    request.parsed_response["error"], "repocheck_crowbar"
                  )
                when "nodes"
                  err format_error(
                    request.parsed_response["error"], "repocheck_nodes"
                  )
                else
                  err "No such component '#{args.component}'. " \
                    "Only 'admin' and 'nodes' are valid components."
                end
              end
            end
          end
        end
      end
    end
  end
end

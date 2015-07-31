require_relative '../phase5/controller_base'
require 'byebug'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    attr_accessor :route_params

    def invoke_action(name)
        self.send(name)
        render(name) unless already_built_response?
        nil
    end
  end
end

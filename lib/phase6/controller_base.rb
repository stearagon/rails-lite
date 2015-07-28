require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    attr_accessor :route_params
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
        send(name)
        render unless already_built_response?
    end
  end
end

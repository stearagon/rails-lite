require_relative '../phase4/controller_base'
require_relative './params'

module Phase5
  class ControllerBase < Phase4::ControllerBase
    attr_accessor :params, :route_params

    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res)
      @params = route_params
    end
  end
end

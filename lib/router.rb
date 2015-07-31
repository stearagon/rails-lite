require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end


  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      self.add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|

      return route if route.matches?(req)
    end
    return nil
  end

  def run(req, res)
    if !!match(req)
      match(req).run(req,res)
    else
      res.status = 404
    end
  end
end

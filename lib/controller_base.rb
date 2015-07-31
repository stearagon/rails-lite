require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res
  attr_accessor :already_built_response, :route_params, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    !!@already_built_response
  end

  def redirect_to(url)
    raise "Cannot redirect twice" if !@already_built_response.nil?
    res["Location"] = url
    res.status = 302
    @already_built_response = res
    session.store_session(res)
  end

  def render_content(content, content_type)
      raise "Cannot render twice" if !@already_built_response.nil?
      res.body = content
      res.content_type = content_type
      @already_built_response = res
      session.store_session(res)
  end

  def render(template)
    f = File.read("views/#{self.class.name.underscore}/#{template}.html.erb")
    template = ERB.new(f)
    render_content(template.result(binding),"text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
      self.send(name)
      render(name) unless already_built_response?
      nil
  end
end

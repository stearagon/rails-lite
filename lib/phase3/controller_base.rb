require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    def render(template)
      f = File.read("views/#{self.class.name.underscore}/#{template}.html.erb")
      template = ERB.new(f)
      render_content(template.result(binding),"text/html")
    end
  end
end

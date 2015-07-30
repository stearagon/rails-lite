module Phase2
  class ControllerBase
    attr_reader :req, :res
    attr_accessor :already_built_response

    def initialize(req, res)
      @req = req
      @res = res
    end

    def already_built_response?
      !!@already_built_response
    end

    def redirect_to(url)
      raise "Cannot redirect twice" if !@already_built_response.nil?
      res["Location"] = url
      res.status = 302
      @already_built_response = res
    end

    def render_content(content, content_type)
        raise "Cannot render twice" if !@already_built_response.nil?
        res.body = content
        res.content_type = content_type
        @already_built_response = res
    end
  end
end

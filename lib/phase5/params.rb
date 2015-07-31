require 'uri'

module Phase5
  class Params
    attr_accessor :params, :req
    def initialize(req, route_params = {})
      @params = {}
      @req = req
      parse_www_encoded_form(@req.query_string) if !@req.query_string.nil?
      parse_www_encoded_form(@req.body) if !@req.body.nil?

      route_params.each do |k,v|
        @params[k] = v
      end

    end

    def [](key)
       if @params[key].nil?
         @params[key.to_s]
       else
         @params[key]
       end
    end

    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    def parse_www_encoded_form(www_encoded_form)
      www_encoded_form.split('&').each do |hash|
        cookie_values = parse_key(hash)
        i = 0
        if cookie_values.count == 2
          @params[cookie_values[0]] = cookie_values[1]
        else
          while i < cookie_values.count do
            if i == 0
              @params[cookie_values[i]] = {} unless @params.has_key?(cookie_values[i])
              working_hash = @params[cookie_values[i]]
              i += 1
            elsif i < cookie_values.count - 2
              working_hash[cookie_values[i]] = {} unless working_hash.has_key?(cookie_values[i])
              working_hash = working_hash[cookie_values[i]]
              i += 1
            else
              working_hash[cookie_values[i]] = cookie_values[i+1]
              i += 2
            end
          end
        end
      end
    end

    def parse_key(key)
      key.scan(/\w+/)
    end
  end
end

require 'json'
require 'webrick'

module Phase4
  class Session
    attr_accessor :req
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        @cookie = JSON.parse(cookie.value) if cookie.name == "_rails_lite_app"
      end
      @cookie = {} if @cookie.nil?
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      new_cookies = {}

      @cookie.each do |key,value|
        new_cookies[key] = value
      end
      cookie = WEBrick::Cookie.new("_rails_lite_app",new_cookies.to_json)
      res.cookies << cookie
    end

  end
end

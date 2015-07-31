require 'json'
require 'webrick'

class Session
  attr_accessor :req

  def initialize(req)
    req.cookies.each do |cookie|
      @cookie = JSON.parse(cookie.value) if cookie.name == "my_rails"
    end
    @cookie = {} if @cookie.nil?
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new("my_rails", @cookie.to_json)
    res.cookies << cookie
  end

end

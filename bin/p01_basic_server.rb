require 'webrick'

params = { Port: 3000 }

server = WEBrick::HTTPServer.new(params)

server.mount_proc("/") do |request, response|
  response.content_type = "text/text"
  response.body = request.path
end

trap('INT') do
  server.shutdown
end

server.start

require 'socket'
require 'pry'

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  if params
    params = params.split("&").each_with_object({}) do |pair, hash|
      key, value = pair.split("=")
      hash[key] = value
    end
  end

  [http_method, path, params].compact
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  next unless request_line
  next if request_line =~ /favicon/
  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  client.puts "<h1>Rolls!</h1>"

  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p> #{roll} </p>"
  end

  client.puts "</body>"
  client.puts "</html>"

  client.close
end

require "socket"

def parse_request(request_line)  
  http_method, path_query, protocol = request_line.split  
  path, query_string = parse_pathquery((path_query || ""))
  param_hash = parse_querystring(query_string || "")
  [http_method, path, param_hash, protocol]
end

def parse_querystring(query)  
  param_hash = {}
  
  query.split("&").each do |name_val_pair|
    name_val_arr = name_val_pair.split('=')
    param_hash[name_val_arr[0]] = name_val_arr[1]
  end
  param_hash  
end

def parse_pathquery(pathquery)  
  path, query_string = pathquery.split("/?")
  path = '/' if path.empty?
  [path, query_string]
end

server = TCPServer.new("localhost", 3017)
loop do
  client = server.accept
  request_line = client.gets

  next if !request_line || request_line =~ /favicon/
  http_method, path, parameters, protocol = parse_request(request_line)
  
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "</body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts parameters
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"
  number = parameters["number"].to_i rescue 1
  client.puts "<p>The current number is: #{number}.</p>"
  client.puts "<a href=?number=#{number + 1}>Add!</a>"
  client.puts "<a href=?number=#{number - 1}>Subtract!</a>"

 
  client.puts "</body>"
  client.puts "</html>"
  
  client.close  
end



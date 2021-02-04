require "socket"

server = TCPServer.new("localhost", 3002)
loop do
  client = server.accept

  request_line = client.gets  
  #puts request_line
  http_method, path, parameters, protocol = parse_request(request_line)
  
  client.puts "HTTP/1.1 200 OK\r\n\r\n"
  p http_method, path, parameters, protocol
  client.puts rand(6) + 1
  client.close  
end

def parse_request(request_line)
  http_method, path_query, protocol = request_line.split
  path, query_string = parse_pathquery(path_query)
  param_hash = parse_querystring(query_string)
  [http_method, path, query_string, protocol]
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
  [path, query_string]
end
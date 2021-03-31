require "socket"

def parse_request(request_line)  
  http_method, path_query, protocol = request_line.split  
  path, query_string = parse_pathquery(path_query)
  param_hash = parse_querystring(query_string)
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

def parse_dice(parameters)
  rolls = parameters.has_key?("rolls") ? parameters["rolls"] : 1
  sides = parameters.has_key?("sides") ? parameters["sides"] : 6
  [rolls.to_i, sides.to_i]
end

server = TCPServer.new("localhost", 3014)
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


  puts "<h1>Rolls!</h1>"
  dice_rolls, dice_sides = parse_dice(parameters)
  dice_rolls.times do |time|
    client.puts "<h4>Rolling dice for #{time + 1} time!</h4>"
    client.puts "<p>Dice rolls on: #{rand(dice_sides + 1)}!</p>"
  end
  client.puts "</body>"
  client.puts "</html>"
  
  client.close  
end



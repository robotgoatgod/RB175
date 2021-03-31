require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get "/" do
  @order = params['order'].nil? ? 'ascending' : params['order']
  @files = Dir.entries("public")[1..-2].sort  
  @files.reverse! if @order == 'descending'
  @title = "Dynamix Index Home"  
  erb :home  
end
require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do 
  @data = Psych.load_file("./data/users.yaml")
  
end

get "/" do
  @data
  erb :home
end
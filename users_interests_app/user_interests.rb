# user_interests.rb
require "yaml"

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do 
  @data = Psych.load_file("./data/users.yaml")  
end

helpers do
  def count_interests(data)
    data.reduce(0) do |sum, (name, user)|
      sum + user[:interests].size
    end
  end

  def user_count(data)
    data.keys.count
  end
end

get "/" do  
  erb :home
end

get "/users/:user_name" do
  @user_name = params[:user_name].to_sym
  @email = @data[@user_name][:email]
  @interests = @data[@user_name][:interests]

  erb :user
end
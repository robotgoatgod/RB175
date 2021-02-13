require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do 
  @data = Psych.load_file("./data/users.yaml")  
end

get "/" do  
  erb :home
end

get "/users/:user" do
  @name = params[:user]
  @user_data = @data[@name.to_sym]
  erb :user
end

helpers do
  def user_count(data)
    data.keys.count
  end

  def interest_count(data)
    data.values.reduce(0) { |total, details| total + details[:interests].size }
  end

  def display_other_user_links(data, current_user)
    users = @data.keys
    users.delete(current_user.to_sym)

    users.map do |user|
      %(<li><a href="/users/#{user}">#{user}</a></li>)
    end.join("\n\n")
  end
end

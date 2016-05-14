require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'yaml'

helpers do
  def count_interests
    all_interests = []

    @users.each do |name, info|
      all_interests << @users[name][:interests]
    end
    all_interests.flatten.length
  end

end

before do
  @users = YAML.load_file('data/users.yaml')
end

get '/' do
  @title = "Users"

  erb :home
end

get '/:name' do
  name = params[:name]

  @title = name.capitalize
  @email = @users[name.to_sym][:email]
  @interests = @users[name.to_sym][:interests]

  erb :user
end

class UsersController < ApplicationController

  get '/login' do
    erb :login
  end

  post '/login' do
    @user = User.find_by(email: params[:email])
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id #actually logging user in
      puts session
      redirect "/users/#{@user.id}"
    else

    end
  end

  get '/signup' do

    erb :signup
  end

  post '/users' do

  end

  get '/users/:id' do
    "this will be the user show route"
  end
end

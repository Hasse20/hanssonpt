require 'sinatra/base'
require 'sinatra/flash'
require 'sqlite3'
require 'bcrypt'
require_relative "models/user"

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  helpers do
    def user_authenticated?
      !!session[:user_id]
    end
  end

  configure do
    User.create_table  # Säkerställ att tabellen finns
  end

  get '/' do
    if user_authenticated?
      erb :index
    else
      redirect "/login"
    end
  end

  get '/' do
    erb :index
  end



  get '/programs/new' do
    erb :'programs/new'
  end

  post '/programs' do
    params.inspect
    #todo: spara program till databasen
    #todo: redirect http://localhost:9292/programs
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.login(params[:username], params[:password])

    if user
      session[:user_id] = user["id"]
      session[:username] = user["username"]
      flash[:success] = "Välkommen, #{user['username']}!"
      redirect '/program'
    else
      flash[:error] = "Fel användarnamn eller lösenord"
      redirect '/login'
    end
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    user_created = User.register(params[:username], params[:password])

    if user_created
      flash[:success] = "Registrering lyckades! Logga in nu."
      redirect '/login'
    else
      flash[:error] = "Användarnamnet är redan taget."
      redirect '/register'
    end
  end

  get '/program' do
    if user_authenticated?
      @username = session[:username]
      erb :program
    else
      flash[:error] = "Du måste vara inloggad för att se denna sida."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    flash[:success] = "Du har loggats ut."
    redirect '/login'
  end
end

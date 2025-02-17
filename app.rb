require 'sinatra/base'
require 'sinatra/flash'
require 'sqlite3'
require 'bcrypt'

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  def db_connection
    db = SQLite3::Database.new "users.db"
    db.results_as_hash = true
    return db
  end

  configure do
    db = SQLite3::Database.new "users.db"
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password_digest TEXT
      );
    SQL
  end

  get '/' do
    erb :index
  end

  get '/index.html' do
    erb :index
  end

  get '/index' do
    erb :index
  end

  get '/login.html' do
    erb :login
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    db = db_connection
    user = db.execute("SELECT * FROM users WHERE username = ?", [params[:username]]).first

    if user && BCrypt::Password.new(user['password_digest']) == params[:password]
      session[:user_id] = user['id']
      flash[:success] = "Välkommen, #{params[:username]}!"
      redirect '/program'
    else
      flash[:error] = "Fel användarnamn eller lösenord"
      redirect '/login'
    end
    if user_authenticated?
      session[:user_id] = user.id
      redirect '/'  # Ladda om startsidan eller en dashboard
    else
      redirect '/login'  # Om det misslyckas, skicka tillbaka till login-sidan
    end
  end

  get '/register' do
    erb :register
  end

  get '/register.html' do
    erb :register
  end

  post '/register' do
    db = db_connection
    hashed_password = BCrypt::Password.create(params[:password])

    begin
      db.execute("INSERT INTO users (username, password_digest) VALUES (?, ?)", [params[:username], hashed_password])
      flash[:success] = "Registrering lyckades! Logga in nu."
      redirect '/login'
    rescue SQLite3::ConstraintException
      flash[:error] = "Användarnamnet är redan taget."
      redirect '/register'
    end
    if user_created?
      session[:user_id] = user.id
      puts session[:username]
      redirect '/'  # Ladda om startsidan eller en dashboard
    else
      redirect '/register'  # Om det misslyckas, skicka tillbaka till register-sidan
    end
  end

  get '/program.html' do
    @username = session[:username]  # Hämta inloggade användarens namn
    erb :program
  end

  get '/program' do
    @username = session[:username]  # Hämta inloggade användarens namn
    erb :program
  end

  get '/logout' do
    session.clear
    flash[:success] = "Du har loggats ut."
    redirect '/login'
  end

  run! if app_file == $0
end

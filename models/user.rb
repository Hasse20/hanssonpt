require 'sqlite3'
require 'bcrypt'

class User
  DB = SQLite3::Database.new("users.db")
  DB.results_as_hash = true

  def self.create_table
    DB.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password_digest TEXT
      );
    SQL
  end

  def self.register(username, password)
    hashed_password = BCrypt::Password.create(password)
    begin
      DB.execute("INSERT INTO users (username, password_digest) VALUES (?, ?)", [username, hashed_password])
      return true
    rescue SQLite3::ConstraintException
      return false
    end
  end

  def self.login(username, password)
    user = DB.execute("SELECT * FROM users WHERE username = ?", [username]).first
    return nil unless user

    if BCrypt::Password.new(user["password_digest"]) == password
      return user # Returnerar en hash med användardata
    else
      return nil
    end
  end
end

# Se till att tabellen finns
User.create_table


#fixa så att models funkar med mvc https://docs.google.com/presentation/d/169X-K4eIaVhN62ldELxkTEpQfYYXCqTXosxZKNYynuA/edit#slide=id.g34184975a14_0_0
#fixa orm mha user klassen

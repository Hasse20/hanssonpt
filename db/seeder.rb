require 'sqlite3'

class Seeder
  DB = SQLite3::Database.new("users.db")
  DB.results_as_hash = true

  def self.seed!
    p "doit"
    DB.execute <<-SQL
    CREATE TABLE programs (
      id INTEGER PRIMARY KEY,
      program TEXT
    );
    SQL
  end

end

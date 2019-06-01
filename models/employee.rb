require_relative("../db/sql_runner")

class Employee

  attr_reader :id
  attr_accessor :name, :password

  def initialize(options)
    @name = options["name"]
    @password = options["password"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO seats (
      name, password
    ) VALUES (
      $1, $2
    ) RETURNING *"
    values = [@name, @password]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE seats SET (
      name, password
    ) = (
      $1, $2
    ) WHERE id = $3"
    values = [@name, @password, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM seats WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM seats"
    seats = SqlRunner.run(sql)
    return seats.map{|auditorium| Seat.new(auditorium)}
  end

  def self.find(id)
    sql = "SELECT * FROM seats WHERE id = $1"
    values = [@id]
    auditorium = SqlRunner.run(sql, values)
    return Seat.new(auditorium)
  end

  def self.delete_all
    sql = "DELETE FROM seats"
    SqlRunner.run(sql)
  end

end

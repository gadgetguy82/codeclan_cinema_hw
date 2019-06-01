require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :show_time, :tickets_available, :film_id, :auditorium_id

  def initialize(options)
    @show_time = options["show_time"]
    @tickets_available = options["tickets_available"].to_i
    @film_id = options["film_id"].to_i
    @auditorium_id = options["auditorium_id"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO screenings (
      show_time, tickets_available, film_id, auditorium_id
    ) VALUES (
      $1, $2, $3, $4
    ) RETURNING *"
    values = [@show_time, @tickets_available, @film_id, @auditorium_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE screenings SET (
      show_time, tickets_available, film_id, auditorium_id
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5"
    values = [@show_time, @tickets_available, @film_id, @auditorium_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return Screening.map_items(screenings)
  end

  def self.find(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    screening = SqlRunner.run(sql, values)[0]
    return Screening.new(screening)
  end

  def self.exists?(show_time, auditorium_id)
    sql = "SELECT * FROM screenings WHERE show_time = $1 AND auditorium_id = $2"
    values = [show_time, auditorium_id]
    screenings = SqlRunner.run(sql, values)
    if Screening.map_items(screenings) != []
      return true
    else
      return false
    end
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    return data.map{|screening| Screening.new(screening)}
  end

end

require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_reader :show_time, :film_id, :tickets_available

  def initialize(options)
    @show_time = options["show_time"]
    @film_id = options["film_id"].to_i
    @tickets_available = options["tickets_available"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO screenings (
      show_time, film_id, tickets_available
    ) VALUES (
      $1, $2, $3
    ) RETURNING *"
    values = [@show_time, @film_id, @tickets_available]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE screenings SET (
      show_time, film_id, tickets_available
    ) = (
      $1, $2, $3
    ) WHERE id = $4"
    values = [@show_time, @film_id, @tickets_available, @id]
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
    return screenings.map{|screening| Screening.new(screening)}
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end

require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_reader :show_time, :tickets_available, :ticket_id

  def initialize(options)
    @show_time = options["show_time"]
    @tickets_available = options["tickets_available"].to_i
    @ticket_id = options["ticket_id"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO screenings (
      show_time, tickets_available, ticket_id
    ) VALUES (
      $1, $2, $3
    ) RETURNING *"
    values = [@show_time, @tickets_available, @ticket_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE screenings SET (
      show_time, tickets_available, ticket_id
    ) = (
      $1, $2, $3
    ) WHERE id = $4"
    values = [@show_time, @tickets_available, @ticket_id, @id]
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

require_relative("../db/sql_runner")
require_relative("seat")

class Auditorium

  attr_reader :id
  attr_accessor :name, :total_seats, :total_rows

  def initialize(options)
    @name = options["name"]
    @total_seats = options["total_seats"]
    @total_rows = options["total_rows"]
    @theatre_id = options["theatre_id"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO auditoriums (
      name, total_seats, total_rows, theatre_id
    ) VALUES (
      $1, $2, $3, $4
    ) RETURNING *"
    values = [@name, @total_seats, @total_rows, @theatre_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE auditoriums SET (
      name, total_seats, total_rows, theatre_id
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5"
    values = [@name, @total_seats, @total_rows, @theatre_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM auditoriums WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def add_seat(seat)
    seat.auditorium_id = @id
    seat.update
    @total_seats += 1
    self.update
  end

  def populate_seats
    letter = *("A".."Z")
    for row in 0..total_rows - 1
      for num in 1..total_seats / total_rows
        seat = Seat.new(
          {
            "row" => letter[row],
            "seat_number" => num,
            "auditorium_id" => @id,
            "reserved" => false
          }
        )
        seat.save
      end
    end
  end

  def seats
    sql = "SELECT seats.* FROM seats INNER JOIN auditoriums
    ON seats.auditorium_id = auditoriums.id
    WHERE auditoriums.id = $1"
    values = [@id]
    seats = SqlRunner.run(sql, values)
    return seats.map{|seat| Seat.new(seat)}
  end

  def self.all
    sql = "SELECT * FROM auditoriums"
    auditoriums = SqlRunner.run(sql)
    return auditoriums.map{|auditorium| Auditorium.new(auditorium)}
  end

  def self.find(id)
    sql = "SELECT * FROM auditoriums WHERE id = $1"
    values = [@id]
    auditorium = SqlRunner.run(sql, values)
    return Auditorium.new(auditorium)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM auditoriums WHERE name = $1"
    values = [name]
    auditorium = SqlRunner.run(sql, values)[0]
    return Auditorium.new(auditorium)
  end

  def self.delete_all
    sql = "DELETE FROM auditoriums"
    SqlRunner.run(sql)
  end

end

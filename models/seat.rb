require_relative("../db/sql_runner")

class Seat

  attr_reader :id
  attr_accessor :row, :seat_number, :auditorium_id, :reserved

  def initialize(options)
    @row = options["row"]
    @seat_number = options["seat_number"].to_i
    @auditorium_id = options["auditorium_id"].to_i if options["auditorium_id"]
    @reserved = options["reserved"]
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO seats (
      row, seat_number, auditorium_id, reserved
    ) VALUES (
      $1, $2, $3, $4
    ) RETURNING *"
    values = [@row, @seat_number, @auditorium_id, @reserved]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE seats SET (
      row, seat_number, auditorium_id, reserved
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5"
    values = [@row, @seat_number, @auditorium_id, @reserved, @id]
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
    return self.map_items(seats)
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

  def self.map_items(data)
    return data.map{|seat| Seat.new(seat)}
  end

end

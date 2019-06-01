require_relative("../db/sql_runner")
require_relative("customer")
require_relative("film")
require_relative("screening")
require_relative("seat")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id, :seat_id

  def initialize(options)
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
    @screening_id = options["screening_id"].to_i
    @seat_id = options["seat_id"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO tickets (
      customer_id, film_id, screening_id, seat_id
    ) VALUES (
      $1, $2, $3, $4
    ) RETURNING *"
    values = [@customer_id, @film_id, @screening_id, @seat_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE tickets SET (
      customer_id, film_id, screening_id, seat_id
    ) = (
      $1, $2, $3
    ) WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @seat_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customer
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
    ON customers.id = tickets.customer_id WHERE tickets.id = $1"
    values = [@id]
    customer = SqlRunner.run(sql, values)[0]
    return Customer.new(customer)
  end

  def film
    sql = "SELECT films.* FROM films INNER JOIN tickets
    ON films.id = tickets.film_id WHERE tickets.id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)[0]
    return Film.new(film)
  end

  def screening
    sql = "SELECT screenings.* FROM screenings INNER JOIN tickets
    ON screenings.id = tickets.screening_id WHERE tickets.id = $1"
    values = [@id]
    screening = SqlRunner.run(sql, values)[0]
    return Screening.new(screening)
  end

  def seat
    sql = "SELECT seats.* FROM seats INNER JOIN tickets
    ON seats.id = tickets.seat_id WHERE tickets.id"
    values = [@id]
    seat = SqlRunner.run(sql, values)[0]
    return Seat.new(seat)
  end

  def self.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return tickets.map{|ticket| Ticket.new(ticket)}
  end

  def self.find(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    ticket = SqlRunner.run(sql, values)[0]
    return Ticket.new(ticket)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end

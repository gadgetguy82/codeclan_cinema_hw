require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @name = options["name"]
    @funds = options["funds"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO customers (
      name, funds
    ) VALUES (
      $1, $2
    ) RETURNING *"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE customers SET (
      name, funds
    ) = (
      $1, $2
    ) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films
    sql = "SELECT films.* FROM films INNER JOIN tickets ON
    films.id = tickets.film_id WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{|film| Film.new(film)}
  end

  def buy_ticket(screening)
    film = Film.find(screening.film_id)
    if screening.tickets_available > 0
      if @funds >= film.price
        ticket = Ticket.new(
          {
            "customer_id" => @id,
            "film_id" => screening.film_id,
            "screening_id" => screening.id
          }
        )
        ticket.save
        screening.tickets_available -= 1
        screening.update
        @funds -= film.price
        self.update
      else
        p "Cannot afford ticket"
      end
    else
      p "Sold out, no more tickets available for #{film.title} screening at #{screening.show_time}"
    end
  end

  def total_tickets_bought
    return self.films.count
  end

  def self.all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map{|customer| Customer.new(customer)}
  end

  def self.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    customer = SqlRunner.run(sql, values)[0]
    return Customer.new(customer)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end

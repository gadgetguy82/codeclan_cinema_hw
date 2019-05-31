require_relative("../db/sql_runner")
require_relative("customer")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @title = options["title"]
    @price = options["price"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO films (
      title, price
    ) VALUES (
      $1, $2
    ) RETURNING *"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE films SET (
      title, price
    ) = (
      $1, $2
    ) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
    ON customers.id = tickets.customer_id WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|customer| Customer.new(customer)}
  end

  def num_of_customers
    return self.customers.count
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map{|film| Film.new(film)}
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end

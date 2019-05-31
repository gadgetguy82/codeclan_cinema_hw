require_relative("../db/sql_runner")
require_relative("customer")
require_relative("screening")

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

  def popular_time
    sql = "SELECT screenings.* FROM screenings INNER JOIN tickets
    ON screenings.ticket_id = tickets.id
    WHERE tickets.film_id = $1"
    values = [@id]
    screenings_data = SqlRunner.run(sql, values)
    screenings = screenings_data.map{|screening| Screening.new(screening)}

    # -------------------------------------------------------------
    # This way will return multiple popular times
    show_times = screenings.map{|screening| screening.show_time}
    frequency_hash = show_times.reduce(Hash.new(0)){
      |hash, show_time| hash[show_time] += 1; hash}
    max = frequency_hash.values.max
    return (frequency_hash.find_all{
      |show_time, frequency| frequency == max}).map{
        |show_time, frequency| show_time}
    # -------------------------------------------------------------
    # Another way to extract the most popular screening time
    # Again only extracts the first popular time found
    #
    # show_times = screenings.map{|screening| screening.show_time}
    # frequency_hash = show_times.reduce(Hash.new(0)){
    #   |hash, show_time| hash[show_time] += 1; hash}
    # return show_times.max_by{|value| frequency_hash[value]}
    # -------------------------------------------------------------
    # One way to extract the most popular screening time for this
    # film, only returns the first popular time if multiples exist
    #
    # show_times = []
    # tickets = []
    # for screening in screenings
    #   if index = show_times.index(screening.show_time) != nil
    #     tickets[index] += 1
    #   else
    #     show_times.push(screening.show_time)
    #     tickets.push(1)
    #   end
    # end
    # return show_times[tickets[tickets.max]]
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map{|film| Film.new(film)}
  end

  def self.find(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    film = SqlRunner.run(sql, values)[0]
    return Film.new(film)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end

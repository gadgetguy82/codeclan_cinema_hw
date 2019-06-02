require_relative("db/sql_runner")
require_relative("models/auditorium")
require_relative("models/film")
require_relative("models/screening")

class Theatre

  attr_reader :id
  attr_accessor :name, :address

  def initialize(options)
    @name = options["name"]
    @address = options["address"]
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO theatres (
      name, address
    ) VALUES (
      $1, $2
    ) RETURNING *"
    values = [@name, @address]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE theatres SET (
      name, address
    ) = (
      $1, $2
    ) WHERE id = $3"
    values = [@name, @address, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM theatres WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def add_auditorium(name, total_seats = 50, total_rows = 5)
    auditorium = Auditorium.new(
      {
        "name" => name,
        "total_seats" => total_seats,
        "total_rows" => total_rows,
        "theatre_id" => @id
      }
    )
    auditorium.save
    auditorium.populate_seats
  end

  def add_film(title, duration, price = 5)
    film = Film.new(
      {
        "title" => title,
        "duration" => duration,
        "price" => price
      }
    )
    film.save
  end

  def set_price(film, price)
    film.price = price
    film.update
  end

  def add_screening(time, auditorium, film)
    if !Screening.exists?(time, auditorium.id)
      screening = Screening.new(
        {
          "show_time" => time,
          "tickets_available" => auditorium.total_seats,
          "film_id" => film.id,
          "auditorium_id" => auditorium.id
        }
      )
      screening.save
    else
      p "Cannot add screening, #{auditorium.name} already booked"
    end
  end

  def self.all
    sql = "SELECT * FROM theatres"
    theatres = SqlRunner.run(sql)
    return theatres.map{|theatre| Theatre.new(theatre)}
  end

  def self.find(id)
    sql = "SELECT * FROM theatres WHERE id = $1"
    values = [id]
    theatre = SqlRunner.run(sql, values)
    return Theatre.new(theatre)
  end

  def self.delete_all
    sql = "DELETE FROM theatres"
    SqlRunner.run(sql)
  end

  def self.select_random(array)
    return array[rand(array.length - 1)]
  end

end

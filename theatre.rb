require_relative("db/sql_runner")
require_relative("models/auditorium")
require_relative("models/film")
require_relative("models/screening")

class Theatre

  attr_accessor :name, :address

  def initialize(options)
    @name = options["name"]
    @address = options["address"]
  end

  def add_auditorium(name, total_seats = 50, total_rows = 5)
    auditorium = Auditorium.new(
      {
        "name" => name,
        "total_seats" => total_seats,
        "total_rows" => total_rows
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
      p "Cannot add screening, #{auditorium.name} already in use"
    end
  end

end

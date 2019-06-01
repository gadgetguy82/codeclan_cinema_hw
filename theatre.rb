require_relative("models/auditorium")
require_relative("models/film")

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

  def add_film(title, duration)
    film = Film.new(
      {
        "title" => title,
        "duration" => duration
      }
    )
    film.save
  end

end

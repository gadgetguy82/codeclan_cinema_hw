require("pry")
require_relative("theatre")
require_relative("models/customer")
require_relative("models/film")
require_relative("models/ticket")
require_relative("models/screening")
require_relative("models/auditorium")
require_relative("models/seat")

Ticket.delete_all
Screening.delete_all
Seat.delete_all
Auditorium.delete_all
Customer.delete_all
Film.delete_all

odeon = Theatre.new(
  {
    "name" => "Odeon",
    "address" => "Lothian Road"
  }
)
odeon.add_auditorium("Screen 1")
odeon.add_auditorium("Screen 2")

odeon.add_film("Jurassic Park", "1 hour")
odeon.add_film("Robocop", "2 hours")
odeon.add_film("Terminator 2" "2 hours")

customer1 = Customer.new(
  {
    "name" => "Robert",
    "funds" => 100
  }
)
customer1.save
customer2 = Customer.new(
  {
    "name" => "Greg",
    "funds" => 200
  }
)
customer2.save
customer3 = Customer.new(
  {
    "name" => "Peter",
    "funds" => 300
  }
)
customer3.save
customer4 = Customer.new(
  {
    "name" => "Imogen",
    "funds" => 50
  }
)
customer4.save

screening1 = Screening.new(
  {
    "show_time" => "14:00",
    "tickets_available" => 5,
    "film_id" => film1.id
  }
)
screening1.save
screening2 = Screening.new(
  {
    "show_time" => "18:00",
    "tickets_available" => 4,
    "film_id" => film1.id
  }
)
screening2.save

customer1.buy_ticket(screening1)
customer2.buy_ticket(screening1)
customer1.buy_ticket(screening2)
customer1.buy_ticket(screening2)
customer2.buy_ticket(screening2)
customer3.buy_ticket(screening2)
customer4.buy_ticket(screening2)

binding.pry
nil

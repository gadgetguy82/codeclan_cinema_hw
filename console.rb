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
Film.delete_all
Customer.delete_all

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
odeon.add_film("Terminator 2", "2 hours")

odeon.set_price(Film.all[0], 10)
odeon.set_price(Film.all[0], 8)
odeon.set_price(Film.all[0], 15)

odeon.add_screening("14:00", Auditorium.all[0], Film.all[0])
odeon.add_screening("18:00", Auditorium.all[0], Film.all[1])

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

customer1.buy_ticket(Screening.all[0])
customer2.buy_ticket(Screening.all[0])
customer1.buy_ticket(Screening.all[1])
customer1.buy_ticket(Screening.all[1])
customer2.buy_ticket(Screening.all[1])
customer3.buy_ticket(Screening.all[1])
customer4.buy_ticket(Screening.all[1])

binding.pry
nil

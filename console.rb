require("pry")
require_relative("theatre")
require_relative("customer_list")
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

odeon.set_price(Film.find_by_title("Jurassic Park"), 10)
odeon.set_price(Film.find_by_title("Robocop"), 8)
odeon.set_price(Film.find_by_title("Terminator 2"), 15)

odeon.add_screening("14:00", Auditorium.find_by_name("Screen 1"), Film.find_by_title("Jurassic Park"))
odeon.add_screening("18:00", Auditorium.find_by_name("Screen 1"), Film.find_by_title("Robocop"))

customers = CustomerList.new(10).customers

customers[rand(customers.length - 1)].buy_ticket(Screening.all[0])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[0])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[1])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[1])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[1])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[1])
customers[rand(customers.length - 1)].buy_ticket(Screening.all[1])

binding.pry
nil

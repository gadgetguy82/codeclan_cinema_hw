require("pry")
require_relative("customer_list")
require_relative("models/theatre")
require_relative("models/employee")
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
Employee.delete_all
Theatre.delete_all

odeon = Theatre.new(
  {
    "name" => "Odeon",
    "address" => "Lothian Road"
  }
)
odeon.save
odeon.add_auditorium("Screen 1")
odeon.add_auditorium("Screen 2")

odeon.add_film("Jurassic Park", "1 hour", 5 + rand(10))
odeon.add_film("Robocop", "2 hours", 5 + rand(10))
odeon.add_film("Terminator 2", "2 hours", 5 + rand(10))

odeon.set_price(Film.find_by_title("Jurassic Park"), 10)

odeon.add_screening("14:00", Auditorium.find_by_name("Screen 1"), Film.find_by_title("Jurassic Park"))
odeon.add_screening("18:00", Auditorium.find_by_name("Screen 1"), Film.find_by_title("Robocop"))
odeon.add_screening("18:00", Auditorium.find_by_name("Screen 1"), Film.find_by_title("Terminator 2"))

employee = Employee.new(
  {
    "name" => "Roger",
    "password" => "1234",
    "access_level" => 2,
    "theatre_id" => odeon.id
  }
)
employee.save

customers = CustomerList.new(10).customers

(10 + rand(10)).times {
  screening = Theatre.select_random(Screening.all)
  seat = Theatre.select_random(screening.free_seats)
  customer = Theatre.select_random(customers)
  customer.buy_ticket(screening, seat)
}

binding.pry
nil

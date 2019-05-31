require("pry")
require_relative("models/customer")
require_relative("models/film")
require_relative("models/ticket")

Screening.delete_all
Ticket.delete_all
Customer.delete_all
Film.delete_all

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

film1 = Film.new(
  {
    "title" => "Jurassic Park",
    "price" => 10
  }
)
film1.save
film2 = Film.new(
  {
    "title" => "Robocop",
    "price" => 4
  }
)
film2.save
film3 = Film.new(
  {
    "title" => "Police Story",
    "price" => 7
  }
)
film3.save

screening1 = Screening.new(
  {
    "show_time" => "14:00",
    "tickets_available" => 5
  }
)
screening1.save
screening2 = Screening.new(
  {
    "show_time" => "18:00",
    "tickets_available" => 4
  }
)
screening2.save

customer1.buy_ticket(film1, screening1)
customer2.buy_ticket(film2, screening1)
customer1.buy_ticket(film2, screening2)
customer1.buy_ticket(film2, screening2)
customer2.buy_ticket(film2, screening2)
customer3.buy_ticket(film2, screening2)
customer4.buy_ticket(film2, screening2)

binding.pry
nil

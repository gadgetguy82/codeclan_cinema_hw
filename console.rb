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

ticket1 = Ticket.new(
  {
    "customer_id" => customer1.id,
    "film_id" => film1.id
  }
)
ticket1.save
ticket2 = Ticket.new(
  {
    "customer_id" => customer2.id,
    "film_id" => film2.id
  }
)
ticket2.save
ticket3 = Ticket.new(
  {
    "customer_id" => customer3.id,
    "film_id" => film2.id
  }
)
ticket3.save
ticket4 = Ticket.new(
  {
    "customer_id" => customer1.id,
    "film_id" => film2.id
  }
)
ticket4.save

screening1 = Screening.new(
  {
    "show_time" => "14:00",
    "tickets_available" => 50,
    "ticket_id" => ticket1.id
  }
)
screening1.save
screening2 = Screening.new(
  {
    "show_time" => "18:00",
    "tickets_available" => 40,
    "ticket_id" => ticket2.id
  }
)
screening2.save
screening3 = Screening.new(
  {
    "show_time" => "18:00",
    "tickets_available" => 40,
    "ticket_id" => ticket2.id
  }
)
screening3.save

binding.pry
nil

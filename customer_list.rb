require_relative("models/customer")

class CustomerList

  def initialize(length)
    first_names = ["Andrew", "Betty", "Charles", "Daniella", "Eric", "Frieda", "Greg", "Helga", "Ian"]
    last_names = ["Anderson", "Bailey", "Christie", "Dyer", "Egerton", "Fogel", "Glass", "Henley", "Innes"]
    @customer_list = []
    @names_list = []
    (length - 1).times {
      @names_list.push(first_names[rand(first_names.length)] + " " + last_names[rand(last_names.length)])
    }
  end

  def customers
    for name in @names_list
      customer = Customer.new(
        {
          "name" => name,
          "funds" => (10 + rand(200))
        }
      )
      customer.save
      @customer_list.push(customer)
    end
    return @customer_list
  end

end

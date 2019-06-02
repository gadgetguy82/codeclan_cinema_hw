require_relative("../db/sql_runner")

class Employee

  attr_reader :id
  attr_accessor :name, :password, :access_level, :theatre_id

  def initialize(options)
    @name = options["name"]
    @password = options["password"]
    @access_level = options["access_level"]
    @theatre_id = options["theatre_id"]
    @id = options["id"].to_i if options["id"]
  end

  def save
    sql = "INSERT INTO employees (
      name, password, access_level, theatre_id
    ) VALUES (
      $1, $2, $3, $4
    ) RETURNING *"
    values = [@name, @password, @access_level, @theatre_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def update
    sql = "UPDATE employees SET (
      name, password, access_level, theatre_id
    ) = (
      $1, $2, $3, $4
    ) WHERE id = $5"
    values = [@name, @password, @access_level, @theatre_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM employees WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM employees"
    employees = SqlRunner.run(sql)
    return employees.map{|employee| Employee.new(employee)}
  end

  def self.find(id)
    sql = "SELECT * FROM employees WHERE id = $1"
    values = [@id]
    employee = SqlRunner.run(sql, values)
    return Employee.new(employee)
  end

  def self.delete_all
    sql = "DELETE FROM employees"
    SqlRunner.run(sql)
  end

end

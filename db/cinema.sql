DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE films (
  id SERIAL8 PRIMARY KEY,
  title VARCHAR(255),
  price INT4
);

CREATE TABLE screenings (
  id SERIAL8 PRIMARY KEY,
  show_time VARCHAR(255),
  tickets_available INT4,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  customer_id INT8 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE
);

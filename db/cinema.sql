DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS auditoriums;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE films (
  id SERIAL8 PRIMARY KEY,
  title VARCHAR(255),
  price INT4,
  duration VARCHAR(255)
);

CREATE TABLE auditoriums (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  total_seats INT4,
  total_rows INT4
);

CREATE TABLE seats (
  id SERIAL8 PRIMARY KEY,
  row VARCHAR(255),
  seat_number INT4,
  auditorium_id INT8 REFERENCES auditoriums(id) ON DELETE CASCADE,
  reserved BOOLEAN
);

CREATE TABLE screenings (
  id SERIAL8 PRIMARY KEY,
  show_time VARCHAR(255),
  tickets_available INT4,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
  auditorium_id INT8 REFERENCES auditoriums(id) ON DELETE CASCADE
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  customer_id INT8 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
  screening_id INT8 REFERENCES screenings(id) ON DELETE CASCADE,
  seat_id INT8 REFERENCES seats(id) ON DELETE CASCADE
);

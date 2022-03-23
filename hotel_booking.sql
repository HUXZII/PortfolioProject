use hotel_booking;

--lets have a look on data
select * from Orders;

--lets see how many hotels are theire in each country
select destination_country,count(hotel_name)as no_of_hotels from orders
group by destination_country
order by no_of_hotels desc;


--lets see how many hotels are theire in each city
select destination_city,count(hotel_name)as no_of_hotels from orders
group by destination_city
order by no_of_hotels desc;

--lets see how many hotels are their in each country/state
select destination_country,state,count(hotel_name)as no_of_hotels from orders
group by destination_country,state
order by no_of_hotels desc;


--lets see the total booking by year 
select year,count(year)as annual_booking from orders
group by year
order by year;

---lets see the maximum booking by date
select date_of_booking,count(booking_id)as no_of_bookings from orders
group by date_of_booking
order by no_of_bookings desc;


---lets see maximum booking by city
select destination_city,count(customer_id)as no_of_bookings from orders
group by destination_city
order by no_of_bookings desc;

---lets see max booking by country
select destination_country,count(customer_id)as no_of_bookings from orders
group by Destination_Country
order by no_of_bookings desc;


--lets see the hotels and their respective ratings by city
select hotel_name,hotel_rating,destination_city as city from orders
order by hotel_rating desc;


--lets see the hotels and their respective ratings by city and country
select hotel_name,hotel_rating,destination_country,destination_city as city from orders
order by hotel_rating desc;


--lets see the no of hotels by rating
select count(hotel_name)as no_of_hotels,hotel_rating from orders
group by hotel_rating
order by hotel_rating desc;

---lets see the hotel by their no.of.rooms
select hotel_name,rooms from orders
order by rooms desc;

-----lets see  the hotel by price
select hotel_name,booking_price from orders
order by booking_price desc;

---profit margin by hotels
select hotel_name,profit_margin from orders
order by profit_margin desc;

---lets see the hotel with no.of rooms
select hotel_name,rooms from orders 
order by rooms desc;


---lets see the hotel by their profit margin
select hotel_name,profit_margin from orders 
order by profit_margin desc; 

---lets see the total no of destination cities people travelled in
select  count(distinct destination_city) from orders;

---lets see the total no of destination state people travelled in
select  count(distinct state) from orders;

---lets see the total no of destination country people travelled in
select  count(distinct origin_country) from orders;

--let see the total no.of location people came from
select  count(distinct location) from orders;

--total no of hotels by their payment method
select count(hotel_name)as no_of_hotels , payment_mode from orders
group by Payment_Mode
order by payment_mode desc;





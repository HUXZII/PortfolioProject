use superstore;
select * from superstore;

#to see a schema of a table
desc superstore;

#how many sales happened by region 
select region,round(sum(sales),2)total_sales from superstore
group by region
order by sales;

#how many sales happened by state
select state,round(sum(sales),2)total_sales from superstore
group by state
order by sales desc;

#how many sales happened by cities
select city,round(sum(sales),2)total_sales from superstore
group by city
order by sales desc;

#top region by sales
select region,round(sum(sales))total_sales from superstore 
group by region 
order by sales;

#top 5 state by most sales
select state,round(sum(sales),2)total_sales from superstore
group by sales
order by sales desc limit 5;

#top 5 cities by most sales
select city,round(sum(sales),2)total_sales from superstore
group by city 
order by sales desc limit 5;

#least sales by region
select region,sales from superstore
group by region 
order by sales;

#least 5 states by sales
select state,sales from superstore
group by state
order by sales limit 5;

#lease 5 cities by sales
select city,sales from superstore
group by city
order by sales limit 5;

#top products sales
select category,sales from superstore
group by category
order by sales desc;

#least product by sales
select category,sales from superstore
group by category
order by sales;

#top 5 sub category sales
select sub_category,sales from superstore
group by sub_category
order by sales desc limit 5;

#least 5 sub category sales
select sub_category,round(sum(sales),2)total_sales from superstore
group by sub_category
order by sales desc;

#top 5 customer by sales
select customer_name,round(sum(sales),2)total_sales from superstore
group by customer_name
order by sales desc;

#least 5 customer by sales
select customer_name,round(sum(sales),2)total_sales from superstore
group by customer_name
order by sales;

#top 5 days by sales
select order_date,sum(sales)sales from superstore
group by order_date
order by sales;

#least 5 days by sales
select order_date,round(sum(sales),2)sales from superstore
group by order_date
order by sales;

#top shipmodes by sales
select ship_mode,sales from superstore
group by ship_mode 
order by sales desc;

#least shipmode by sales
select ship_mode,sales from superstore
group by ship_mode
order by sales limit 1;

#top 5 customer by orders 
select customer_name,round(sum(sales),2)as sales from superstore
group by customer_name
order by sales desc limit 5;


#least 5 customers by orders
select customer_name,round(sum(sales),2)as sales from superstore
group by customer_name
order by sales limit 5;



#top 5 dates when the order is high
select order_date,count(order_date)orders from superstore
group by order_date 
order by count(order_date)desc limit 5;

#least 5 dates when the order is lowest
select order_date,count(order_date)orders from superstore
group by order_date 
order by count(order_date) limit 5;

#orders disribution by ship_mode 
select ship_mode,count(ship_mode)orders from superstore
group by ship_mode
order by orders desc;

#order divided in segments
select segment,count(segment)orders from superstore
group by segment
order by count(segment) desc ;

#creating view to see the customer's information
create view customer_info_
as select customer_name,country,city,state from superstore
group by customer_name;


#calling view to see the customer info
select * from customer_info;


#creating stored procedurs so that i can easily get sub categories by writing category name
call get_subcategories('furniture');
call get_subcategories('technology');
call get_subcategories('office supplies');

#highest sales in each category using window function
select * from (select category,sales,
row_number() over(partition by category order by sales desc) rn  from superstore) x
where x.rn=1; 

#lowest sales by category using window function
select * from (select category,sales,row_number() over 
(partition by category order by sales)as rn from superstore)x
where rn<2;



select * from (select category,sales,
	rank() over(partition by category order by sales desc) rnk from superstore) x
	where rnk=1; 
    
    
select sub_category,sales,lag(sales,1,0) over (partition by category order by sales)as prev_sales from superstore;

select sales from superstore
order by sales desc;


select max(sales) from superstore
where sales not in (select max(sales) from superstore);

select sales from (select sales,dense_rank() over (order by sales desc)as rnk from superstore)x
where x.rnk=2;

select sales,row_number() over (order by sales) from superstore;
select count(row_id) from superstore;
select row_id from superstore;
select row_id,sales from superstore as s1
where row_id=(select max(row_id) from superstore as s2
where s1.row_id=s2.row_id);
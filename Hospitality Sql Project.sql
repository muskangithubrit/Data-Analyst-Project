-- 1.Total Revenue
select sum(revenue_realized) 
as TotalRevenue 
from fact_bookings;


-- 2.Occupancy 
select round(sum(successful_bookings)/sum(capacity)*100,2) 
as "Occupancy Rate"
from fact_aggregated_bookings;


-- 3. Cancellation Rate
select round((sum(case when booking_status="cancelled" then 1 else 0 end)*100/ count(*)),2) 
as "CancellationRate"
from fact_bookings;


-- 4.Total Booking
select count(booking_id) 
as TotalBookings
from fact_bookings;


-- 5.Utilize capacity 
select sum(capacity) 
as UtilizeCapacity 
from fact_aggregated_bookings;


-- 6.Trend Analysis 
select dim_hotels.city,sum(fact_bookings.revenue_generated) 
as  RevenueGenerated ,sum(fact_bookings.revenue_realized) 
as RevenueRealized
from dim_hotels
join fact_bookings
on dim_hotels.property_id=fact_bookings.property_id
group by dim_hotels.city;


-- 7 Weekday  & Weekend  Revenue and Booking   
select
    dim_date.day_type,
    sum(fact_bookings.revenue_realized) AS TotalRevenue,
    count(fact_bookings.booking_id) AS TotalBookings
from dim_date join
    fact_bookings on fact_bookings.check_in_date
group by dim_date.day_type;

-- 8.Revenue by State & hotel
select  dim_hotels.city,dim_hotels.property_name as  PropertyNames ,sum(fact_bookings.revenue_realized) as TotalRevenue
from fact_bookings join dim_hotels
on  fact_bookings.property_id=dim_hotels.property_id
group by dim_hotels.city,dim_hotels.property_name
order by TotalRevenue desc;


-- 9.Class Wise Revenue
select 
dim_rooms.room_class as RoomClass ,sum(fact_bookings.revenue_realized) as TotalRevenue
from dim_rooms join fact_bookings
on dim_rooms.room_id=fact_bookings.room_category
group by dim_rooms.room_class;


-- 10.Checked out cancel No show
select booking_status,count(*) 
as BookingStatusCount
from fact_bookings
where booking_status in ('Checked Out', 'Cancelled', 'No Show') 
group by booking_status ;


-- 11.Weekly trend Key trend (Revenue, Total booking, Occupancy) 
SELECT DIM_DATE.`WEEK NO`,SUM(FACT_BOOKINGS.REVENUE_REALIZED) AS `Total Revenue`,COUNT(FACT_BOOKINGS.BOOKING_ID) AS `Total Bookings`
FROM DIM_DATE JOIN FACT_BOOKINGS ON DIM_DATE.DATE = FACT_BOOKINGS.CHECK_IN_DATE 
GROUP BY DIM_DATE.`WEEK NO`;
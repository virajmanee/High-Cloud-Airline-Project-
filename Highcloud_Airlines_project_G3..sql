create database highcloud_airlines;
use highcloud_airlines;
show tables;
select * from maindata_final limit 5;
select count(*) from maindata_final;
alter table maindata_final rename column `Month (#)` to Month_New;
alter table maindata_final add column date_new date AS 
( concat( year,'-',month_new,'-',day) );

#-------------------------------------------------------------------------------------------------------------------
/*1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
   A.Year
   B.Monthno
   C.Monthfullname
   D.Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G.Weekdayname
   H.FinancialMOnth
   I. Financial Quarter */
create table calendar (
year int,
MONTH INT,
monthfullname varchar(50),
yearmonth varchar(50),
weekdayno int,
weekdayname varchar(10),
Quarters varchar (50),
financial_months varchar(50),
financial_quarters varchar(50)
);

insert into	calendar (year, MONTH, monthfullname, yearmonth, weekdayno, weekdayname, Quarters, financial_months, financial_quarters )
select
       year as year,
       month_new as month,
       monthname(date_new) as monthfullname,
       concat(year,'-', monthname(date_new)) as yearmonth,
       weekday(date_new) as weekdayno,
       
    case when weekday(date_new) = '0' then 'Monday'
    when weekday(date_new) = '1' then 'Tuesday'
    when weekday(date_new) = '2' then 'Wednesday'
    when weekday(date_new) = '3' then 'Thursday'
    when weekday(date_new) = '4' then 'Friday'
    when weekday(date_new) = '5' then 'Saturday'
    when weekday(date_new) = '6' then 'Sunday'
    end as weekdayname,
       
	case when monthname(date_new) in ('January','February','March') then 'Q1'
	when monthname(date_new) in ('April', 'May', 'June') then 'Q2'
	when monthname(date_new) in ('July', 'August','September') then 'Q3'
	else 'Q4' end as quarters,
       
	case
	when monthname(date_new) ='January' then 'FM10'
	when monthname(date_new) ='February' then 'FM11'
	when monthname(date_new) ='March' then 'FM12'
	when monthname(date_new) ='April' then 'FM1'
	when monthname(date_new) ='May' then 'FM2'
	when monthname(date_new) ='June' then 'FM3'
	when monthname(date_new) ='July' then 'FM4'
	when monthname(date_new) ='August' then 'FM5'
	when monthname(date_new) ='September' then 'FM6'
	when monthname(date_new) ='October' then 'FM7'
	when monthname(date_new) ='November' then 'FM8'
	when monthname(date_new) ='December' then 'FM9'
	end financial_months,
    
    case when monthname(date_new) in ('January','February','March') then 'FQ4'
    when monthname(date_new) in ('April', 'May', 'June') then 'FQ1'
	when monthname(date_new) in ('July', 'August','September') then 'FQ2'
    else 'FQ3' end as financial_quarters
    from maindata_final;

select * from calendar limit 10;

#-------------------------------------------------------------------------------------------------------------------
/*2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis
 ( Transported passengers / Available seats)*/
 select year, sum(`# Transported Passengers`) AS Total_Transported_Passengers, 
 sum(`# Available Seats`) AS Total_Available_Seats, 
 (sum(`# Transported Passengers`) / sum(`# Available Seats`) * 100) AS LoadFactor
 from maindata_final
 group by year;
 
 select month_new, sum(`# Transported Passengers`) AS Total_Transported_Passengers, 
 sum(`# Available Seats`) AS Total_Available_Seats, 
 (sum(`# Transported Passengers`) / sum(`# Available Seats`) * 100) AS LoadFactor
 from maindata_final
 group by month_new
 order by month_new;
 
 select quarter(date_new), sum(`# Transported Passengers`) AS Total_Transported_Passengers, 
 sum(`# Available Seats`) AS Total_Available_Seats, 
 (sum(`# Transported Passengers`) / sum(`# Available Seats`) * 100) AS LoadFactor
 from maindata_final
 group by quarter(date_new)
 order by quarter(date_new);
 
 #-------------------------------------------------------------------------------------------------------------------
/*3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)*/
select `Carrier Name` AS Carrier_Name, sum(`# Transported Passengers`) AS Total_Transported_Passengers, 
 sum(`# Available Seats`) AS Total_Available_Seats, 
 (sum(`# Transported Passengers`) / sum(`# Available Seats`) * 100) AS LoadFactor
 from maindata_final
 group by `Carrier Name`
 order by LoadFactor desc;
 
 #-------------------------------------------------------------------------------------------------------------------
/*4. Identify Top 10 Carrier Names based passengers preference */
select `Carrier Name` AS Carrier_Name,  sum(`# Transported Passengers`) AS Passengers
from maindata_final group by Carrier_Name order by Passengers desc limit 10;

#-------------------------------------------------------------------------------------------------------------------
/*5. Display top Routes ( from-to City) based on Number of Flights */
select `From - To City` AS From_To_City, count(`From - To City`) AS No_of_Flights
from maindata_final group by `From - To City` order by count(`From - To City`) desc limit 10;

#-------------------------------------------------------------------------------------------------------------------
/*6. Identify the how much load factor is occupied on Weekend vs Weekdays. */
select 
case when weekday(date_new) IN ('5','6')
 then 'WeekEnd' 
 ELSE 'WeeKDay' 
 END AS WeekDayName,
sum(`# Transported Passengers`) AS Total_Transported_Passengers, 
sum(`# Available Seats`) AS Total_Available_Seats, 
(sum(`# Transported Passengers`) / sum(`# Available Seats`) * 100) AS LoadFactor
from maindata_final
group by WeekDayName;

#-------------------------------------------------------------------------------------------------------------------
/*7. Identify number of flights based on Distance group*/
select `%Distance Group ID` AS DistanceGrpID, count(distinct(`%Airline ID`)) AS TotalFlights
from maindata_final
group by DistanceGrpID;
 
 #-------------------------------------------------thank you-----
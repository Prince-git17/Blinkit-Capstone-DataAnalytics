use Blinkitdb;
select * from blinkit_data;


update blinkit_data
set Item_Fat_Content =
case 
when Item_Fat_Content IN ('LF','low fat') then 'Low Fat'
when Item_Fat_Content In ('reg') then 'Regular'
else Item_Fat_Content
end

select distinct Item_Fat_Content from blinkit_data;


-- total sales
select sum(Sales) as Total_Sales from blinkit_data;

select cast(sum(Sales)/1000000 as decimal(10,2)) as Total_Sales_millions from blinkit_data;

-- Average sales
select cast(AVG(Sales) as decimal(10,0)) as Avg_Sales from blinkit_data;

-- Number of items
select count(*) as No_Of_Items from blinkit_data;

-- Average rating
select cast(avg(Rating) as decimal (10,2)) as Avg_Rating from blinkit_data

-- All KPIs by fat content
select Item_Fat_Content,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Item_Fat_Content 
order by Total_Sales Desc

-- All KPIs by item type
select Item_Type,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Item_Type 
order by Total_Sales Desc

select top 5 Item_Type,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Item_Type 
order by Total_Sales Desc

-- fat content by outlet location for all KPIs
select Outlet_Location_Type, Item_Fat_Content,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Outlet_Location_Type, Item_Fat_Content
order by Outlet_Location_Type

-- fat content by outlet location for total sales
select Outlet_Location_Type,
	isnull([Low Fat],0) as Low_Fat,
	isnull([Regular],0) as Regular
from 
(
	select Outlet_Location_Type, Item_Fat_Content,
		cast(sum(Sales) as decimal(10,2)) as Total_Sales
	from blinkit_data
	group by Outlet_Location_Type, Item_Fat_Content

)as SourceTable

pivot
(
 sum(Total_Sales)
 for Item_Fat_Content in ([Low Fat],[Regular])

)as pivottable

order by Outlet_Location_Type;


-- by outlet establishment
select Outlet_Establishment_Year,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Outlet_Establishment_Year 
order by Total_Sales Desc

-- percentage of sales by outlet size
select Outlet_Size,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast((sum(Sales)*100.0 /Sum(sum(Sales)) over()) as decimal(10,2)) as Sales_Percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales Desc


--by outlet location
select Outlet_Location_Type,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast((sum(Sales)*100.0 /Sum(sum(Sales)) over()) as decimal(10,2)) as Sales_Percentage,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Outlet_Location_Type 
order by Total_Sales Desc

--by outlet type
select Outlet_Type,
	cast(sum(Sales) as Decimal(10,2)) as Total_Sales,
	cast((sum(Sales)*100.0 /Sum(sum(Sales)) over()) as decimal(10,2)) as Sales_Percentage,
	cast(AVG(Sales) as decimal(10,0)) as Avg_Sales,
	count(*) as No_Of_Items,
	cast(avg(Rating) as decimal (10,2)) as Avg_Rating
from blinkit_data
group by Outlet_Type 
order by Total_Sales Desc
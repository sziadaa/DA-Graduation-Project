create view V_orders as 

select o.*, o.OrderID as oi ,[ProductID] ,[UnitPrice] ,[Quantity] ,[Discount] ,([UnitPrice]*[Quantity]) as Total_Sales
from [dbo].[Orders] o join [dbo].[OrdersDetails] od
on o.OrderID = od.OrderID
----------------------------------------------------------------------------
---- total Sales per categories ======

select [CategoryName], [Total_Sales] 
from [dbo].[V_orders] vo join [dbo].[Product] p
on p.[ProductID] = vo.[ProductID]
join [dbo].[Categories] c on c.[CategoryID] = p.[CategoryID]
----------------------------------------------------------------------------------------------
---- total Sales ======

select sum([Total_Sales]) as TotlaSales
from [dbo].[V_orders] 
----------------------------------------------------------------------------------------------
---- total Quantity ========

select COUNT([Quantity]) as TotlalQuan
from [dbo].[V_orders] 
----------------------------------------------------------------------------------------------
---- top 10 products based on sales ======

select top 10 [ProductName] , sum([Total_Sales]) as Total_Sales
from [dbo].[Product] p join [dbo].[V_orders] vo
on p.ProductID = vo.ProductID
group by [ProductName]
order by sum([Total_Sales]) desc
----------------------------------------------------------------------------------------------
---- top 3 categories based on sales ======

select top 3 [CategoryName] , sum([Total_Sales]) as Total_Sales
from [dbo].[Categories] c join [dbo].[Product] p
on c.CategoryID =p.CategoryID
join [dbo].[V_orders] vo on p.ProductID = vo.ProductID
group by [CategoryName]
order by sum([Total_Sales]) desc
----------------------------------------------------------------------------------------------
---- top 3 categories based on Total Quantity =========

select top 3 [CategoryName] , count([Quantity]) as TotlalQuan
from [dbo].[Categories] c join [dbo].[Product] p
on c.CategoryID =p.CategoryID
join [dbo].[V_orders] vo on p.ProductID = vo.ProductID
group by [CategoryName]
order by count([Quantity]) desc
----------------------------------------------------------------------------------------------
---- top 10 customers based on buying =========

select top 10 [CustomerCompanyName] , sum([Total_Sales]) as Total_Sales
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID = vo.CustomerID
group by [CustomerCompanyName]
order by sum([Total_Sales]) desc
----------------------------------------------------------------------------------------------
---- top 10 customers based on total orders ========

select top 10 [CustomerCompanyName] , count([Quantity]) as TotlalQuan
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID = vo.CustomerID
group by [CustomerCompanyName]
order by count([Quantity]) desc
----------------------------------------------------------------------------------------------
---- top 5 Country based on Orders ======

select top 5 [CustomerCountry] , count([OrderID]) as Tot_OrderNum
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID = vo.CustomerID
group by [CustomerCountry]
order by count([OrderID]) desc
----------------------------------------------------------------------------------------------
---- contact title vs total sales and orders  ======

select [ContactTitle] , sum([Total_Sales]) as Total_Sales , count(vo.[OrderID]) as Tot_OrderNum 
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID = vo.CustomerID
group by [ContactTitle]
order by 2 desc
----------------------------------------------------------------------------------------------
---- most shipping company based on Total Orders ======

select top 1 [CompanyName] , COUNT([OrderID]) as T_Num_Orders
from [dbo].[Shippers] s join [dbo].[V_orders] vo
on s.ShipperID = vo.ShipperID
group by [CompanyName]
order by COUNT([OrderID]) desc 
------------------------------------------------------------------
-- Average order payment, Count of orders for the customers =====

select  [CustomerID], avg([Total_Sales]) as Avg_Totalsales , COUNT([OrderID]) as T_Num_Orders
from [dbo].[V_orders] 
group by [CustomerID]
order by  COUNT([OrderID]) desc
------------------------------------------------------------------
-- Count purchased in Augest-1996 =====

select [CustomerID] ,[ShippedDate] ,COUNT([OrderID]) as T_Num_Orders 
from [dbo].[V_orders]
where FORMAT([ShippedDate] , 'yyy-MM') = '1996-08'
group by [CustomerID] ,[ShippedDate]
order by  COUNT([OrderID]) desc
------------------------------------------------------------------
-- Customer purchase trend Year-on-Year =====

select [CustomerID] ,format([ShippedDate] ,'yyyy' ) as ShippedYear ,sum ([Total_Sales]) as Total_sales
from [dbo].[V_orders]
group by [CustomerID] ,[ShippedDate]
order by format([ShippedDate] ,'yyyy' ) desc
------------------------------------------------------------------
-- Average of days between order date and delivery date =====

select [OrderID],[OrderDate] ,[ShippedDate] , avg(DATEDIFF(DAY,[OrderDate],[ShippedDate])) as avg_days
from [dbo].[V_orders]
group by [OrderID],[OrderDate] ,[ShippedDate] 
order by avg(DATEDIFF(DAY,[OrderDate],[ShippedDate])) desc
------------------------------------------------------------------
--- Top 5 Cities with highest revenue from 1997 to 1998 =====

select top 5 [CustomerCity] , [ShippedDate] ,sum([Total_Sales]) as Total_sales
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID =vo.CustomerID
where format([ShippedDate] ,'yyyy' ) between 1997 and 1998
group by [CustomerCity] , [ShippedDate]
order by  sum([Total_Sales]) desc
------------------------------------------------------------------
/* flag each seller as (below target(<2000) – within target (2000 - 3000) – above target (> 3000))  
based on no of sold items and revenue */

select [SuppliersCompanyName] ,count([ProductID]) as total_product , sum([UnitsInStock]*[UnitPrice]) as total_sales,
case 
when sum([UnitsInStock]*[UnitPrice]) <2000 then 'below target'
when sum([UnitsInStock]*[UnitPrice]) between 2000 and 3000 then 'within target'
when sum([UnitsInStock]*[UnitPrice])  > 3000 then 'above target' end as Target_
from [dbo].[Suppliers] s join [dbo].[Product] p
on s.SupplierID = p.ProductID 
group by [SuppliersCompanyName]
------------------------------------------------------------------
---- Who is the senior most employee based on job title?

select ([FirstName]+ '' +[LastName]) as Full_Name,[Title] ,[ReportsTo]
from [dbo].[Employees]
order by [ReportsTo] asc
------------------------------------------------------------------
---- Write a query that returns one city that has the highest sum of invoice totals.

select top 1 [CustomerCity] ,sum([Total_Sales]) as Total_sales
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID =vo.CustomerID
group by [CustomerCity] 
order by  sum([Total_Sales]) desc
------------------------------------------------------------------
/* Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money */

select  top 1 [CustomerCompanyName] , sum([Total_Sales]) as Total_sales
from [dbo].[Customers] c join [dbo].[V_orders] vo
on c.CustomerID = vo.CustomerID
group by [CustomerCompanyName] 
order by  sum([Total_Sales]) desc
------------------------------------------------------------------

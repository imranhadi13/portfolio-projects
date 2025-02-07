-- Project Goal - Northwinds - analysis of sales based on product
-- assess relevant table

SELECT * 
FROM dbo.[Order Details]

SELECT * 
FROM dbo.Orders

SELECT * 
FROM dbo.Categories

SELECT * 
FROM dbo.Orders

-- assess years relevant for the sales 

SELECT 
	MIN(YEAR(OrderDate)) AS min_year,
	MAX(YEAR(OrderDate)) AS max_year
FROM dbo.Orders
-- the year from dataset listed orders from 1996 to 1998 

-- join Order Details table and Products table to retrieve product name from list of orders 

SELECT 
	order_list.OrderID,
	products.ProductName,
	order_list.UnitPrice,
	order_list.Quantity,
	order_list.Discount
FROM dbo.[Order Details] AS order_list
	LEFT JOIN dbo.[Products] as products
	ON order_list.ProductID = products.ProductID

	-- calculate revenue per each order, aggregate by product, and order by highest sum of sales made 

SELECT 
	products.ProductName AS product_name,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN dbo.[Products] as products
	ON order_list.ProductID = products.ProductID
GROUP BY products.ProductName
ORDER BY sales DESC

-- based on the result, the top 5 selling products were Cote de Blaye, Thuringer Rostbratwurst, Raclette Courdavault, Camembert Pierrot, Tarte au sucre
-- combine the previous table with categories to assess categories' name of top selling product 

SELECT 
	category_list.ProductName AS product_name,
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.ProductName, category_list.CategoryName
ORDER BY sales DESC

-- based on the result, from the top 5 best selling products, 2 of them are dairy products, and others are from beverages, meat/poultry, confections category
-- assessing best selling categories and percentages from total sales

SELECT 
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales,
	(SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) / SUM(SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity)) OVER ()) * 100 AS sales_percentage
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.CategoryName
ORDER BY sales DESC

-- based on the result, the best selling category is beverages, followed by dairy products, and meat/poultry and confections has almost similar percentages  

-- assessing top selling products in beverages

SELECT 
	category_list.ProductName,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
WHERE category_list.CategoryName = 'Beverages' 
GROUP BY category_list.ProductName
ORDER BY sales DESC

-- top 3 selling beverages are Cote de Blaye, Ipoh Coffee, Chang 

-- assessing top selling products in dairy products

SELECT 
	category_list.ProductName,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
WHERE category_list.CategoryName = 'Dairy Products' 
GROUP BY category_list.ProductName
ORDER BY sales DESC

-- top 3 selling dairy products are Raclette Courdavault, Camembert Pierrot, Mozzarella di Giovanni

-- assessing top selling products in meat/poultry

SELECT 
	category_list.ProductName,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
WHERE category_list.CategoryName = 'Meat/Poultry' 
GROUP BY category_list.ProductName
ORDER BY sales DESC

-- top 3 selling meat/poultry are Thuringer Rostbratwurst, Alice Mutton, Perth Pasties


-- assessing top selling products in confections

SELECT 
	category_list.ProductName,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
WHERE category_list.CategoryName = 'Confections' 
GROUP BY category_list.ProductName
ORDER BY sales DESC

-- top 3 selling confections are tarte au sucre, Sir Rodney's Marmalade, Gumbar Gumiibarchen

-- assessing worst selling products and their categories

SELECT 
	category_list.ProductName AS product_name,
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.ProductName, category_list.CategoryName
ORDER BY sales ASC

-- based on the result, the worst selling products was Chocolade (Confections), Geitost (Dairy Products), Genen Shouyu (Condiments), Laughing Lumberjack Lager (Beverages), Longlife Tofu (Produce) 

-- assessing worst selling categories 

SELECT 
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.CategoryName
ORDER BY sales ASC

-- based on the result, the worst selling category was grains/cereals, followed by produce and condiments 

-- save for future view 
CREATE VIEW best_selling_product AS
SELECT TOP 5  
	category_list.ProductName AS product_name,
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.ProductName, category_list.CategoryName
ORDER BY sales DESC;

CREATE VIEW best_selling_categories AS

SELECT TOP 5
	category_list.CategoryName AS category,
	SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) AS sales,
	(SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity) / SUM(SUM((order_list.UnitPrice - order_list.Discount) * order_list.Quantity)) OVER ()) * 100 AS sales_percentage
FROM dbo.[Order Details] AS order_list
	LEFT JOIN 
		(
		SELECT products.ProductID, products.ProductName, categories.CategoryName
		FROM dbo.[Products] as products 
		LEFT JOIN dbo.Categories as categories
		ON products.CategoryID = categories.CategoryID
		) AS category_list
	ON order_list.ProductID = category_list.ProductID
GROUP BY category_list.CategoryName
ORDER BY sales DESC

-- Findings
-- from above analysis, the categories with highest revenue were beverages, followed by dairy products, and meat/poultry and confections  
-- while the categories with least revenue were grains/cereals, followed by produce and condiments 
-- meanwhile, the top selling products were Cote de Blaye (beverages), Thuringer Rostbratwurst (meat/poultry), Raclette Courdavault (dairy product) 
-- while the least selling products were Chocolade (Confections), Geitost (Dairy Products), Genen Shouyu (Condiments)

-- Further recommendation:
-- the store can maximise revenue by prioritising sales on top-selling categories and products and consider discontinuing products with least revenue 
-- however, for proper assessment on profitability of the products, we also require details on the cost of the products
-- thus profit can be calculated by deducting revenue from the cost, and thus provide better picture on profitability, which may not shown by assessing the revenue only 
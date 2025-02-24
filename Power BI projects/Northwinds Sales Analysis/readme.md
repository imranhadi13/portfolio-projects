Nortwinds Sales Power BI analysis

Goal: To analyse and visualise data for sales for Northwinds company based on various aspects, and gaining insights for further recommendation.

Download link:
[Northwinds Sales Analysis pbix file]()
[Northwinds Sales Analysis pdf file]()

 *(due to limitation of my account, I am not able to embed the Power BI report for ease of viewing. You may download the PBIX report file or pdf report extract from the link above to view the Power BI report. You may also scroll further under further information for the project for images and descriptions behind the project)*

Description: 
The analysis had been carried out for Northwinds sample databases, which provided information regarding operational activity for the company, from sales data, to information about employees. Relevant variables had been analysed to gain insight for the main task. 

Skills: power query transformation, semantic model creation, DAX query, data visualization

Technology: Power BI 

Raw dataset: [Northwinds SQL sample](https://github.com/microsoft/sql-server-samples/blob/e74af02add614d7ec764dd2a68bce3364250a3ff/samples/databases/northwind-pubs/instpubs.sql)

Detailed steps about this project:
The data was imported from database for the Northwinds dataset, and relevant tables had been selected. 
>![Import]()

The table then underwent analysis of relevant tables and transformation under Power Query (including renaming columns) before loaded onto the Power BI for further analysis. 
>![Power Query]()

Semantic model was created. 
New 'Date' table was also created using DAX CALENDARAUTO() to facilitate analysis based on date value. 
>![Semantic Model]()

In the data visualization phase, the visuals were created
- this phase also includes creating new measures and calculated column by using DAX query to aggregate the data including but not limited to: 
-- combining Company and Country in single column using calculated column 
-- revenue calculation for each rows in 'Order Details' using measure and DAX query 
-- using measure to derive previous year sales 

Report pages: 
i) Dashboard
- homepage to navigate to 3 main pages: 'Sales in Country', 'Sales in Product and Categories', 'Sales in Year'
Each report pages include navigation to return to the dashboard.
>![Dashboard]()

ii) Sales in country 
>![Sales in country]()
Provided analysis based on country aspects. 

Included the following visuals: 
-- column chart for sum of total revenue by country
-- multi-row card for top 3 companies
-- card for sum of total revenue
-- card for number of companies
-- map visual for sum of total revenue by country

User able to highlight specific country's revenue by selecting them either in the column chart or the map visual. 

ii) Sales in product and categories 
>![Sales in product and categories]()
Provided analysis of sales based on products and categories. 

Included the following visuals: 
-- bar chart for sum of total revenue by category
-- card for sum of total revenue
-- treemap for top vs least selling products overview

User able to filter for the sales of the product/categories based on country by using the country filter. 

User also able to toggle between most profitable and least profitable product and categories filter using bookmark provided in upper right of the page. 

ii) Sales in year 
>![Sales in year]()
Provided analysis of sales based on yearly sales. 

Included the following visuals:
-- KPI visual for sum of total revenue by year, which includes visual comparison for previous year sales
-- multi row-card for top 3 products in the period
-- multi row-card for top 3 categories in the period 
-- line chart for sum of total revenue by year and month
-- line chart for sum of total revenue by year and categories

User able to filter the sales based on the year by using the filter on upper left. 

Insights from the Power BI analysis:
- the highest revenue was from Germany (16.28%), followed by USA (15.92%) and Austria (8.53%).
- the top selling categories were beverages, dairy products, and confections
- the top selling products were Cote de Blaye (beverages), Raclette Courdavault (dairy products), Camembert Pierrot (dairy products) 
- the least selling products were Lousiana Hot Spiced Okra (condiments), Filo Mix (grains/cereals), Valkoinen suklaa (Confections) 
- there is an upward train in the yearly sales from 1996 to latest year 1998 
- beverages maintain as the highest selling categories across the years 

Recommendation:
- for better profitability measure, the information about cost of each products can be gathered, in order to measure the profit (by calculating revenue less cost) 
- the company can prioritize on products and categories with highest revenues, and consider discontinuing the ones with least revenue 
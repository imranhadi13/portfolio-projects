Malaysian Flood Power BI Analysis

Goal: To analyse and visualize data behind flood events in Malaysia across years and states, and provide insights for further recommendation.

Download link:
[Malaysian Flood Power BI .pbix file]()
[Malaysian Flood Power BI pdf report]()
 *due to limitation of my account, I am not able to embed the Power BI report for ease of viewing. You may download the PBIX report file or pdf report extract from the link above to view the Power BI report. You may also scroll further under further information for the project for images and descriptions behind the project*

Description: 
The dataset included flood events throughout Malaysia, with information on state, district, and year, and sum of  monthly and annual rainfall for the month. This project included power query transformation, semantic model creation, DAX query to create measures and calculated columns, and data visualization using Power BI tools.

Skills: power query transformation, semantic model creation, DAX query, data visualization

Technology: Power BI 

Raw dataset: [Malaysian Flood](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/_MalaysiaFloodDataset_MalaysiaFloodDataset.csv)

Further information about this project:
The data was loaded from csv file _MalaysiaFloodDataset_MalaysiaFloodDataset and underwent transformation under Power Query, including:
- amended rows 
- creating new table to separate the dataset for annual records and monthly rainfall amount
- creating new column based on existing column (e.g. creating unique state-district key)
>![Power Query](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/power%20query.png)

Semantic model was created and linked between the tables
- new 'Date' table was also created using DAX CALENDARAUTO() function to link between the tables' date value
- new 'State-District' table was also created to link between the unique state-district key between the annual and monthly table 
>![Semantic model](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/semantic%20model.png)

In the data visualization phase, the visuals were created
- this phase also includes creating new measures and calculated column by using DAX query to aggregate the data 

Report pages: 
i) Dashboard
- homepage to navigate to 3 main pages: 'Flood events by year', 'Flood events by states', 'Annual rainfall statistics'
>![Dashboard](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/dashboard.png)

ii) Flood events by year (hidden) 
- visuals including proportion of flood occurrences for the year, number of flood occurrences, and trend of flood of occurrences across the year 
- includes button to navigate to homepage or two other main pages
>![Flood event by year](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/flood%20by%20year.png)

iii) Flood events by state (hidden) 
- visuals including flood occurrences across 13 states, proportion of flood occurrences across 13 states 
- includes button to navigate to homepage or two other main pages as well as button to view the flood occurrences on district level 
>![Flood event by state](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/flood%20by%20year.png)

iv) Annual rainfall statistics (hidden)
- visuals including rainfall and flood count across the years and flood percentages and average annual rainfall (this included measures flood% and ratio of average annual rainfall to flood% for better visualization of the 
- includes button to navigate to homepage or two other main pages as well as button to view the flood occurrences on district level
>![Annual rainfall](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/annual%20rainfall.png)

v) District flood event (hidden) 
- visual including flood occurrences by district 
- includes button to return to previous page (flood events by state) 
>![District flood](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/district%20flood.png)
vi) Monthly rainfall (hidden) 
- visual including monthly rainfall trend 
- includes button to return to previous page (annual rainfall statistics)
>![Monthly rainfall](https://github.com/imranhadi13/portfolio-projects/blob/49f59a052eb34cf4466614e778f5cb5cddd820e0/Power%20BI%20projects/Malaysian%20Flood/screenshots/monthly%20rainfall.png)

Insights from the Power BI analysis:
- there are proportionately more years without flood compared to years with flood (54% and 46% respectively)
- state 106, 107, and 109 has proportionally more flood occurrences compared to other states
- flood with higher flood percentages also has proportionately higher annual rainfall amount

Recommendation:
- further information regarding the states could be gathered (e.g. urbanization level, latitude/longitude) to analyse further insight regarding the flood occurrences 
- further record regarding the flood events (e.g. the month they occurred) is also valuable to correlate the monthly rainfall and flood events 
- states with higher proportion of flood occurrences require more attention and preparation for future flood events

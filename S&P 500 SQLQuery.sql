--Assigning appropriate DataTypes
ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN date DATE;

AlTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN open_ FLOAT;

ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN high_ FLOAT;

ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN low FLOAT;

ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN close_ FLOAT;

ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ALTER COLUMN volume FLOAT;


--Creating a column for volatility
ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ADD volatility as "high_" - "low";

--Creating a column for day_of_week
ALTER TABLE [S&P 500 Stock Prices].[dbo].[Stock_Prices]
ADD day_of_week as DATENAME(WEEKDAY,date);


--Date when the highest volume traded
SELECT date
	,symbol
	,volume
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE volume in (
					SELECT MAX(volume) --the highest volume traded
					FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
)

--Accessing the two stocks that traded most from the date gotten above
SELECT symbol
	,volume
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE date = '2014-02-24'
ORDER BY 2 DESC
OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY;

--Getting AMZN (Amazon) volatility 
SELECT STDEVP(volatility) AS Volatility_Rate
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE symbol = 'AMZN'

--Day Amazon saw the most volatility
SELECT date  
	,volatility
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE volatility = (
						select max(volatility) 
							from [S&P 500 Stock Prices].[dbo].[Stock_Prices]
							where symbol = 'AMZN')


--Creating Table with the with the closing price of each stock on 2014-01-12
SELECT DISTINCT symbol 
			,date 
			,close_ 
INTO purchase_price
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE date = '2014-01-02'

--Creating Table with the with the closing price of each stock on 2014-01-12
SELECT DISTINCT symbol 
			,date 
			,close_, 
INTO present_price
FROM [S&P 500 Stock Prices].[dbo].[Stock_Prices]
WHERE date = '2017-12-29';

--Calculating the profit(percentage gain) to be made investing in each stock 
SELECT present_price.symbol
	,ROUND(((present_price.close_ - purchase_price.close_)/purchase_price.close_)*100,2) AS profit
FROM present_price
INNER JOIN purchase_price 
ON purchase_price.symbol = present_price.symbol
ORDER BY 2 DESC;

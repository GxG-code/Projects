/* 

Data exploration for carbon footprints of 866 commercial products across 8 industry sectors and 5 continents

*/


-- Looking at the data

SELECT *
FROM product_emissions


-- Checking Coca-Cola emissions as more familiar product, which is made by multiple companies around the globe

SELECT *
FROM product_emissions
WHERE company LIKE '%Coca-Cola%'
ORDER BY carbon_footprint_pcf DESC;


-- Checking the year of most recent data collected

SELECT MAX(year)
FROM product_emissions


-- Industries with the most emissions

SELECT industry_group, ROUND(SUM(carbon_footprint_pcf),0) AS total_industry_footprint
FROM product_emissions
GROUP BY industry_group, year
HAVING year = 2017
ORDER BY total_industry_footprint DESC;


-- Looking into which industries are most heavily represented by the number of companies

SELECT industry_group, COUNT(*) AS count_industry
FROM product_emissions
GROUP BY industry_group, year
HAVING year = 2017
ORDER BY count_industry DESC;


-- Examining the Capital Goods Industry as the second biggest emitter with only 4 companies

SELECT industry_group, company, product_name, carbon_footprint_pcf
FROM product_emissions
WHERE year = '2017'
	AND industry_group = 'Capital Goods'
ORDER BY carbon_footprint_pcf DESC;


-- Capital Goods lifecycle emissions

SELECT product_name, 
		company,
		carbon_footprint_pcf,
		upstream_percent_total_pcf,
		operations_percent_total_pcf, 
		downstream_percent_total_pcf
FROM product_emissions
WHERE year = '2017'
	AND company LIKE '%Daikin%'
ORDER BY carbon_footprint_pcf DESC;


--  Emissions by country

SELECT country, SUM(carbon_footprint_pcf) AS total_country_footprint
FROM product_emissions
GROUP BY country
ORDER BY total_country_footprint DESC;


-- Why Spain is the number one co2 emitter

SELECT year, company, product_name, carbon_footprint_pcf
FROM product_emissions
WHERE country = 'Spain'
ORDER BY carbon_footprint_pcf DESC;

--Based on the analysis conducted, it can be concluded that Spain emerges as a major emitter among countries,
--with Gamesa Corporacion, a Spanish company operating in the Electrical Equipment and Machinery industry group, 
--notably contributing to emissions, particularly through the production of Wind Turbines
--This conclusion underscores the significance of addressing emissions associated with steel production


/* Quick exploration of upstream, operations, and downstream carbon footprints: insights and reasons */

SELECT *
FROM product_emissions
--WHERE year = '2017'
ORDER BY upstream_percent_total_pcf DESC

-- The technology hardware and equipment industry group may have a high upstream percent of carbon footprint due to several factors: 
-- supply chain complexity, raw material extraction and processing, global manufacturing, transportation and energy consumption


SELECT *
FROM product_emissions
--WHERE year = '2017'
ORDER BY operations_percent_total_pcf DESC

-- The materials, chemicals, and forest and paper products industries may have a high operations percent of carbon footprint due to several factors: 
-- energy intensive processes, chemical reactions and emissions, emissions from combustion, waste generation and treatment, and process efficiency and optimization


SELECT *
FROM product_emissions
--WHERE year = '2017'
ORDER BY downstream_percent_total_pcf DESC

-- There are many different industries and products that have a high downstream percent of carbon footprint emissions due to several factors:
-- product usage, product lifetime, waste generation, transportation and distribution and energy sources
-- Enable the local_infile setting on the MySQL server
SET GLOBAL local_infile = ON;

-- Create Database
DROP DATABASE world_population;
CREATE DATABASE world_population;

-- Select Database
USE world_population;

-- Create the Population table
CREATE TABLE population (
  num INT PRIMARY KEY,
  country VARCHAR(255),
  population VARCHAR(255),
  yearly_change FLOAT,
  net_change VARCHAR(255),
  density VARCHAR(255),
  land_area VARCHAR(255),
  migrants VARCHAR(255),
  fertility_rate FLOAT,
  med_age INT,
  urban_pop FLOAT,
  world_share FLOAT,
  UNIQUE INDEX idx_country (country)
);

-- Import the world-population-by-country-2020 CSV table
LOAD DATA LOCAL INFILE 'C:\\Users\\marid\\Desktop\\Aletia\\SQL Final\\world-population-by-country-2020.csv' INTO TABLE population
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 LINES

(@num, @country, @population, @yearly_change, @net_change, @density, @land_area, @migrants, @fertility_rate_str, @med_age_str, @urban_pop_str, @world_share)
SET
  num = @num,
  country = @country,
  population = COALESCE(CAST(NULLIF(REPLACE(@population, ',', ''), '') AS SIGNED), 0),
  yearly_change = CAST(@yearly_change AS FLOAT),
  net_change = COALESCE(CAST(NULLIF(REPLACE(@net_change, ',', ''), '') AS SIGNED), 0),
  density = COALESCE(CAST(NULLIF(REPLACE(@density, ',', ''), '') AS SIGNED), 0),
  land_area = COALESCE(CAST(NULLIF(REPLACE(@land_area, ',', ''), '') AS SIGNED), 0),
  migrants = COALESCE(CAST(NULLIF(REPLACE(@migrants, ',', ''), '') AS SIGNED), 0),
  fertility_rate = CAST(NULLIF(REPLACE(@fertility_rate_str, 'N.A.', ''), '') AS FLOAT),
  med_age = COALESCE(CAST(CASE WHEN @med_age_str = 'N.A.' THEN '0' ELSE REPLACE(@med_age_str, ',', '') END AS SIGNED), 0),
  urban_pop = CAST(NULLIF(REPLACE(REPLACE(@urban_pop_str, 'N.A.', ''), ',', ''), '') AS FLOAT),
  world_share = CAST(@world_share AS FLOAT);

-- Create the Capitals table
CREATE TABLE capitals (
  country VARCHAR(255),
  capital VARCHAR(255),
  continent VARCHAR(255),
  FOREIGN KEY (country) REFERENCES population(country)
);

-- Import the countries-continents-capitals CSV table
LOAD DATA LOCAL INFILE 'C:\\Users\\marid\\Desktop\\Aletia\\SQL Final\\countries-continents-capitals.csv' INTO TABLE capitals
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 2 LINES;

-- Create the Population Forecast table
CREATE TABLE population_forecast (
  year_f INT,
  population VARCHAR(255),
  yearly_change_pf FLOAT,
  yearly_change_f VARCHAR(255),
  median_age_f INT,
  fertility_rate_f FLOAT,
  density INT
);

-- Import the world-population-forecast-2020-2050 CSV table
LOAD DATA LOCAL INFILE 'C:\\Users\\marid\\Desktop\\Aletia\\SQL Final\\world-population-forcast-2020-2050.csv' INTO TABLE population_forecast
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 2 LINES

(@year_f, @population, @yearly_change_pf, @yearly_change_f, @median_age_f, @fertility_rate_f, @density)
SET
	year_f = @year_f,
    population = COALESCE(CAST(NULLIF(REPLACE(@population, ',', ''), '') AS SIGNED), 0),
    yearly_change_pf = @yearly_change_pf,
    yearly_change_f =  COALESCE(CAST(NULLIF(REPLACE(@yearly_change_f, ',', ''), '') AS SIGNED), 0),
    median_age_f = CASE WHEN @median_age_f = '' THEN NULL ELSE CAST(@median_age_f AS SIGNED) END,
    fertility_rate_f = CASE WHEN @fertility_rate_f = '' THEN NULL ELSE CAST(@fertility_rate_f AS FLOAT) END,
    density = @density;
/* 

COVID 19 Worldwide Data Exploration, With Focus on N. Macedonia ( Data Taken From https://ourworldindata.org/ on 2023-10-16) 

*/


SELECT *
FROM [Project COVID 19].dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY date DESC;
--ORDER BY location,date;


-- Starting Data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Project COVID 19].dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location,date;


--	Total Cases vs Total Deaths 
--	Shows likelihood of dying, if you contract covid

SELECT location, date, total_cases,total_deaths, (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS DeathPercentage
FROM [Project COVID 19].dbo.CovidDeaths
WHERE location LIKE '%macedonia%'
ORDER BY date DESC;


-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid

SELECT location, date, population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
FROM [Project COVID 19].dbo.CovidDeaths
--WHERE location LIKE '%macedonia%'
ORDER BY location, date;


-- Countries with Highest Infection Rate Compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM [Project COVID 19].dbo.CovidDeaths
--WHERE location LIKE '%macedonia%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Countries with the Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [Project COVID 19].dbo.CovidDeaths
--WHERE location LIKE '%macedonia%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Continents with the Highest Death Count per Population

SELECT continent, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM [Project COVID 19].dbo.CovidDeaths
--WHERE location LIKE '%macedonia%'
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 AS DeathPercentage
FROM [Project COVID 19].dbo.CovidDeaths
WHERE continent IS NOT NULL



-- Total Population vs Vaccinations
-- Percentage of population that has received at least one COVID vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population) * 100
FROM [Project COVID 19].dbo.CovidDeaths AS dea
JOIN [Project COVID 19].dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY location, date


-- Using CTE to perform calculation on partition by in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population) * 100
FROM [Project COVID 19].dbo.CovidDeaths AS dea
JOIN [Project COVID 19].dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY location, date
)

SELECT *, (RollingPeopleVaccinated / population) * 100 AS '%RollingPeopleVaccinated'
FROM PopvsVac


-- Using temp table to perform calculation on partition by in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population) * 100
FROM [Project COVID 19].dbo.CovidDeaths AS dea
JOIN [Project COVID 19].dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY location, date

SELECT *, (RollingPeopleVaccinated / Population) * 100 AS '%RollingPeopleVaccinated'
FROM #PercentPopulationVaccinated


-- View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population) * 100
FROM [Project COVID 19].dbo.CovidDeaths AS dea
JOIN [Project COVID 19].dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

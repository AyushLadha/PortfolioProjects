-- Covid19 data SQL queries

-- Covid cases and deaths
Select * 
from Covid19_deaths

---- Selecting data what we need
Select location, date, total_cases, new_cases, total_deaths, population
From Covid19_deaths
Order by 1,2

----Calculating Total death percentage according to total cases
---- As some attributes datatypes are nvarchar so to divide we convert them to decimal using CAST method
Select location, date, total_cases, total_deaths, (CAST(total_deaths as numeric)/CAST(total_cases as numeric))*100 as DeathPercentage
From Covid19_deaths
where location = 'India'
Order by 1,2

----Calculating what percentage of population got covid by total cases
Select location, date, population, total_cases,  (CAST(total_cases as numeric)/CAST(population as numeric))*100 as InfectedPopulationPercentage
From Covid19_deaths
where location = 'India'
Order by 1,2

--Looking countries with highest infection count as compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount,  MAX((CAST(total_cases as numeric)/CAST(population as numeric)))*100 as InfectedPopulationPercentage
From Covid19_deaths
--where location = 'India'
Group by location, population
Order by InfectedPopulationPercentage desc

-- Looking at Death count by location per population
Select location , MAX(CAST(total_deaths as numeric)) as TotalDeathCount
from Covid19_deaths
Where continent is Not Null
Group by location
order by TotalDeathCount desc

Select location , MAX(CAST(total_deaths as numeric)) as TotalDeathCount
from Covid19_deaths
Where continent is Null
Group by location
order by TotalDeathCount desc

-- Showing continent with highest death count per count
Select continent, MAX(CAST(total_deaths as numeric)) as TotalDeath 
from Covid19_deaths
where continent is not null
group by continent
order by TotalDeath desc


-- Above queries can be done by taking continent into account

-- Let's see some global numbers
Select  date, SUM(CAST(new_cases as numeric)) as Total_cases, SUM(CAST(new_deaths as numeric)) As Total_deaths 
From Covid19_deaths
where continent is not null
Group by date
Order by 1,2

-- For total cases and total deaths
Select SUM(CAST(new_cases as numeric)) as Total_cases, SUM(CAST(new_deaths as numeric)) As Total_deaths 
From Covid19_deaths
where continent is not null
--Group by date
Order by 1,2


-- Covid Vaccination

Select *
from Covid19_vaccinations

Select *
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date

  -- Total vaccination 

Select death.continent, death.location, death.date, death.population, vacc.total_vaccinations
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null
order by 1,2,3

Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null
order by 1,2,3


--- Looking vaccination date by date
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float, vacc.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) As RollingPeoplevacc
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null
order by 2,3

-- Total vaccination vs toal population
-- Using temp table

Drop Table if exists #PopulationVaccinationPercent
Create table #PopulationVaccinationPercent
(
Continent nvarchar(50),
Location nvarchar(50),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVacc numeric
)
Insert into #PopulationVaccinationPercent
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float, vacc.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) As RollingPeoplevacc
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null

Select *, (RollingPeopleVacc/Population) * 100 
from #PopulationVaccinationPercent


-- Creating view
Create view PopulationVaccinationPercent as
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float, vacc.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) As RollingPeoplevacc
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null


-- References :
-- https://github.com/AlexTheAnalyst
-- https://ourworldindata.org/  for covid data
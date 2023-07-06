Select *
From Covid19_vaccinations

-- 1. Total Vaccination
Select death.continent, death.location, death.date, death.population, vacc.total_vaccinations, vacc.new_vaccinations
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null
order by 1,2


-- 2. Looking vaccination date by date
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(float, vacc.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.date) As RollingPeoplevacc
from Covid19_deaths death
Join Covid19_vaccinations vacc
  on death.location = vacc.location 
  and death.date = vacc.date
where death.continent is not null
order by 2,3

-- 3. Total vaccination vs toal population
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

Select *, (RollingPeopleVacc/Population) * 100 as RollingVaccPercent
from #PopulationVaccinationPercent



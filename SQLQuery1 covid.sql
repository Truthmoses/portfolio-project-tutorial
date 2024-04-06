SELECT *
FROM Coviddeath
where continent is not null
order by 3,4 

--select *
--from covidvaccination
--order by 3,4

--select data that we are using next

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM Coviddeath
where continent is not null
order by 1,2

--looking at total case vs total death
--lilelihood of daying if you contract covid in your country
SELECT location, date, CAST(total_cases,total_deaths as INT), (total_deaths/total_cases)
FROM Coviddeath
where continent is not null
order by 1,2

--loking at the total case vs population
--shows the percentage of total casde to population
SELECT location, date, total_cases, population, (total_cases/population) as casepercentage
FROM Coviddeath
where continent is not null
--where location like '%state%'
order by 1,2

--looking at the percentage of infection rate to popluation
SELECT location, population, max(total_cases) as highestinfection, max((total_cases/population))*100 as infectionratetopolpulatio
FROM Coviddeath
group by location, population
where continent is not null
order by infectionratetopolpulatio desc
 
 --showing the country with highest death count per population
 SELECT location,max(cast(total_deaths as int)) as Deathrate
FROM Coviddeath
where continent is not null
group by location
order by Deathrate desc

--BREAK THINGS DOWN BY CONTINENT
SELECT continent,max(cast(total_deaths as int)) as Deathrate
FROM Coviddeath
where continent is NOT null
group by continent
order by Deathrate desc

--SHOWING THE CONTINENT WTH HIGHEST DEATH COUNT PER POPULATION
SELECT continent,max(cast(total_deaths as int)) as Deathrate
FROM Coviddeath
where continent is NOT null
group by continent
order by Deathrate desc 

--GLOBAL NUMBER

--looking at total population vs vaccination
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) 
OVER (partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE ) as rollingcount
from [PORTFOLIO PROJECT]..Coviddeath  dea
join [PORTFOLIO PROJECT]..Covidvaccination  vac
 on dea.location = vac.location
 and dea.date =vac.date
 where dea.continent is not null
 order by 2,3

 --use CTE
 with popvac (continent, location, date, population, new_vaccinations, rollingcount)
 as
 (
 select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) 
OVER (partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE ) as rollingcount
from [PORTFOLIO PROJECT]..Coviddeath  dea
join [PORTFOLIO PROJECT]..Covidvaccination  vac
 on dea.location = vac.location
 and dea.date =vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select *,(rollingcount/population)*100
 from popvac

 --TEMP Table as subtitute for cte
 drop table if exists #percentpopulationvaccinated
 Create Table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar (255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingcount numeric
 )
 
 insert into #percentpopulationvaccinated
 select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) 
OVER (partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE ) as rollingcount
from [PORTFOLIO PROJECT]..Coviddeath  dea
join [PORTFOLIO PROJECT]..Covidvaccination  vac
 on dea.location = vac.location
 and dea.date =vac.date
 where dea.continent is not null
 --order by 2,3
  select *,(rollingcount/population)*100
 from #percentpopulationvaccinated

 --creating view to store data later for visualization 

 create view percentpopulationvaccinated as
 select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) 
OVER (partition by dea.location ORDER BY DEA.LOCATION, DEA.DATE ) as rollingcount
from [PORTFOLIO PROJECT]..Coviddeath  dea
join [PORTFOLIO PROJECT]..Covidvaccination  vac
 on dea.location = vac.location
 and dea.date =vac.date
 where dea.continent is not null
 --order by 2,3

 select *
 from percentpopulationvaccinated
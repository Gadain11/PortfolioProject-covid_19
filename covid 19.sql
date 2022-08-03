
-- select data where going to use 

select location ,date,total_cases, new_cases,total_deaths, population 
from dbo.coviddeath
order by 1,2

-- Total Cases VS Total Death

select location ,date,total_cases,total_deaths , (total_deaths/total_cases)*100 as death_percentage
from dbo.coviddeath
order by 1,2

-- likelihood if you cantract covid in your country

select location ,date,total_cases,total_deaths , (total_deaths/total_cases)*100 as death_percentage
from dbo.coviddeath
where location like '% sudan%'
order by 1,2

-- Total Cases VS Population 

select location ,date,total_cases,population , (total_cases/population)*100 as populationinfectedpercentage
from dbo.coviddeath
where location like '%qatar%'
order by 1,2

-- Countries With Highest Infection Rate Compared to Population 

select location ,  population  , max(total_cases) as highestinfection , max((total_cases/population))*100 as populationinfectedpercentage
from dbo.coviddeath
group by location, population
order by 4 desc


-- Countries With Highest Death Count Population

select location , max(cast(total_deaths as int)) as highestdeaths 
from dbo.coviddeath
where continent is not null
group by location
order by 2 desc

--BREAK THINGS DOWN BY CONTINENT

select continent , max(cast(total_deaths as int)) as highestdeaths 
from dbo.coviddeath
where continent is not null
group by continent
order by 2 desc

select location , max(cast(total_deaths as int)) as highestdeaths 
from dbo.coviddeath
where continent is  null
group by location
order by 2 desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.coviddeath
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.coviddeath as dea
Join dbo.[covid vaccine] as vac
	On dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null
order by 2,3

with popvsvac (continent,location,date,population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.coviddeath as dea
Join dbo.[covid vaccine] as vac
	On dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null 
 )
 select *,( RollingPeopleVaccinated/population) from popvsvac
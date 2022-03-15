Select *
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
Order by 3,4;

--Select *
--From PortfolioProject..Covidvaccination
--Order by 3,4

Select Location, date, total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
Order by 1,2;

---- Looking at Total_cases VS Total_deaths----------------------------------
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Deathpercent
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
and location like '%India%' 
Order by 1,2;

-----Looking total-cases VS Population--------------------------------
Select Location, date, population,total_cases,(total_cases/population)*100 as DeathpercentPopulation
From PortfolioProject..CovidDeaths
where location like '%India%' 
Order by 1,2;

----- looking at Countries with Highest InfectionRate Compared to population------------

Select Location, population,
Max(total_cases)as HighestInfection_count,
Max((total_cases/population))*100 as PercentPopulationInfected

From PortfolioProject..CovidDeaths

----
where location like '%states%'
Group by location,population
Order by PercentPopulationInfected DESC;

---- showing countries HighestDeathCount Per population------------------
Select Location,Max(Cast(total_deaths as int))as TotalDeath_count
From PortfolioProject..CovidDeaths
where continent IS NOT NULL 

----where location like '%India%'
Group by location
Order by TotalDeath_count DESC;

---------- looking totaldeaths by Continents-------
Select location,Max(Cast(total_deaths as int))as TotalDeath_count
From PortfolioProject..CovidDeaths
where continent IS NULL 
Group by location
Order by TotalDeath_count DESC;

------ showing Continent with HighestDeathCount-------------
Select continent,Max(Cast(total_deaths as int))as TotalDeath_count
From PortfolioProject..CovidDeaths
where continent IS Not NULL 
Group by continent
Order by TotalDeath_count DESC;

--- Caculating Globally death percentage--------------------------
Select  Sum(new_cases) as totalCases, Sum(cast (new_deaths as int)) as totaldeaths, 
        Sum(cast(new_deaths as int))/Sum(New_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths
Where continent IS NOT NULL
--and location like '%India%' 
--group By date
Order by 1,2;
------------------------------------------------------------------------------------------------------


select*
From PortfolioProject..Coviddeaths Dea
Join PortfolioProject..Covidvaccination Vac
    On Dea.location=Vac.location
	and Dea.date=Vac.date;

-------------Looking for newvaccination-------------
select Dea.continent, Dea.location, Dea.date,dea.population, Vac.new_vaccinations
From PortfolioProject..Coviddeaths Dea
Join PortfolioProject..Covidvaccination Vac
    On Dea.location=Vac.location
	and Dea.date=Vac.date
Where Dea.continent IS NOT NULL
Order By 2,3

--------looking at Totalpopulation VS Vaccination-------

select Dea.continent, Dea.location, Dea.date,dea.population, Vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.Location, dea.Date) as RollingPeopleVaccinated 
From PortfolioProject..Coviddeaths Dea
Join PortfolioProject..Covidvaccination Vac 
    On Dea.location=Vac.location
	and Dea.date=Vac.date
Where Dea.continent IS NOT NULL
Order By 2,3

-----Use CTE------------------------------------ (could not use new column created for calculation Thats why using CTE)---
With PopVsVac (Continent, Location, date, Population, RollingPeopleVaccinated, new_vaccinations)
as
(
select Dea.continent, Dea.location, Dea.date,dea.population, Vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.Location, dea.Date) as RpllingPeopleVaccinated 
From PortfolioProject..Coviddeaths Dea
Join PortfolioProject..Covidvaccination Vac
    On Dea.location=Vac.location
	and Dea.date=Vac.date
Where Dea.continent IS NOT NULL
--Order By 2,3
)
Select Location,Population,(RollingPeopleVaccinated/Population)*100
From PopVsVac;
 




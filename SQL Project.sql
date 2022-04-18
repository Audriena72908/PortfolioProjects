Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select*
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using


--Looking at Total Cases vs Total 
--Shows likelihood of dying if you contract covid in your country

Select Location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location,date,population, total_cases , (total_cases/population)*100 as PercentPopulationInfected

From PortfolioProject..CovidDeaths
----Where location like '%state%'s
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to 


Select Location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths
--Where location like '%state%'s
Group by Location, Population
Order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population

Select location, Max(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population


Select continent, Max(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--GLOBAL NUMBERS,

Select SUM(new_cases) as total_cases, SUM(Cast(new_deaths as bigint)) as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths	
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2

--USE CTE

With PopsvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
FROM PopsvsVac

--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	 and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


--Create Data visualization later


Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Create View  PercentPopulationInfected as
Select Location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths
--Where location like '%state%'s
Group by Location, Population
--Order by PercentPopulationInfected desc

Select *
FROM PercentPopulationVaccinated;

Select *
FROM PercentPopulationInfected;





















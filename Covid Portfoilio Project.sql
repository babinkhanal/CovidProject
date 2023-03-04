Select *
From CovidDeaths$ 
where continent is not null
order by 3,4

--Select *
--From CovidVaccinations$ 
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths$
order by 1,2

-- Looking At Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as Case_Percentage
From PortfolioProject..CovidDeaths$
--where location like '%states'
order by 1,2

--Looking at countries with Highest Infection rate compared to population

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected 
From PortfolioProject..CovidDeaths$
Group by location, population
order by PercentPopulationInfected desc

--Showing countries with Highest Death Count Per Population

Select Location, Max(cast(total_deaths as int)) as HighestDeathsCount, Max((total_deaths/population))*100 as PercentPopulationDied 
From PortfolioProject..CovidDeaths$
where continent is not null
Group by location 
order by HighestDeathsCount desc

--Lets bring things by continent

-- Showing continents with highest death per population

Select continent, Max(cast(total_deaths as int)) as HighestDeathsCount, Max((total_deaths/population))*100 as PercentPopulationDied 
From PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by HighestDeathsCount desc


-- Global Numbers

Select date, Sum(new_cases) as totalcases, Sum(cast(new_deaths as int)) as totaldeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
Group by date
order by 1,2

Select Sum(new_cases) as totalcases, Sum(cast(new_deaths as int)) as totaldeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
--where continent is not null
--Group by 
order by 1,2

--Looking at total population vs total vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as AddupPeopleVacinated
--,(AddupPeopleVacinated/population)*100 as TotalPercenntile
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use CTE 


With PopvsVac(continent, location, date, population, new_vaccinations, AddupPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as AddupPeopleVacinated
--,(AddupPeopleVacinated/population)*100 as TotalPercenntile
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (AddupPeopleVaccinated/Population)*100
from PopvsVac



--Temp Table


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Population numeric,
Date datetime,
New_vaccinations numeric,
AddupPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as AddupPeopleVacinated
--,(AddupPeopleVacinated/population)*100 as TotalPercenntile
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (AddupPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating view to store data for visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as AddupPeopleVacinated
--,(AddupPeopleVacinated/population)*100 as TotalPercenntile
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
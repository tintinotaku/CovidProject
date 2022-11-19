
-- Percentage of Deaths in VN each day
select location, date, cast(total_cases as int) total_cases , cast(total_deaths as int) total_deaths, (total_deaths / total_cases)*100 as percentage_of_deaths from Covid_Deaths
where location like '%viet%' and (total_deaths / total_cases) is not null
group by location, date, total_cases, total_deaths
order by date 

-- Top 10 countries with highest infection
select top(10) location, MAX(total_cases) as highest_cases from Covid_Deaths
where continent is not null 
group by location
having MAX(total_cases) is not null
order by highest_cases desc

-- Top 10 countries with lowest infection
select top(10) location, MAX(cast(total_cases as int)) as lowest_cases from Covid_Deaths
group by location
having MAX(cast(total_cases as int)) is not null
order by lowest_cases 

-- Top 10 countries with highest percentage of deaths by COVID infection
select top(10) location, MAX(cast(total_deaths as float)) as max_total_deaths, MAX(cast(total_cases as float)) as max_total_cases, (MAX(cast(total_deaths as float))/MAX(cast(total_cases as float)))*100 as highest_percentage_of_deaths
from Covid_Deaths
group by location
having (MAX(cast(total_deaths as float))/MAX(cast(total_cases as float)))*100 is not null
order by highest_percentage_of_deaths desc

-- Total cases in each continent finally
select continent, MAX(cast(total_cases as float)) as total_death_count
from Covid_Deaths
where continent is not null
group by continent
order by total_death_count desc

-- Global cases number
select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_death, (SUM(cast(new_deaths as float))/SUM(cast(new_cases as float)))*100 as percentage_of_deaths
from Covid_Deaths
where continent is not null 

-- Ratio of vaccinations on population
select cd.continent, cd.location, cd.population, SUM(cast(cv.new_vaccinations as float)) as new_vaccinations, (SUM(cast(cv.new_vaccinations as float))/cd.population)*100 as percentage_of_having_vaccine
from Covid_Deaths cd join Covid_Vaccinations cv on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null 
group by cd.continent, cd.location, cd.population
order by 5 desc

-- Monitoring the situation of vaccination supplier on each contries
select cd.continent, cd.location, cd.date, coalesce(cv.new_vaccinations,0) as new_vaccinations, coalesce(SUM(convert(float, cv.new_vaccinations)) over (partition by cd.location order by cd.date, cd.location),0) as rolling_people_vaccinated
from Covid_Vaccinations cv join Covid_Deaths cd on cd.location = cv.location and cd.date = cv.date
order by 2,3 




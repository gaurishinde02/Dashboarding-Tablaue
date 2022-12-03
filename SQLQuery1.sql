Select * from covid_project..['covid-deaths$'];


--Death percentage for India

Select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercent 
from covid_project..['covid-deaths$']
where location like '%india%'


--Percentage of people who have gotten covid for India

Select continent, location, date, total_cases, population, (total_cases/population)*100 as infectedpercent
from covid_project..['covid-deaths$']
where location like '%india%'

--Which location has the most number of cases
Select location , MAX(total_cases) as highestcases , MAX(total_deaths) as highestdeaths
from covid_project..['covid-deaths$']
where continent is NOT NULL 
Group By location
order by highestcases desc

--Which continent has the most number of cases
Select continent , MAX(total_cases) as highestcases , MAX(total_deaths) as highestdeaths
from covid_project..['covid-deaths$']
where continent is NOT NULL 
Group By continent
order by highestcases desc

--Join the two tables
Select * 
From covid_project..['covid-deaths$'] dea
Join covid_project..['covid-vaccine$'] vac
on dea.location = vac.location
and dea.date = vac.date

--Using Partition to show the number of vaccination by location
Select dea.location, dea.continent, dea.date, dea.population, vac.total_vaccinations,
SUM(CONVERT(bigint, total_vaccinations)) OVER(PARTITION BY dea.location)
From covid_project..['covid-deaths$'] dea
Join covid_project..['covid-vaccine$'] vac
on dea.location = vac.location
and dea.date = vac.date

----Using Groupby to show the number of vaccination by location
Select dea.location, SUM(CONVERT(bigint,total_vaccinations))
From covid_project..['covid-deaths$'] dea
Join covid_project..['covid-vaccine$'] vac
on dea.location = vac.location
and dea.date = vac.date
GROUP BY dea.location

--Creating a view for visulizations

Create View PercentVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..['covid-deaths$'] dea
Join covid_project..['covid-vaccine$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 




select * from covid_deaths
order by 3,4;

select * from covid_vaccinations
order by 3,4;

select location,date,population,total_cases,new_cases,total_deaths
from covid_deaths 
order by 1,2;

--total_cases vs total deaths percentage

select location,date,total_cases,total_deaths,(total_deaths::float/total_cases)*100 as deathpercentage
from covid_deaths 
order by 1,2;

select location,date,population,total_cases,new_cases, 
sum(new_cases)over(partition by location order by date)as new_cases_running
from covid_deaths 
order by 1,2;

--total_cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as totalcasespercentage
from covid_deaths 
where continent is not null
order by 1,2;

--max total_cases in all countries

select location,max(total_cases) as maxtotalcases
from covid_deaths 
where continent is not null
group by location
order by 2 desc;

--looking at countries with highest infection rate compared to population

select location,max(total_cases) as highestinfectionrate
from covid_deaths 
where continent is not null
group by location
order by 1,2 desc;

select location,max(total_deaths) as highestdeathcount
from covid_deaths 
where continent is not null and total_deaths is not null
group by location
order by 2 desc;

--grouping by continent

select continent,max(total_deaths) as highestdeathcount
from covid_deaths 
--where continent is not null
group by continent
order by 2 desc;

select continent,max(total_cases) as highestdeathcount
from covid_deaths 
where continent is not null
group by continent
order by 2 desc;

select location,total_cases,date,new_cases,sum(new_cases)over(partition by location order by date )as total_cases
from covid_deaths
where continent is not null
--group by continent
;

--looking at covid_deaths and covid_vaccination

select *from covid_vaccinations;

select dc.*,vc.*
from covid_deaths dc 
join covid_vaccinations vc
on dc.location=vc.location and
   dc.date=vc.date
   order by 3,4;
   
   
select dc.location,dc.date,dc.population,vc.new_vaccinations,vc.total_vaccinations
--sum()
from covid_deaths dc
join covid_vaccinations vc
on dc.location=vc.location and
   dc.date=vc.date
   --where total_vaccinations is not null 
   --and dc.continent is not null
   order by 1,2;

select dc.location,dc.date,dc.population,vc.total_vaccinations,vc.new_vaccinations,
sum(vc.new_vaccinations)over(partition by dc.location order by dc.location,dc.date)as rollingpeoplevaccinated
from covid_deaths dc
join covid_vaccinations vc
on dc.location=vc.location and
   dc.date=vc.date
   where dc.continent is not null 
   
   order by 1,2;
   
  --use CTE
 
WITH covid_deaths_vaccinations(location,date,population,total_vaccinations,new_vaccinations,rollingpeoplevaccinated)
 AS
 (select dc.location,dc.date,dc.population,vc.total_vaccinations,vc.new_vaccinations,
sum(vc.new_vaccinations)over(partition by dc.location order by dc.location,dc.date)as rollingpeoplevaccinated
from covid_deaths dc
join covid_vaccinations vc
on dc.location=vc.location and
   dc.date=vc.date
   where dc.continent is not null 
)
   select *,
          (rollingpeoplevaccinated/population)*100 as vaccinationpercentage
 from covid_deaths_vaccinations;
  
 --creating view
 
create view coviddeathsvaccinations as
select dc.continent,dc.location,dc.date,dc.population,vc.total_vaccinations,vc.new_vaccinations,
sum(vc.new_vaccinations)over(partition by dc.location order by dc.location,dc.date)as rollingpeoplevaccinated
from covid_deaths dc
join covid_vaccinations vc
on dc.location=vc.location and
   dc.date=vc.date
   where dc.continent is not null;

select  * from coviddeathsvaccinations;
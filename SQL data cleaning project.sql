use data_practice;
select * from layoffs;
drop table prac;

-- 1.) REMOVE THE DUPLICATES
create table l2 like layoffs;

select * from l2;

alter table l2 
add row_num int;

insert into l2
select *,
row_number() over( partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
as row_num from layoffs;

select * from l2 
where row_num > 1;

delete from l2
where row_num > 1;

-- STANDARDIZE THE DATA
select company, trim(company) from l2;

update l2
set company= trim(company);

select distinct country from l2 order by 1;

select * 
from l2 
where industry like 'crypto%';

update l2
set industry = 'crypto'
where industry like 'crypto%';

select distinct country, 
trim(trailing '.' from country) 
from l2 
order by 1;

update l2
set country = trim(trailing '.' from country) 
where country like 'united states%';

select * from l2 
order by 1;

-- CHANGE DATE FORMAT
select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from l2;

UPDATE l2
Set `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

alter table l2
change `date` Date date;

-- POPULATE AND DELETE NULL VALUES
update l2
set total_laid_off= null
where total_laid_off= ' ';

update l2
set percentage_laid_off= null
where percentage_laid_off= ' ';

delete from l2 
where total_laid_off is null 
and percentage_laid_off is null;

update l2
set industry= null
where industry=' ';

update l2 t1
join l2 t2
 on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null)
and t2.industry is not null;

-- REMOVE UNNECESSARY COLUMNS
alter table l2
drop column row_num;

select * from l2;




-- Data Cleaning

create database world_layoffs;
show databases;
use world_layoffs;

select * 
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove irrelavant columns (but need to make a safty raw data first)

-- 0. making a save copy of original data
# Put the columns
create table layoffs_copy
like layoffs; 

# fill rows with values
insert into layoffs_copy
select * 
from layoffs;

select * 
from layoffs_copy;

-- 1. Remove Duplicates--------------------------------------------------------------------

-- row number will start a new row each unique instance so if you 2> then its a duplicate
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_copy;

-- CTE to check the duplicates BUT will give error because 
WITH duplicate_cte AS ( 
select *,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, 
country, funds_raised_millions) AS row_num
from layoffs_copy
)
select *
from duplicate_cte
where row_num > 1;

-- will need to make a new table with row number

CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_copy2;

-- the above only gives columns now need to insert the data

Insert into layoffs_copy2
Select *,
row_number() over(
partition by company, location, 
industry, total_laid_off, percentage_laid_off, 'date', stage, 
country, funds_raised_millions) AS row_num
from layoffs_copy;

-- reason we did the above is because we wanted to add a column to check the number of rown
-- the new column will allow to delete and 2nd (duplicate) row
-- the code below is to delete any 2nd row

select *
from layoffs_copy2
where row_num > 1;

Delete
from layoffs_copy2
where row_num > 1;

select *
from layoffs_copy2;

-- 2. Standardize the data-------------------------------------------------------------------

Update layoffs_copy2
set company = trim(company);

-- identifying which industry (checking if multiple names for same thing)
Select DISTINCT industry
from layoffs_copy2
order by 1;

Update layoffs_copy2
set industry = 'Crypto'
where industry like 'Crypto%';

-- removing any white spaces and (.,?..)
Select DISTINCT country, TRIM(TRAILING '.' FROM country)
from layoffs_copy2
order by 1;

Update layoffs_copy2
set industry = TRIM(TRAILING '.' FROM country)
where industry like 'United States%';

-- changing date column from string to date structure (y needs to be cap because 4 nums)
SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_copy2;

Update layoffs_copy2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- Now that it is in the proper structure will type cast to date
ALTER TABLE layoffs_copy2
MODIFY column `date` DATE;

-- 3. Null Values or Blank Values----------------------------------------------------------
select *
from layoffs_copy2
where industry is null 
or industry = '';

select *
from layoffs_copy2
where company = 'Airbnb';

-- the code below is catching all industry'' and check what industry they should be
select *
from layoffs_copy2 as t1
join layoffs_copy2 as t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- below is a simpler view
select t1.company,t1.industry, t2.industry
from layoffs_copy2 as t1
join layoffs_copy2 as t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- now to update and set all the blanks to what they should begin

# first set the blanks to nulls 
update layoffs_copy2
set industry = null
where industry ='';

# now change update is the from

Update layoffs_copy2 as t1
join layoffs_copy2 as t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- 4. Remove irrelavant columns (but need to make a safty raw data first)----------
select *
from layoffs_copy2
where total_laid_off is null 
and percentage_laid_off is null;

delete
from layoffs_copy2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_copy2
drop column row_num;


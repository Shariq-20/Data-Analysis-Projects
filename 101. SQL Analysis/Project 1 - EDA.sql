-- Exploratory data analysis

select *
from layoffs_copy2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_copy2;

select *
from layoffs_copy2
where percentage_laid_off >= 1;

select * 
from layoffs_copy2
where country = 'pakistan'
order by percentage_laid_off desc;

select company, sum(total_laid_off)
from layoffs_copy2
group by company
order by 2 desc; -- by first column

select `date`, sum(total_laid_off)
from layoffs_copy2
group by `date`
order by 1 desc;

select year(`date`), sum(total_laid_off)
from layoffs_copy2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_copy2
group by stage
order by 2 desc;

select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_copy2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc;

-- cte for rolling total checking total layoffs each month

with rolling_total as 
(
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_copy2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total 
from rolling_total;

-- cte checking total layoffs each month each company
with company_year (company, years, total_laid_off) as   -- can name using the brackets in cte
(
select company, year(`date`), sum(total_laid_off)
from layoffs_copy2
group by company, year(`date`)
order by 3 desc
)
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
order by ranking asc;



 
SELECT * from netflix;
SELECT count(*) as total_content from netflix;
SELECT DISTINCT type from netflix;
-- 15 Business Problem
-- 1. count the number of movies vs tv shows
SELECT type, count(*) as total_content
from netflix
GROUP by type
-- 2. find the most common rating for movies and tv shows
SELECT 
    type,
    rating_count,
    RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS ranking
FROM (
    SELECT 
        type, 
        COUNT(*) AS rating_count
    FROM 
        netflix
    GROUP BY 
        type
) AS sub;
--3 List all movies released in a specific year
SELECT * FROM netflix
WHERE 
    type = 'Movie'
    AND release_year = 2020;
-- 4. find the top 5 country with the most content on netflix.
SELECT 
  country,
  UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;

--4 Longest movie
SELECT * from netflix
WHERE
type='Movie'
AND
duration=(select Max(duration)from netflix)
--5 find all the movies/tv shows by director ''rajiv chilaka''
SELECT * from netflix
WHERE director='Rajiv Chilaka' 
SELECT * from netflix
WHERE director LIkE'%Rajiv Chilaka%' 

-- 6 list all tv shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;
-- 7 Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(show_id) as total_content
From netflix
GROUP BY 1

--8 Find each year the avg number of content release in india on netflix return top 5 year 
--with highest avg content release
SELECT
  EXTRACT(YEAR FROM
    CASE
      WHEN TRIM(date_added) ~ '^\d{2}-[A-Za-z]{3}-\d{2}$' THEN TO_DATE(TRIM(date_added), 'DD-Mon-YY')
      WHEN TRIM(date_added) ~ '^[A-Za-z]+ \d{1,2}, \d{4}$' THEN TO_DATE(TRIM(date_added), 'Month DD, YYYY')
      ELSE NULL
    END
  ) AS release_year,
  COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;
-- 9 List all movies that are documentaries
SELECT *from netflix
where listed_in ILIKE '%documentaries%'
--10 find all content without a director
SELECT *from netflix
WHERE director IS NULL
--11 find how many movies actor 'salman Khan' appeared in last 10 year!
SELECT *from netflix
WHERE casts ILIKE '%aKshay Kumar%'
AND release_year >EXTRACT (year from current_date)-10
-- 12 find the top 10 actors who have appeared in the highest no of movies produced in 
--india.
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
Count(*) as total_Content
from netflix
WHERE country ILIKE '%india%'
Group by 1
order by 2 DESC
Limit 10
--13 Categorize Use content besed on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as "Bad' and 
--all othe content as 'Good', Count how many stars fall into each category.
SELECT
  CASE
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad Content'
    ELSE 'Good Content'
  END AS category,
  COUNT(*) AS total_count
FROM netflix
GROUP BY 1;







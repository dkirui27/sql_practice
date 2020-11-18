--Question 1
--What percent of students attend school on their birthday?
SELECT 'Question 1 Answer: ' AS null, CONCAT(ROUND(ROUND(AVG(attendance),2)*100),'%') AS perc_atten
FROM all_students AS a
JOIN attendance_events AS e
USING(student_id)
WHERE CONCAT(date_part('month', date_of_birth), '-', date_part('day', date_of_birth)) = CONCAT(date_part('month', date), '-', date_part('day', date));


/* Question 2 */
-- Which grade level had the largest drop in attendance between yesterday and today?
--ALTER TABLE all_students
--ALTER COLUMN grade_level TYPE INTEGER USING(grade_level::integer)

WITH test AS (
  SELECT e.date, CONCAT(EXTRACT(month FROM date),'-', EXTRACT(day FROM date)) AS date_concat, grade_level,
  AVG(attendance) OVER(PARTITION BY date, grade_level) AS atten_avg
  FROM all_students AS a
  JOIN attendance_events AS e
  USING(student_id)
  ORDER BY date, grade_level
)

SELECT 'Question 1 Answer: ' AS null, date_concat, grade_level, atten_avg, COALESCE(CASE WHEN date_concat = '11-12' THEN NULL
ELSE LAG(atten_avg, 1) OVER() END, 0) AS previous_day, COALESCE(atten_avg - CASE WHEN date_concat = '11-12' THEN NULL
ELSE LAG(atten_avg, 1) OVER() END, 0) AS diff
FROM test
WHERE date_concat IN ('11-12','11-13')
GROUP BY date, date_concat, grade_level, atten_avg
ORDER BY grade_level, date;

--Answer: Tied between 10th and 12th grade (both had a 25% drop in attendance)

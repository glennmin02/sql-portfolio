-- To see how the length of stay (stay) impacts the average mental health diagnostic scores of the international students present in the study.
SELECT stay, COUNT(*) AS count_int, ROUND(AVG(todep),2) AS average_phq, ROUND(AVG(tosc),2) AS average_scs, ROUND(AVG(toas),2) AS average_as
FROM students
WHERE inter_dom = 'Inter'
GROUP BY stay
ORDER BY stay DESC
LIMIT 9;

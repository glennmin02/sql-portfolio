--Insert values into aircrafts
INSERT INTO "aircrafts" ("id", "name", "tail_number", "year", "category", "maintenance_due")
VALUES
('1','C170', 'N9379U', '2020','Single Engine','2028-01-31'),
('2','DA42', 'N502AF', '2012','Dual Engine','2029-05-24'),
('3','C170', 'NAF8GV', '2018','Single Engine','2026-12-16'),
('4','PA28', 'N20FJ9', '2019','Single Engine','2026-03-28'),
('5','PA28', 'N8OG0G', '2021','Single Engine','2026-04-30');

--Insert values into pilots
INSERT INTO "pilots" ("id", "name", "type", "license_number", "total_hours")
VALUES
(1, 'James Adler', 'PPL', 'PPL00123', 215),
(2, 'Sophia Lin', 'CPL', 'CPL00245', 740),
(3, 'Miguel Sanchez', 'ATPL', 'ATPL00987', 3600),
(4, 'Lena Cho', 'Ground', 'NONE', 0),
(5, 'Elijah Bennett', 'CFI', 'CFI00412', 1800);

--Insert values into certifications
INSERT INTO "certifications" ("id", "pilot_id", "name", "issue_date", "expiration_date", "status")
VALUES
(1, 1, 'Night Rating', '2021-06-15', '2026-06-15', 'Active'),
(2, 2, 'Instrument Rating', '2020-08-01', '2023-08-01', 'Expire'),
(3, 3, 'Type Rating: A320', '2019-01-10', '2024-01-10', 'Active'),
(4, 5, 'Flight Instructor Certificate', '2022-09-20', '2027-09-20', 'Active'),
(5, 1, 'Mountain Flying Endorsement', '2023-05-05', '2028-05-05', 'Active');

--Insert values into maintenances
INSERT INTO "maintenances" ("id", "aircraft_id", "date", "description", "signed_off")
VALUES
(1, 1, '2024-02-10', 'Oil change and tire inspection', 'A. Reynolds'),
(2, 2, '2023-11-22', '100-hour inspection completed', 'K. Wu'),
(3, 3, '2024-03-05', 'Avionics system update', 'M. Ferreira'),
(4, 1, '2023-12-01', 'Landing gear inspection and brake replacement', 'C. O’Brien'),
(5, 2, '2024-01-17', 'Fuel system flush and filter change', 'N. Patel');

--Insert values into flights
INSERT INTO "flights" ("id", "date", "pilot_id", "aircraft_id", "maintenance_id", "depr_icao", "arr_icao", "etd", "eta")
VALUES
(1, '2024-03-11', 1, 1, 1, 'KLAX', 'KSMO', '08:00', '08:45'),
(2, '2024-03-12', 2, 2, 2, 'KSAN', 'KLAS', '10:15', '11:40'),
(3, '2024-03-15', 3, 3, 3, 'KSEA', 'KSFO', '13:30', '15:30'),
(4, '2024-03-18', 5, 1, 4, 'KSMO', 'KMYF', '09:00', '10:20'),
(5, '2024-03-21', 1, 2, 2, 'KSNA', 'KLAX', '07:10', '07:50'),
(6, '2024-03-22', 2, 1, 1, 'KVNY', 'KAVX', '11:00', '11:45'),
(7, '2024-03-23', 5, 2, 5, 'KMYF', 'KSEE', '14:20', '14:55'),
(8, '2024-03-24', 3, 3, 3, 'KPDX', 'KBLI', '15:10', '16:30'),
(9, '2024-03-25', 1, 1, 4, 'KSBA', 'KSMO', '08:30', '09:25'),
(10, '2024-03-26', 2, 2, 5, 'KONT', 'KLAX', '06:00', '06:40'),
(11, '2025-04-02', 1, 1, 1, 'KLAX', 'KSAN', '07:00', '08:00'),
(12, '2025-03-28', 2, 2, 2, 'KSAN', 'KPHX', '09:15', '10:45'),
(13, '2025-01-15', 3, 3, 3, 'KSEA', 'KGEG', '12:00', '13:10'),
(14, '2024-12-05', 5, 1, 1, 'KMYF', 'KCRQ', '14:00', '14:30'),
(15, '2025-04-02', 1, 2, 5, 'KSBA', 'KSMO', '15:00', '15:45'),
(16, '2024-11-17', 2, 1, 4, 'KLAX', 'KONT', '16:30', '17:15'),
(17, '2025-02-22', 3, 2, 5, 'KAVX', 'KSNA', '17:45', '18:30'),
(18, '2025-04-01', 5, 3, 3, 'KSMO', 'KSBP', '19:00', '20:00'),
(19, '2025-03-01', 2, 3, 3, 'KSNA', 'KSEE', '20:30', '21:40'),
(20, '2025-04-02', 1, 1, 1, 'KCRQ', 'KLAX', '22:00', '23:00');

--Finding the flights by specific pilots
SELECT "flights"."id", "flights"."date", "aircrafts"."name" AS "aircraft",
       "flights"."depr_icao", "flights"."arr_icao", "flights"."etd", "flights"."eta"
FROM "flights"
JOIN "pilots" ON "flights"."pilot_id" = "pilots"."id"
JOIN "aircrafts" ON "flights"."aircraft_id" = "aircrafts"."id"
WHERE "pilots"."name" = 'James Adler'
ORDER BY "flights"."date" DESC;

--Listing expired certification
SELECT "pilots"."name", "certifications"."name" AS "cert_name", "certifications"."expiration_date"
FROM "certifications"
JOIN "pilots" ON "certifications"."pilot_id" = "pilots"."id"
WHERE "certifications"."status" = 'Expire';

--Finding total flight count by pilots
SELECT "pilots"."name", COUNT("flights"."id") AS "total_flights"
FROM "flights"
JOIN "pilots" ON "flights"."pilot_id" = "pilots"."id"
GROUP BY "pilots"."id"
ORDER BY "total_flights" DESC;

--Listing an aicraft before maintenance due date
--It will return with no results, as there is no input value.
SELECT "name", "tail_number", "maintenance_due"
FROM "aircrafts"
WHERE "maintenance_due" < '2025-05-01';

--Showing 5 most recent maintenance with aircraft
SELECT "maintenances"."date", "aircrafts"."name", "aircrafts"."tail_number",
       "maintenances"."description", "maintenances"."signed_off"
FROM "maintenances"
JOIN "aircrafts" ON "maintenances"."aircraft_id" = "aircrafts"."id"
ORDER BY "maintenances"."date" DESC
LIMIT 5;

--Finding pilots who flew more than specific times in specific year
--It will return with no results, as there is no input value.
SELECT "pilots"."name", COUNT("flights"."id") AS "flight_count"
FROM "flights"
JOIN "pilots" ON "flights"."pilot_id" = "pilots"."id"
WHERE "flights"."date" BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY "pilots"."id"
HAVING "flight_count" > 3;

--Listing an aicraft with no maintenance issues
SELECT "aircrafts"."name", "aircrafts"."tail_number"
FROM "aircrafts"
WHERE "aircrafts"."id" NOT IN (
    SELECT DISTINCT "aircraft_id"
    FROM "maintenances"
    WHERE "date" >= DATE('now', '-90 days')
);

--Listing full flight logs
SELECT "flights"."date", "pilots"."name" AS "pilot", "aircrafts"."name" AS "aircraft",
       "flights"."depr_icao", "flights"."arr_icao", "maintenances"."description" AS "recent_maintenance"
FROM "flights"
JOIN "pilots" ON "flights"."pilot_id" = "pilots"."id"
JOIN "aircrafts" ON "flights"."aircraft_id" = "aircrafts"."id"
JOIN "maintenances" ON "flights"."maintenance_id" = "maintenances"."id"
ORDER BY "flights"."date" DESC;

--Deleting specific flight by ID
DELETE FROM "flights"
WHERE "id" = 20;

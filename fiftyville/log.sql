-- Crime Scene Reports on Theft
SELECT *
FROM "crime_scene_reports"
WHERE year = '2024'
  AND month = '7'
  AND day = '28';


-- Interview Records
SELECT *
FROM "interviews"
WHERE transcript LIKE "%Bakery%";


-- Based on Witness 1, check the getaway car list with activity "exited" around July 28, 2024 10:15 AM.
SELECT *
FROM "bakery_security_logs"
WHERE activity = "exit"
  AND year = '2024'
  AND month = '7'
  AND day = '28'
  AND hour = '10';


-- Based on Witness 2, check the ATM records on that day
SELECT *
FROM "atm_transactions"
WHERE atm_location LIKE "%Leggett Street%"
  AND year = '2024'
  AND month = '7'
  AND day = '28'
  AND transaction_type = "withdraw";


-- Based on Witness 3, check the earliest flight on the flight list departed from CSF on July 29, 2024
SELECT *
FROM flights f
LEFT JOIN airports a ON a.id = f.origin_airport_id
WHERE a.abbreviation = 'CSF'
  AND f.year = '2024'
  AND f.month = '7'
  AND f.day = '29'
ORDER BY f.hour ASC;


-- Check the destination airport on two earliest flights
SELECT *
FROM airports
WHERE airports.id IN ('4', '1');


-- Narrow down the suspect list
SELECT
  p.id,
  p.name,
  p.phone_number,
  p.passport_number,
  p.license_plate
FROM people p
LEFT JOIN "bakery_security_logs" b ON p.license_plate = b.license_plate
WHERE b.activity = "exit"
  AND b.year = '2024'
  AND b.month = '7'
  AND b.day = '28'
  AND b.hour = '10';


-- Bank accounts that made those withdrawals
SELECT *
FROM bank_accounts
WHERE account_number IN (
  SELECT account_number
  FROM atm_transactions
  WHERE atm_location LIKE '%Leggett Street%'
    AND year = 2024
    AND month = 7
    AND day = 28
    AND transaction_type = 'withdraw'
);


-- Suspects who made withdrawals and found on license plate
SELECT *
FROM people
WHERE id IN (
  SELECT p.id
  FROM people p
  JOIN bakery_security_logs b ON p.license_plate = b.license_plate
  WHERE b.activity = 'exit'
    AND b.year = 2024
    AND b.month = 7
    AND b.day = 28
    AND b.hour = 10
)
AND id IN (
  SELECT ba.person_id
  FROM bank_accounts ba
  WHERE ba.account_number IN (
    SELECT a.account_number
    FROM atm_transactions a
    WHERE a.atm_location LIKE '%Leggett Street%'
      AND a.year = 2024
      AND a.month = 7
      AND a.day = 28
      AND a.transaction_type = 'withdraw'
  )
);


-- Searching the accomplice
SELECT *
FROM phone_calls
WHERE caller IN (
  SELECT people.phone_number
  FROM people
  WHERE id IN (
    SELECT p.id
    FROM people p
    JOIN bakery_security_logs b ON p.license_plate = b.license_plate
    WHERE b.activity = 'exit'
      AND b.year = 2024
      AND b.month = 7
      AND b.day = 28
      AND b.hour = 10
  )
  AND id IN (
    SELECT ba.person_id
    FROM bank_accounts ba
    WHERE ba.account_number IN (
      SELECT a.account_number
      FROM atm_transactions a
      WHERE a.atm_location LIKE '%Leggett Street%'
        AND a.year = 2024
        AND a.month = 7
        AND a.day = 28
        AND a.transaction_type = 'withdraw'
    )
  )
)
AND duration < 60;


-- Search on flight
SELECT *
FROM people
WHERE people.passport_number IN (
  SELECT passengers.passport_number
  FROM passengers
  WHERE flight_id IN (
    SELECT f.id
    FROM flights f
    LEFT JOIN airports a ON a.id = f.origin_airport_id
    WHERE a.abbreviation = 'CSF'
      AND f.year = '2024'
      AND f.month = '7'
      AND f.day = '29'
    ORDER BY f.hour ASC
  )
  AND passengers.passport_number IN (
    SELECT people.passport_number
    FROM people
    WHERE id IN (
      SELECT p.id
      FROM people p
      JOIN bakery_security_logs b ON p.license_plate = b.license_plate
      WHERE b.activity = 'exit'
        AND b.year = 2024
        AND b.month = 7
        AND b.day = 28
        AND b.hour = 10
    )
    AND id IN (
      SELECT ba.person_id
      FROM bank_accounts ba
      WHERE ba.account_number IN (
        SELECT a.account_number
        FROM atm_transactions a
        WHERE a.atm_location LIKE '%Leggett Street%'
          AND a.year = 2024
          AND a.month = 7
          AND a.day = 28
          AND a.transaction_type = 'withdraw'
      )
    )
  )
);


-- Finding the destination flight
SELECT airports.full_name
FROM airports
LEFT JOIN flights ON airports.id = flights.destination_airport_id
WHERE flights.id = '36';


-- Final 3 suspects
SELECT *
FROM people
WHERE people.passport_number IN (
  SELECT passengers.passport_number
  FROM passengers
  WHERE flight_id IN (
    SELECT f.id
    FROM flights f
    LEFT JOIN airports a ON a.id = f.origin_airport_id
    WHERE a.abbreviation = 'CSF'
      AND f.year = '2024'
      AND f.month = '7'
      AND f.day = '29'
    ORDER BY f.hour ASC
  )
  AND passengers.passport_number IN (
    SELECT people.passport_number
    FROM people
    WHERE id IN (
      SELECT p.id
      FROM people p
      JOIN bakery_security_logs b ON p.license_plate = b.license_plate
      WHERE b.activity = 'exit'
        AND b.year = 2024
        AND b.month = 7
        AND b.day = 28
        AND b.hour = 10
    )
    AND id IN (
      SELECT ba.person_id
      FROM bank_accounts ba
      WHERE ba.account_number IN (
        SELECT a.account_number
        FROM atm_transactions a
        WHERE a.atm_location LIKE '%Leggett Street%'
          AND a.year = 2024
          AND a.month = 7
          AND a.day = 28
          AND a.transaction_type = 'withdraw'
      )
    )
  )
)
AND people.phone_number IN (
  SELECT phone_calls.caller
  FROM phone_calls
  WHERE caller IN (
    SELECT people.phone_number
    FROM people
    WHERE id IN (
      SELECT p.id
      FROM people p
      JOIN bakery_security_logs b ON p.license_plate = b.license_plate
      WHERE b.activity = 'exit'
        AND b.year = 2024
        AND b.month = 7
        AND b.day = 28
        AND b.hour = 10
    )
    AND id IN (
      SELECT ba.person_id
      FROM bank_accounts ba
      WHERE ba.account_number IN (
        SELECT a.account_number
        FROM atm_transactions a
        WHERE a.atm_location LIKE '%Leggett Street%'
          AND a.year = 2024
          AND a.month = 7
          AND a.day = 28
          AND a.transaction_type = 'withdraw'
      )
    )
  )
  AND duration < 60
);


-- Finding the accomplice
SELECT *
FROM people
WHERE people.phone_number = '(375) 555-8161';

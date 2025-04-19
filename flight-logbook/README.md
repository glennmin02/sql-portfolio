## Scope

Coming from the Aviation background, thie simple database is based on finding and storing cadet pilots' flight training hours. The database will allow students to look up thier flight details, check maintenance records, learn aircraft information, and verfiy their personal certificates to keep updated.

The scope of the databse are:
1. Pilots - to search for cadet pilot's name, type, flight hours, and license numbers
2. Aircrafts - to identify aircraft's name, category, tail number, year, and maintenance due date
3. Certicates - to verify pilot's information with current and updated flight and medical certificates
4. Maintenace - to verify aircraft's maintenance records, look for any defects, and the person resposonbile for the maintenance
5. Flights - to look for overall aspect of flight information

However, this database does not invovle around:
- airlines and heavy scripting usage
- maintenance spare parts in detail linked with the aicraft
- call sign as it mostly does not requre for GA and Flight School aircraft. (All aircrafts here are assigned with thier US-registered tail number - N)

## Application Tools,
- SQLite3, PHP, VSCode

## Functional Requirements

From the user perspective, he/she should be able to:
- Search for cadet pilot information including their license number, type (e.g., PPL, CPL), and accumulated flight hours.
- Retrieve a pilot’s active and expired certifications with their issue/expiry dates and status.
- View the list of aircraft used in the flight school, along with their model, registration (tail) number, and upcoming maintenance due dates.
- Track aircraft maintenance history, including date, description, and personnel who signed off.
- Review historical and recent flight records by filtering date, pilot, aircraft, or origin/destination airports.
- Prevent flight creation for pilots with expired certifications (via trigger).
- See aggregated statistics like total flight hours by pilot or route popularity.

However, due to database limitation, the user will not be able to:
- Find real-time data integration (e.g., live GPS tracking or ATC data).
- Manage spare parts or component-level aircraft maintenance details.
- Access multi-user logins or role-based access control.
- Conduct commercial ops, such as passenger or cargo management in violation with FAA.

## Representation

With SQLite, I created the database first in the folder namely logbook.db. From there, I develoepd the schema and entities, just to keep things organized.

### Entities

5 Entities are developed namely - Pilots, Aicrafts, Maintenances, Certification, and Flights.

1. Pilots
| Attribute        | Type     |  Description                                   |
|------------------|----------|------------------------------------------------|
| `id`             | INTEGER  | Unique identifier (Primary Key)                |
| `name`           | TEXT     | Full name of the cadet pilot                   |
| `type`           | TEXT     | License type: Ground, PPL, CPL, ATPL, or CFI   |
| `license_number` | TEXT     | Official pilot license number (must be unique) |
| `total_hours`    | INTEGER  | Accumulated flight time in hours               |

2. Aircrafts
| Attribute         | Type     | Description                                         |
|-------------------|----------|-----------------------------------------------------|
| `id`              | INTEGER  | Unique aircraft ID (Primary Key)                    |
| `name`            | TEXT     | Aircraft make and model                             |
| `tail_number`     | TEXT     | FAA registration number (e.g., N123AB)              |
| `year`            | NUMERIC  | Year of manufacture                                 |
| `category`        | TEXT     | 'Single Engine' or 'Dual Engine'                    |
| `maintenance_due` | NUMERIC  | Date of next required inspection/maintenance        |

3. Maintenance
| Attribute     | Type     | Description                                          |
|---------------|----------|------------------------------------------------------|
| `id`          | INTEGER  | Unique maintenance ID (Primary Key)                  |
| `aircraft_id` | INTEGER  | FK to the aircraft maintained                        |
| `date`        | NUMERIC  | Date maintenance was performed                       |
| `description` | TEXT     | Summary of maintenance performed                     |
| `signed_off`  | TEXT     | Technician or inspector who approved the work        |

4. Certifications
| Attribute         | Type     | Description                                     |
|-------------------|----------|-------------------------------------------------|
| `id`              | INTEGER  | Unique certificate ID (Primary Key)             |
| `pilot_id`        | INTEGER  | FK to pilot who holds the certificate           |
| `name`            | TEXT     | Certification name (e.g., Night Rating)         |
| `issue_date`      | NUMERIC  | Date certificate was granted                    |
| `expiration_date` | NUMERIC  | Validity expiration date                        |
| `status`          | TEXT     | 'Active' or 'Expire'                            |

5. Flights
| Attribute        | Type     | Description                                   |
|------------------|----------|-----------------------------------------------|
| `id`             | INTEGER  | Unique flight ID (Primary Key)                |
| `date`           | NUMERIC  | Date of the flight                            |
| `pilot_id`       | INTEGER  | FK to the pilot who flew                      |
| `aircraft_id`    | INTEGER  | FK to the aircraft used                       |
| `maintenance_id` | INTEGER  | FK to the associated maintenance record       |
| `depr_icao`      | TEXT     | Departure airport ICAO code                   |
| `arr_icao`       | TEXT     | Arrival airport ICAO code                     |
| `etd`            | NUMERIC  | Estimated time of departure                   |
| `eta`            | NUMERIC  | Estimated time of arrival                     |

### Relationships

ERD Diagram is Attached.
I designed the .schema with center focus on Flights table; therefore enriching with Foreign Keys and One-to-Many, Many-to-One Relationshiips spread out.

## Optimizations

I have implemented the following optimization processes:
INDEX 1 - CREATE INDEX "date" ON "flights" ("date");
This index improves query performance when filtering or sorting flights by date — especially useful for daily logs, reports, or upcoming flights.

INDEX 2 - CREATE INDEX "index_pilots_license_number" ON "pilots" ("license_number");
This index supports fast lookup of pilot records based on their license number, which is often a unique identifier in flight schools.

VIEW 1- CREATE VIEW "today_flights";
This view simplifies access to only today’s flights without requiring users to manually enter the current date in their queries. It’s ideal for dashboards and mobile-ready outputs.

TRIGGER 1 - CREATE TRIGGER "update_certification_status";
This helps automatically update a certification's status to "Expire" upon insert if its expiration date has already passed. It removes the need for manual tracking or admin scripts to validate expiry.

## Limitations

First of all, the database is not verifed by FAA, so please take this with a pitch of salt. This is for simulation purposes only.
- Now, from the design perspective, the database does not calculate actual flight durations from departure and arrival times (etd, eta).
- The certifications logic is limited to status updates upon insert and does not support automatic status changes over time or renewal tracking.
- Additionally, maintenance data is stored at a general level without linking specific parts, serial numbers, or service types
- Airport information is stored using raw ICAO codes either manually or imported from ICAO website.
- The database does not contain any security features or access-restricted scripts.

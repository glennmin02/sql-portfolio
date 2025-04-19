--Table for Pilots
CREATE TABLE "pilots" (
    "id" INTEGER NO NULL,
    "name" TEXT NO NULL,
    "type" TEXT NOT NULL CHECK("type" IN ('Ground', 'PPL', 'CPL', 'ATPL', 'CFI')),
    "license_number" TEXT NO NULL,
    "total_hours" INTEGER NO NULL,
    PRIMARY KEY ("id")
    );

--Table for Certifications
CREATE TABLE "certifications" (
    "id" INTEGER NO NULL,
    "pilot_id" INTEGER NO NULL,
    "name" TEXT NO NULL,
    "issue_date" NUMERIC NOT NULL,
    "expiration_date" NUMERIC NOT NULL,
    "status" TEXT NOT NULL CHECK("status" IN ('Active', 'Expire')),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("pilot_id") REFERENCES "pilots"("id")
    );

--Table for Aircraft
CREATE TABLE "aircrafts" (
    "id" INTEGER NO NULL,
    "name" TEXT NO NULL,
    "tail_number" TEXT NO NULL,
    "year" NUMERIC NOT NULL,
    "category" TEXT NOT NULL CHECK("category" IN ('Single Engine', 'Dual Engine')),
    "maintenance_due" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
    );

--Table for Maintenance
CREATE TABLE "maintenances" (
    "id" INTEGER NO NULL,
    "aircraft_id" INTEGER NO NULL,
    "date" NUMERIC NO NULL,
    "description" TEXT NOT NULL,
    "signed_off" TEXT NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("aircraft_id") REFERENCES "aircrafts"("id")
    );

--Table for Flight
CREATE TABLE "flights" (
    "id" INTEGER NO NULL,
    "date" NUMERIC NO NULL,
    "pilot_id" INTEGER NO NULL,
    "aircraft_id" INTEGER NO NULL,
    "maintenance_id" INTEGER NO NULL,
    "depr_icao" TEXT NO NULL,
    "arr_icao" TEXT NO NULL,
    "etd" NUMERIC NO NULL,
    "eta" NUMERIC NO NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("pilot_id") REFERENCES "pilots"("id"),
    FOREIGN KEY ("aircraft_id") REFERENCES "aircrafts"("id"),
    FOREIGN KEY ("maintenance_id") REFERENCES "maintenances"("id")
    );

--To look out for Date on Flights
CREATE INDEX "date" ON "flights" ("date");

--To look out for License Number on Pilots
CREATE INDEX "index_pilots_license_number" ON "pilots" ("license_number");


--To look out for Today's Flights
CREATE VIEW "today_flights" AS
SELECT "id", "date", "pilot_id", "aircraft_id", "maintenance_id", "depr_icao", "arr_icao", "etd", "eta"
FROM "flights"
WHERE "date" = date('now');

--To update Certification
CREATE TRIGGER "update_certification_status"
AFTER INSERT ON "certifications"
BEGIN
  UPDATE "certifications"
  SET "status" = 'Expire'
  WHERE "id" = NEW."id" AND DATE(NEW."expiration_date") < DATE('now');
END;

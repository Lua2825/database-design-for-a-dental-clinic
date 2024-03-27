-- Doctors members of the staff.
CREATE TABLE "doctors" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "specialization" TEXT NOT NULL CHECK ("specialization" IN ('general dentist', 'pediatric dentist', 'orthodontist', 'periodontist', 'endodontist', 'oral pathologist', 'oral surgeon', 'prosthodontist')),
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC,
    PRIMARY KEY ("id")
);

-- Patients registered in the office records.
CREATE TABLE "patients" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "birth_date" NUMERIC NOT NULL,
    "registration_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);

-- Dental assistants members of the staff.
CREATE TABLE "assistants" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "birth_date" NUMERIC NOT NULL,
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC,
    PRIMARY KEY ("id")
);

-- List of treatments available for patients in the office.
CREATE TABLE "treatments" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "dental_specialty" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

-- Scheduled appointments.
CREATE TABLE "appointments" (
    "id" INTEGER,
    "date_appt_was_made" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "appointment_date" NUMERIC NOT NULL,
    "patient_id" INTEGER,
    "doctor_id" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("patient_id") REFERENCES "patients" ("id"),
    FOREIGN KEY ("doctor_id") REFERENCES "doctors" ("id")
);

-- Daily record of patients treated.
CREATE TABLE "daily_entries" (
    "id" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "patient_id" INTEGER,
    "doctor_id" INTEGER,
    "doc_assistant_id" INTEGER,
    "treatment_id" INTEGER,
    "referred_to" INTEGER,
    "emergency" TEXT NOT NULL CHECK ("emergency" IN ('yes', 'no')),
    "observation" TEXT,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("patient_id") REFERENCES "patients" ("id"),
    FOREIGN KEY ("doctor_id") REFERENCES "doctors" ("id"),
    FOREIGN KEY ("doc_assistant_id") REFERENCES "assistants" ("id"),
    FOREIGN KEY ("treatment_id") REFERENCES "treatments" ("id"),
    FOREIGN KEY ("referred_to") REFERENCES "doctors" ("id")
);


-- Indexes
CREATE INDEX "patient_name" ON "patients" ("first_name", "last_name");
CREATE INDEX "entry_patient_id" ON "daily_entries" ("patient_id");
CREATE INDEX "doctor_name" ON "doctors" ("first_name", "last_name");
CREATE INDEX "entry_doc_id" ON "daily_entries" ("doctor_id");


-- Detailed view of scheduled appointments
CREATE VIEW "appt_details" AS
SELECT
    "appointment_date",
    "doctors"."first_name" || " " || "doctors"."last_name" AS "doctor_name",
    "patients"."first_name" || " " || "patients"."last_name" AS "patient_name"
FROM "appointments"
JOIN "doctors"
  ON "appointments"."doctor_id" = "doctors"."id"
JOIN "patients"
  ON "patients"."id" = "appointments"."patient_id";

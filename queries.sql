
-- Adding values ​​to doctors table
INSERT INTO "doctors" ("first_name", "last_name", "specialization", "start_date", "end_date")
VALUES
('Alastor', 'Moody', 'general dentist', '2020-05-25', NULL),
('Lord',	'Voldemort', 'general dentist', '2020-04-09', '2022-01-01'),
('Severus', 'Snape',	'pediatric dentist', '2020-08-01', NULL),
('Abus',	'Dumbledore', 'orthodontist', '2021-09-25', NULL),
('Rubeus', 'Hagrid',	'periodontist',	'2021-03-24', NULL),
('Sirius', 'Black', 'endodontist', '2022-05-17',	'2023-05-25'),
('Minerva', 'McGonagall', 'oral pathologist', '2022-06-19', NULL),
('Newt',	'Scamander', 'oral surgeon', '2022-07-03', NULL),
('Lucius', 'Malfoy',	'prosthodontist', '2022-01-22', NULL);


-- Adding values ​​to patients table
INSERT INTO "patients" ("first_name", "last_name", "birth_date")
VALUES
('Dudley', 'Dursley', '1990-03-15'),
('Harry', 'Potter',	'1990-03-21'),
('Ron',	'Weasley', '1990-03-22'),
('Hermione', 'Granger',	'1990-03-23'),
('Luna', 'Lovegood', '1990-03-24'),
('Neville',	'Longbottom', '1990-03-25'),
('Cedric', 'Diggory', '1990-03-26'),
('Ginny', 'Weasley', '1990-03-27'),
('Fleur', 'Delacour', '1990-03-28'),
('Cho',	'Chang', '1990-03-29');


-- Adding values to assistants table
INSERT INTO "assistants" ("first_name",	"last_name", "birth_date", "start_date", "end_date")
VALUES
('Lily', 'Potter', '1995-05-10', '2020-10-01', '2022-09-18'),
('Bill', 'Weasley',	'1995-05-11', '2020-10-02', NULL),
('Fred', 'Weasley',	'1995-05-12', '2020-10-03', NULL);


-- Adding values to treatments table
INSERT INTO "treatments" ("name", "dental_specialty")
VALUES
('filling',	'general dentist'),
('fluoride varnish', 'pediatric dentist'),
('braces', 'orthodontist'),
('implant',	'periodontist'),
('root canal treatment', 'endodontist'),
('biopsy', 'oral pathologist'),
('corrective jaw surgery', 'oral surgeon'),
('crown', 'prosthodontist');

-- Adding values to daily_entries table
INSERT INTO "daily_entries" ("datetime", "patient_id", "doctor_id",	"doc_assistant_id",	"treatment_id",	"referred_to", "emergency")
VALUES
('2021-3-12', '1', '1',	'1', '1', '6', 'no'),
('2021-3-13', '2', '2',	'2', '2', '7', 'no'),
('2021-3-14', '3', '3',	'3', '3', '2', 'no'),
('2021-3-15', '4', '4', '1', '4', '5', 'no'),
('2021-3-16', '5', '5',	'2', '5', '2', 'no'),
('2021-3-17', '6', '6',	'3', '6', '3', 'no'),
('2021-3-18', '7', '7',	'1', '7', '4', 'yes'),
('2021-3-19', '8', '8',	'2', '8', '4', 'no'),
('2021-3-20', '9', '5',	'1', '7', '4', 'no');


-- Adding values to appointments table
INSERT INTO "appointments" ("date_appt_was_made", "appointment_date", "patient_id", "doctor_id")
VALUES
('2021-02-10', '2021-3-12', '1', '1'),
('2021-02-11', '2021-3-13',	'2', '2'),
('2021-02-12', '2021-3-14',	'3', '3'),
('2021-02-13', '2021-3-15',	'4', '4'),
('2021-02-14', '2021-3-16',	'5', '5'),
('2021-02-15', '2021-3-17',	'6', '6'),
('2021-02-16', '2021-3-18',	'7', '7'),
('2021-02-17', '2021-3-19',	'8', '8'),
('2021-02-18', '2021-3-20',	'9', '5');

-- Treatments a patient has received
SELECT
	daily_entries.datetime,
	doctors.first_name || " " || doctors.last_name AS doctor_name,
	assistants.first_name || " " || assistants.last_name AS assistant_name,
	treatments.name AS treatment,
	daily_entries.referred_to,
	daily_entries.emergency,
	daily_entries.observation
FROM doctors
JOIN daily_entries
  ON doctors.id = daily_entries.doctor_id
JOIN treatments
  ON treatments.id = daily_entries.treatment_id
JOIN assistants
  ON assistants.id = daily_entries.doc_assistant_id
WHERE patient_id = (
	SELECT id FROM patients
	WHERE first_name = 'Luna' AND last_name = 'Lovegood'
)
ORDER BY datetime DESC;



-- Patients that a doctor has treated
SELECT
	patients.first_name,
	patients.last_name,
	daily_entries.datetime,
	treatments.name AS treatment,
	daily_entries.referred_to,
	daily_entries.emergency,
	daily_entries.observation
FROM patients
JOIN daily_entries
  ON patients.id = daily_entries.patient_id
JOIN treatments
  ON treatments.id = daily_entries.treatment_id
WHERE doctor_id = (
	SELECT id FROM doctors
	WHERE first_name = 'Abus' AND last_name = 'Dumbledore'
)
ORDER BY datetime DESC;


-- Find the name of the doctor who treated a patient's emergency
SELECT
	datetime,
	doctors.first_name || " " || doctors.last_name AS doctor_name,
	assistants.first_name || " " || assistants.last_name AS assistant_name,
	treatments.name AS treatment,
	referred_to,
	observation
FROM doctors
JOIN daily_entries
  ON doctors.id = daily_entries.doctor_id
JOIN treatments
  ON treatments.id = daily_entries.treatment_id
JOIN assistants
  ON assistants.id = daily_entries.doc_assistant_id
WHERE emergency = 'yes' AND patient_id = (
	SELECT id FROM patients
	WHERE first_name = 'Cedric' AND last_name = 'Diggory'
);

-- Active: 1747441200865@@127.0.0.1@5432@postgres
-- Active: 1747441200865@@127.0.0.1@5432@postgres

CREATE TABLE rangers (
      ranger_id SERIAL PRIMARY KEY,
      ranger_name VARCHAR(50) NOT NULL,
      region VARCHAR(50)
);

CREATE  TABLE sightings (
      sighting_id SERIAL PRIMARY KEY,
      ranger_id INT NOT NULL,
      species_id INT NOT NULL,
      _location VARCHAR(50) NOT NULL,
      sighting_date TIMESTAMP NOT NULL,
      notes TEXT,
      FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
      FOREIGN KEY (species_id) REFERENCES species(species_id)
);

DROP TABLE sightings;

CREATE TABLE species (
      species_id SERIAL PRIMARY KEY,
      common_name VARCHAR(50) NOT NULL,
      scientific_name VARCHAR(50) NOT NULL,
      discovery_date DATE NOT NULL,
      conversation_status VARCHAR(50)
);

INSERT INTO rangers (ranger_name, region) VALUES
('John Carter', 'North Zone'),
('Sarah Kim', 'East Zone'),
('Ali Hassan', 'South Zone');

INSERT INTO species (common_name, scientific_name, discovery_date, conversation_status) VALUES
('African Elephant', 'Loxodonta africana', '1970-06-15', 'Vulnerable'),
('Bengal Tiger', 'Panthera tigris tigris', '1895-03-21', 'Endangered'),
('Red Fox', 'Vulpes vulpes', '1758-01-01', 'Least Concern');

INSERT INTO species (common_name, scientific_name, discovery_date, conversation_status) VALUES
('Jaguar', 'Panthera onca', '1758-01-01', 'Endangered'),
('Rhinoceros', 'Rhinoceros unicornis', '1758-01-01', 'Vulnerable');

INSERT INTO sightings (ranger_id, species_id, _location, sighting_date, notes) VALUES
(1, 1, 'Savannah Trail', '2025-05-24 07:45:00', 'Observed herd near waterhole'),
(2, 2, 'Jungle Edge', '2025-05-24 11:30:00', 'Tracks and growls heard'),
(3, 3, 'Forest Path', '2025-05-24 13:15:00', 'One fox seen near bushes');

INSERT INTO sightings (ranger_id, species_id, _location, sighting_date, notes) VALUES
(4, 3, 'Snowfall Pass', '2025-05-24 18:10:00', 'Large group seen in the woods');

SELECT * FROM rangers;
SELECT * FROM sightings;
SELECT * FROM species;

--Problem 01
INSERT INTO rangers (ranger_name, region) VALUES ('Derek Fox', 'Coastal Plains');

--Problem 02

SELECT COUNT(DISTINCT species_id) as unique_species_count FROM sightings;

--Problem 03
SELECT * FROM sightings
WHERE _location LIKE  '%Pass%';

--Problem 04
SELECT ranger_name as _name, COUNT(sightings.ranger_id) as total_sightings FROM rangers
INNER JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY ranger_name;

--Problem 05
SELECT sp.common_name as Common_Name FROM species sp
LEFT JOIN sightings si ON sp.species_id = si.species_id
WHERE si.sighting_id IS NULL;

--Problem 06
SELECT sp.common_name as Common_name, si.sighting_date as sighting_data, r.ranger_name as _Name FROM sightings si
INNER JOIN species sp ON si.species_id = sp.species_id
INNER JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY sighting_date DESC
LIMIT 2;

--Problem 07
UPDATE species
SET conversation_status  = 'Historic'
WHERE discovery_date > '1800-12-31';

--Problem 08
SELECT sighting_id,
       CASE
           WHEN extract(HOUR FROM sighting_date) < 12 THEN 'Morning'
           WHEN extract(HOUR FROM sighting_date) >=12 AND extract(HOUR FROM sighting_date) < 18 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings;

--Problem 09
DELETE FROM sightings s
WHERE NOT EXISTS (
      SELECT 1
      FROM rangers r
      WHERE r.ranger_id = s.ranger_id      
    );

CREATE TABLE parts (
    id integer,
    description character varying,
    code character varying,
    manufacturer_id  integer
);

CREATE TABLE locations (
    id integer,
    part_id integer,
    location varchar(3),
    qty integer
);

create table manufacturers (
    id integer PRIMARY KEY,
    name varchar
);

create table reorder_options (
  id integer PRIMARY KEY,
  part_id integer,
  price_usd numeric(8,2),
  quantity integer
);


/*Working with the Parts Table*/
--Adding constraints to the code column in the parts table
--Making the code column unique

ALTER TABLE parts
ADD UNIQUE (code);

--Making the code column not null
ALTER TABLE parts
ALTER COlUMN code SET NOT NULL;


--Next we set the column to the NOT NULL Constraint
ALTER TABLE parts
ALTER COLUMN description SET NOT NULL;


/*IMPROVING OUR REORDER_OPTIONS TABLE*/
--Adding constraints to the price_usd and quantity columns in the table, so they can't be null
ALTER TABLE reorder_options
ALTER COLUMN price_usd SET NOT NULL;

ALTER TABLE reorder_options
ALTER COLUMN quantity SET NOT NULL;

--Lastly adding a check to our price_usd and quantity columns, so they are greater than 0
ALTER TABLE reorder_options
ADD CHECK (
  price_USD > 0
  AND
  quantity > 0
);

--Our storeroom mainly tracks parts with a price per unit between 0.02USD and 25.00USD, so we will add a check to ensure our price per unit (price_usd/quantity) is always between those values
ALTER TABLE reorder_options
ADD CHECK (
  price_USD/quantity BETWEEN 0.02 AND 25.00
);

--adding a constraint to ensure that our reorder_options table shares a one to many relationship  with our Parts table because we only want to carry pricing information on parts that are already being tracked in our DB schema
ALTER TABLE parts
ADD PRIMARY KEY (id);

ALTER TABLE reorder_options
ADD FOREIGN KEY (part_id) REFERENCES parts(id) ON DELETE CASCADE;

/*Improving Location Tracking*/
--First let's set a constraint so all parts available in our store-room have a quantity greater than 0
ALTER TABLE locations
ADD CHECK (
  qty > 0
);

--Let's add a unique constraint for part_id and location, to ensure the data shows up in one row instead of multiple
ALTER TABLE locations
ADD UNIQUE (part_id, location);

--adding a constraint to ensure that our locations table shares a one to one relationship  with our locations table because we only want to carry location information on parts that are already being tracked in our DB schema
ALTER TABLE locations
ADD FOREIGN KEY (part_id) REFERENCES parts(id) ON DELETE CASCADE;

/*Improving Manufacturer Tracking*/
--Ensuring all parts have a valid manufacturer by creating a one to many relationship between the manufacturer table and the parts table
ALTER TABLE parts
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id);


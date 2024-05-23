-- DML - MySQL commands

-- db creation
drop database if exists db_skin_cancer;
create database db_skin_cancer;

-- use db
use db_skin_cancer;

-- list type_image
select * from type_image;

-- insert type_image
insert into type_image(description) values
	("dermoscopy"), 
    ("histopatology"),
    ("confocal microscopy"), 
    ("serial imaging");

-- list type_cancer
select * from type_cancer;

-- insert type_cancer
insert into type_cancer(description) values
	("nevus"),
    ("melanoma"),
    ("seborrheic keratosis"),
    ("basal cell carcinoma"),
    ("actinic keratosis"),
    ("squamous cell carcinoma"),
    ("pigmented benign keratosis");

-- list patient
select * from patient;

insert into patient(full_name, age, anatomy, sex, url_image, fk_id_type_image) values
	("vasily zaitzev", 58, "posterior", "M", "storage/ISIC_0000000.JPG" , 1),
	("yulia kovalatieva", 72, "upper extremity", "F", "storage/ISIC_9997614.JPG", 4);


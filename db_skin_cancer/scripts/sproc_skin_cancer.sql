-- Store procedures with db_skin_cancer

-- connect with db
use db_skin_cancer;

-- view patient
create view vw_patient as 
select p.id_patient, p.full_name, ti.description as type_image , p.anatomy,
		p.age, p.sex, p.class_pred, p.prob_pred
from patient p
inner join type_image ti on p.fk_id_type_image = ti.id_type_image
order by id_patient asc;

select * from vw_patient;

-- insert patient
delimiter $$
create procedure sp_patient_insert(
	in p_full_name varchar(200),
    in p_age int, 
    in p_anatomy varchar(45),
    in p_sex char(1),
    in p_url_image varchar(400),
    in p_id_type_image int
)
begin
	insert into patient(full_name, age, anatomy, sex, url_image, fk_id_type_image)
    values(p_full_name, p_age, p_anatomy, p_sex, p_url_image, p_id_type_image);
end $$
delimiter ;

call sp_patient_insert("Regina Miroslava", 60, "head", "F", "storage/ISIC_9998937.JPG" , 2);

select * from patient;

-- edit patient prediction
delimiter $$
create procedure sp_patient_predict(
	in p_id int, 
    in p_class_pred varchar(45),
    in p_prob_pred decimal(7, 5)
)
begin
	update patient p
		set p.class_pred = p_class_pred, p.prob_pred = p_prob_pred
    where p.id_patient = p_id;
end $$
delimiter ;

call sp_patient_predict(5, "melanoma", 95.34);

-- search 1 patient by id
delimiter $$
create procedure sp_patient_search_by_id(
	in p_id int
)
begin 
	select p.id_patient, p.class_pred, p.prob_pred, p.url_image 
    from patient p
    inner join type_image t
    on p.fk_id_type_image = t.id_type_image
    where p.id_patient = p_id;
end $$
delimiter ;

call sp_patient_search_by_id(7);

-- view type_cancer
create view vw_cancer as 
select t.id_cancer, t.description
from type_cancer t
order by t.id_cancer asc;

select * from vw_cancer;

-- view scores by selected patient
delimiter $$
create procedure sp_score_search_by_id(
	in p_id_patient int
)
begin
	select t.description, s.prob_score
    from scores s
    inner join type_cancer t
    on s.fk_id_cancer = t.id_cancer
    where s.fk_id_patient = p_id_patient;
end $$
delimiter ;

-- insert scores
delimiter $$
create procedure sp_score_insert(
	in p_id_cancer int, 
    in p_id_patient int,
    in p_prob_score decimal(7, 5)
)
begin 
	insert into scores(fk_id_cancer, fk_id_patient, prob_score)
    values(p_id_cancer, p_id_patient, p_prob_score);
end $$
delimiter ;

select * from patient;
select * from scores;

-- view model
create view vw_model as
select m.id_model, m.name, m.type
from model m
order by m.id_model;

select * from vw_model;

-- insert model
delimiter $$
create procedure sp_model_insert(
	in p_name varchar(80),
    in p_type varchar(45)
)
begin
	insert into model(name, type)
    values(p_name, p_type);
end $$
delimiter ;

-- view of experiments by id_model
delimiter $$
create procedure sp_experiment_by_model(
	in p_id_model int
)
begin
	select e.id_experiment, e.description, e.path_exp
    from experiment e
    where e.fk_id_model = p_id_model;
end $$
delimiter ;

-- insert experiment
delimiter $$
create procedure sp_experiment_insert(
	in p_description varchar(300),
    in p_path_exp varchar(500),
    in p_id_model int
)
begin
	insert into experiment(description, path_exp, fk_id_model)
    values(p_description, p_path_exp, p_id_model);
end $$
delimiter ;

select * from experiment;

select * from model;
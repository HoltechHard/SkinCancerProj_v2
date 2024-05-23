# models

from typing import List
from models.mysqldb import mysql_cnn

# class Type Image

class TypeImage:
    # constructor
    def __init__(self, p_id, p_description):
        self.id = p_id
        self.description = p_description

    # list type of images
    def list_type_img():
        mysql_cnn.connect()
        query = "select * from type_image"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for type_image
    def generate_type_img():
        data = []

        for row in TypeImage.list_type_img():
            data.append({
                "id": row[0],
                "description": row[1]
            })

        return data 


# class Type Cancer

class TypeCancer:
    # constructor
    def __init__(self, p_id, p_description):
        self.id = p_id 
        self.description = p_description

    # list type of cancer
    def list_type_cancer():
        mysql_cnn.connect()
        query = "select * from vw_cancer"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res 
    
    # generate JSON structure for type_cancer
    def generate_type_cancer():
        data = []

        for row in TypeCancer.list_type_cancer():
            data.append({
                "id": row[0],
                "description": row[1]
            })

        return data


# class Patient

class Patient:
    # constructor
    def __init__(self, p_id, p_full_name, p_age, p_anatomy, p_sex,
                 p_class_pred, p_prob_pred, p_url_image, p_type_image):
        self.id = p_id
        self.full_name = p_full_name
        self.age = p_age
        self.anatomy = p_anatomy
        self.sex = p_sex
        self.class_pred = p_class_pred
        self.prob_pred = p_prob_pred
        self.url_image = p_url_image
        self.type_image = p_type_image

    # list patient
    def list_patient():
        mysql_cnn.connect()
        query = "select * from vw_patient"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for patient
    def generate_patient():
        data = []
        for row in Patient.list_patient():
            data.append({
                "id": row[0],
                "full_name": row[1],
                "type_image": row[2],
                "anatomy": row[3],
                "age": row[4],
                "sex": row[5],
                "class_pred": row[6],
                "prob_pred": row[7]
            })

        return data

    # insert patient
    def insert_patient(self):
        mysql_cnn.connect()
        procedure = "sp_patient_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.full_name, self.age, self.anatomy, 
                                           self.sex, self.url_image, self.type_image)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table patient")
        elif res == 0:
            print("data not inserted")

    # recover last inserted patient
    def recover_patient_id():
        mysql_cnn.connect()
        query = "select max(id_patient) from patient"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res[0][0]
    
    # predict patient
    def save_patient_prediction(id, label_pred, prob_pred):
        mysql_cnn.connect()
        procedure = "sp_patient_predict"
        res = mysql_cnn.execute_sprocedure(procedure, id, label_pred, prob_pred)
        mysql_cnn.close()

        if res == 1:
            print("prediction was successfully saved!")
        elif res == 0:
            print("prediction not saved!")

    # search 1 patient
    def search_patient_by_id(id):
        mysql_cnn.connect()
        procedure = "sp_patient_search_by_id"
        res = mysql_cnn.execute_procedure_query(procedure, id)
        mysql_cnn.close()

        return res
    
    # generate JSON structure for searched patient
    def generate_searched_patient(id):
        data = []

        for row in Patient.search_patient_by_id(id):
            data.append({
                "id": row[0],
                "class_pred": row[1],
                "prob_pred": row[2],
                "url_image": row[3]
            })

        return data
    

# class Scores

class Scores:
    # constructor
    def __init__(self, p_cancer, p_patient, p_prob):
        self.id_cancer = p_cancer
        self.id_patient = p_patient
        self.prob = p_prob 
    
    # list scores by patient
    def list_scores_by_patient(id_patient):
        mysql_cnn.connect()
        procedure = "sp_score_search_by_id"
        res = mysql_cnn.execute_procedure_query(procedure, id_patient)
        mysql_cnn.close()

        return res

    # generate JSON structure for scores by patient
    def generate_scores(id_patient):
        data = []

        for row in Scores.list_scores_by_patient(id_patient):
            data.append({
                "class_cancer": row[0],
                "prob_score": row[1]
            })

        return data

    # insert score
    def insert_scores(self):
        mysql_cnn.connect()
        procedure = "sp_score_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.id_cancer, self.id_patient, self.prob)
        mysql_cnn.close()

        if res == 1:
            print("score inserted!")
        elif res == 0:
            print("data not inserted")


# class Model

class AiModel:
    # constructor
    def __init__(self, p_id, p_name, p_type):
        self.id = p_id
        self.name = p_name
        self.type = p_type        

    # list model
    def list_model():
        mysql_cnn.connect()
        query = "select * from vw_model"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for model
    def generate_model():
        data = []

        for row in AiModel.list_model():
            data.append({
                "id": row[0],
                "name": row[1],
                "type": row[2],
                "experiments": Experiment.generate_experiment_by_model(row[0])
            })
        
        return data
    
    # insert model
    def insert_model(self):
        mysql_cnn.connect()
        procedure = "sp_model_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.name, self.type)
        mysql_cnn.close()

        if res == 1:
            print("model was inserted!")
        elif res == 0:
            print("model was not inserted!")


# class experiment

class Experiment:
    # constructor
    def __init__(self, p_id, p_description, p_path, p_model):
        self.id = p_id
        self.description = p_description
        self.path = p_path
        self.model = p_model

    # list experiment by model
    def search_experiment_by_model(id_model):
        mysql_cnn.connect()
        procedure = "sp_experiment_by_model"
        res = mysql_cnn.execute_procedure_query(procedure, id_model)
        mysql_cnn.close()

        return res
    
    # generate JSON structure for experiments
    def generate_experiment_by_model(id_model):
        data = []

        for row in Experiment.search_experiment_by_model(id_model):
            data.append({
                "id": row[0],
                "description": row[1],
                "path": row[2]
            })

        return data
    
    # insert experiment
    def insert_experiment(self):
        mysql_cnn.connect()
        procedure = "sp_experiment_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.description, self.path, self.model)
        mysql_cnn.close()

        if res == 1:
            print("experiment was inserted!")
        elif res == 0:
            print("experiment was not inserted!")
        
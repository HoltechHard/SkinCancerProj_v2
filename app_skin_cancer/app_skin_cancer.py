from flask import Flask, render_template, request, jsonify
from models.model import Patient, TypeImage, Scores, AiModel, Experiment
from controllers.config import settings, get_time
from controllers.biomistral_controller import biomistral_engine
from controllers.rag_pdf_ingest import ingest_engine
from flask_socketio import SocketIO, send, emit

app = Flask(__name__)
socket = SocketIO(app)

@app.route('/')
@app.route('/index')
def index():
    return render_template("index.html")
    
@app.route('/about')
def about():
    return render_template("about.html")

# classification template
@app.route('/diagnosis/classification', methods=['GET', 'POST'])
def classification():
    data = None
    url_image = None

    # register patient
    if request.method == 'POST':
        # data from frmPatientData
        full_name = request.form.get("txtFullName")
        age = request.form.get("txtAge")
        anatomy = request.form.get("txtAnatomy")
        sex = request.form.get("gender")
        type_image = request.form.get("cboTypeImage")

        print(f"type image: {type_image}")

        # data from frmImageUpload
        if 'file' in request.files:
            file = request.files['file']
            if file.filename != '':                
                url_image = f"static/storage/{file.filename}"
                file.save(url_image)

        patient = Patient(None, full_name, age, anatomy, sex, None, None, url_image, type_image)
        patient.insert_patient()

        last_patient = Patient.recover_patient_id()
        print(f'id query: {last_patient}')

        # generate prediction
        from controllers.vit_controller import vit_inference
        class_pred, label_pred, probs = vit_inference.predict(patient.url_image)

        # save prediction
        Patient.save_patient_prediction(last_patient, label_pred, probs[int(class_pred)])

        # save scores
        for index, prob in enumerate(probs):
            score = Scores(index + 1, last_patient, prob)
            score.insert_scores()

        # collect all data to asynchronous jquery sending
        data = {
            "class_pred": int(class_pred),
            "label_pred": label_pred,
            "prob_pred": probs[int(class_pred)],
            "probs": probs,
            "classes": settings["class_names"]
        }

        return jsonify(data)
    
    # show content of web page and combo box data if is not register
    return render_template("diagnosis/classification.html", 
                            lst_type_imgs = TypeImage.generate_type_img(), data = data)

# reports template
@app.route('/reports/patient_reports', methods=['GET', 'POST'])
def reports():
    # collect and process id-patient data
    if request.method == "POST":
        # id patient data
        id_patient = request.form.get("id_patient")
        
        # recover the url of image
        url_image = Patient.generate_searched_patient(id_patient)[0]["url_image"]

        # get the prob scores
        lst_scores = []
        for i in range(7):
            lst_scores.append(Scores.generate_scores(id_patient)[i]["prob_score"])

        # collect all data to asynchronous jquery sending
        data = {
            "url_image": url_image,
            "type_cancer": settings["class_names"],
            "prob_scores": lst_scores
        }

        return jsonify(data)

    # show list of patients if not press button
    return render_template("reports/reports.html", 
                           lst_patients = Patient.generate_patient())

# function to process query from medichat
def process_query(query: str) -> str:
    # process the answer with LLM + RAG
    res = biomistral_engine.get_answer(query)
    print(res)
    request_date, request_time = get_time()

    # format the response
    response = {
        "answer": res["result"],
        "source_document": " ".join([str(source.page_content) for source in res["source_documents"]]),
        "reference": str(res["source_documents"][0].metadata["source"]).replace("ext_data\\", ""),
        "request_date": request_date,
        "request_time": request_time
    }

    return response

# function to send message to socket
def send_socket_message(message):
    socket.emit('response', message)

# chatbot template
@app.route('/assistant/medichat', methods = ['GET', 'POST'])
def medichat():
    init_date, init_time = get_time()
    data = {
        "init_date": init_date,
        "init_time": init_time
    }

    return render_template("assistant/medichat.html", data = data)

# user-question interaction managing by socket
@socket.on('user_question')
def user_question(data):
    # get user input from request
    query = data.get('message')
    # process the query using LLM
    result = process_query(query)
    # send chatbot answer to socket
    socket_msg = {'type': 'chatbot_answer', 'message': result}
    send_socket_message(socket_msg)

# user question template
@app.route('/assistant/user_question', methods = ['GET'])
def user_question():
    question_date, question_time = get_time()
    data = {
        "question_date": question_date,
        "question_time": question_time
    }
    
    return render_template("assistant/user_question.html", data = data)

# chatbot answer template
@app.route('/assistant/chatbot_answer', methods = ['GET'])
def chatbot_answer():
    return render_template("assistant/chatbot_answer.html")

# upload private files
@app.route('/assistant/private_data', methods = ['POST', 'GET'])
def private_data():
    if request.method == 'POST':
        files = request.files.getlist('file')
        for file in files:
            if file.filename != '':                
                url_pdf = f"ext_data/{file.filename}"
                file.save(url_pdf)

    return render_template("assistant/private_data.html")

# ingest private files
@app.route('/assistant/ingest', methods = ['POST'])
def ingest_private_data():
    # make the process of ingest
    try:
        ingest_engine.process_vector_db()
        data = {
            "message": "Ingest script executed successfully!",
            "progress": 100
        }
    except Exception as e:
        data = {
            "message": f"Error during ingestion: {str(e)}",
            "progress": 0
        }

    return render_template("assistant/private_data.html", data = data)

# insert and list experiments
@app.route('/reports/experiments', methods = ['POST', 'GET'])
def experiments():
    if request.method == 'POST':
        # get the type of formulary
        form_type = request.form.get("form_type")

        if form_type == 'model':
            # execute commands for model
            model_name = request.form.get("txtModelName")
            model_type = request.form.get("txtModelType")
            # save model
            model = AiModel(None, model_name, model_type)
            model.insert_model()
        elif form_type == 'experiment':
            # execute commands for experiment
            exp_description = request.form.get("txtExpDescription")
            exp_model = request.form.get("cboModel")

            if 'file' in request.files:
                file = request.files['file']
                if file.filename != '':
                    exp_path = f"static/storage/exp/{file.filename}"
                    file.save(exp_path)

            # save experiment
            experiment = Experiment(None, exp_description, exp_path, exp_model)
            experiment.insert_experiment()

    return render_template("reports/experiments.html", 
                           lst_models = AiModel.generate_model())


if __name__ == "__main__":
    socket.run(app, host = '0.0.0.0', debug = True)


import json
from datetime import datetime

# read and get the config file
def read_config():
    with open("controllers/config.json", "r") as file:
        data = json.load(file)
    return data

settings = read_config()
id2label = {id:label for id, label in enumerate(settings["class_names"])}
label2id = {label:id for id,label in id2label.items()}


# manage datetime format
def get_time():
    now = datetime.now()
    time_str = now.strftime("%Y-%m-%d %H:%M:%S.%f")
    time_obj = datetime.strptime(time_str, "%Y-%m-%d %H:%M:%S.%f")
    # get date and timer
    date_part = time_obj.strftime("%d/%m/%Y")
    time_part = time_obj.strftime("%H:%M")

    return date_part, time_part


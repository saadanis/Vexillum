import json

flag_file_name = "../Vexillum/flags.json"
with open(flag_file_name, 'r') as f:
    flags = json.load(f)

def write_to_file():
    with open('flags.json', 'w') as json_file:
        json.dump(flags, json_file)

def add_empty_additional_details():
    for flag in flags:
        flag['visible'] = True
        flag['un_membership'] = ""
        flag['designer'] = ""
        flag['design_info'] = ""
        flag['note'] = ""

add_empty_additional_details()
write_to_file()
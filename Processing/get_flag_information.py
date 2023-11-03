import json

flag_file_name = "../Vexillum/flags.json"
with open(flag_file_name, 'r') as f:
    flags = json.load(f)

def get_size_from_aspect_ratio(aspect_ratio):
    componenents = aspect_ratio.split(":")
    return float(componenents[0])/float(componenents[1])

def get_aspect_ratios():
    aspect_ratios = []
    for flag in flags:
        if flag['aspect_ratio'] not in aspect_ratios:
            aspect_ratios.append(flag['aspect_ratio'])
    
    aspect_ratios = sorted(aspect_ratios, key=lambda x: get_size_from_aspect_ratio(x), reverse=True)

    return aspect_ratios

# print(get_aspect_ratios())
import json
import math
import sys
import numpy as np
from PIL import Image
from appwrite.services.functions import Functions
from model.document import Document, Documents
from utils.colors_allowed import colors_allowed


np.set_printoptions(threshold=sys.maxsize) # For test

def parse_hex_color(string):
    if string.startswith("#"):
        string = string[1:]
    r = int(string[0:2], 16) # red color value
    g = int(string[2:4], 16) # green color value
    b = int(string[4:6], 16) # blue color value
    return r, g, b, 255

def color_similarity(base_col_val,oth_col_val):
    """Calculate distance btw two color
    Less distance value show more similarity between the color’s."""
    return math.sqrt(sum((base_col_val[i]-oth_col_val[i])**2 for i in range(3)))

class SpriteProcessing():

    def __init__(self, path: str, client) -> None:
        """Init sprite and colors allowd"""        
        self.im = Image.open(path)
        self._rgb_colors_allowd = [parse_hex_color(color) for color in colors_allowed]
        self.function = Functions(client)
        self.process()        
    
    @property
    def rgb_colors_allowd(self):
        return self._rgb_colors_allowd
    
    @property
    def documents(self):
        return self._documents
    
    @documents.setter
    def documents(self, value):
        self._documents = value['documents']
    
    def out_path(self, name: str, format: str = 'png') -> str:
        return f"./out/{name}.{format}"
        
    def pixel_it(self):
        """Create pixel art"""        
        for i in self.documents:  
            if i['upload'] == True:          
                result = self.function.create_execution(function_id="626f4b574d01a906d255",data=json.dumps(i))
                print(result)
            else:
                print("BLANK")

    def process(self):        
        arr = np.array(self.im)
        index = 0
        size = self.im.size
        new_list = []
        data = []
        for e,i in enumerate(arr):
            for f,j in enumerate(i):        
                # Get color allowed 
                _x = f
                _y = e
                x_y = f"{e}_{f}"                
                _similarity_values = [color_similarity(j, x) for x in self.rgb_colors_allowd]
                _min_value = min(_similarity_values)
                hex = '#{:02x}{:02x}{:02x}'.format(*self.rgb_colors_allowd[_similarity_values.index(_min_value)])                
                
                if j[-1] != 0:                    
                    new_list.append(self.rgb_colors_allowd[_similarity_values.index(_min_value)])
                    data.append({
                        'x': _x+24,
                        'y': _y,
                        'hex': hex,
                        'upload': True
                    })
                else:
                    new_list.append((255,255,255,255))
                    data.append({
                        'x': _x,
                        'y': _y,
                        'hex': hex,
                        'upload': False
                    })

                # print(f"{index} - {x_y}: {hex}")
                index+=1        

                
        
        # Demostration
        # Create new image with colors allowed        
        a = np.reshape(new_list, (size[0], size[1], 4))        
        new_image = Image.fromarray((a * 1).astype(np.uint8)).convert('RGBA')        
        new_image.save(self.out_path("out"))
        # new_image.show()

        data = {'documents': data}
        schema = Documents()        
        self.documents = schema.load(data)

        # Pixel it!
        self.pixel_it()
        
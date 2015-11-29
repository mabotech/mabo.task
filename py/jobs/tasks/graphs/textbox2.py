# -*- coding: utf-8 -*-

from PIL import Image, ImageDraw,ImageFont

def main(val):  

    color = "blue" 
    position = [40,20]
   
    fn = 'background.png'    

    ## 
    newimg = Image.open(fn) 
    
    if newimg.mode != "RGBA":

        newimg = newimg.convert("RGBA")
 
    
    fontsize = 120
    
    ft = ImageFont.truetype('arial.ttf',fontsize)
 
    textdraw = ImageDraw.Draw(newimg)
 
    

    textdraw.text(position, val, font=ft, fill=color)
 
    out = "120.png"
    newimg.save(out) #815060

if __name__ == '__main__':
    
    val = "98.7"
    
    main(val)
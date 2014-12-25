# -*- coding: utf-8 -*-

from PIL import Image, ImageDraw, ImageChops, ImageEnhance, ImageFont

import time
from time import strftime, localtime

import hashlib


#import aggdraw

#--------------------------------

#批量处理照片的函数

#--------------------------------

#将照片变成圆角边

def RoundCorner(image, radius):

    """

    Generate the rounded corner image for orgimage.

    """

    image = image.convert('RGBA')

    #generate the mask image

    mask = Image.new('RGBA', image.size, (0,0,0,0))

    draw = aggdraw.Draw(mask)

    brush = aggdraw.Brush('black')    

    width, height = mask.size

    draw.rectangle((0, 0, mask.size[0], mask.size[1]), aggdraw.Brush('white'))

    #north-west corner

    draw.pieslice((0,0,radius*2,radius*2), 90, 180, None, brush)

    #north-east corner

    draw.pieslice((width-radius*2, 0, width, radius*2), 0, 90, None, brush)

    #south-west corner

    draw.pieslice((0, height-radius*2, radius*2, height), 180, 270, None, brush)

    #south-east corner

    draw.pieslice((width-radius*2, height-radius*2, width, height), 270, 360, None, brush)

    #center rectangle

    draw.rectangle((radius, radius, width-radius, height-radius), brush)

    #four edge rectangle

    draw.rectangle((radius, 0, width-radius, radius), brush)

    draw.rectangle((0, radius, radius, height-radius), brush)

    draw.rectangle((radius, height-radius, width-radius, height), brush)

    draw.rectangle((width-radius, radius, width, height-radius), brush)

    draw.flush()

    del draw    

    return ImageChops.add(mask, image)
    
#加圆角线条边框

def RoundCornerFrame(image, radius, line_width, line_color, opacity=1.0):

    width, height = image.size    

    draw = aggdraw.Draw(image)

    pen = aggdraw.Pen(line_color, line_width, int(255 * opacity))
    

    #注意: aggdraw对角度的解释与PIL有区别！

    #aggdraw画线的位置是线的中线，因此，需要减除半条线宽

    halfwidth = int(line_width / 2)

    #north-west corner 

    draw.arc((halfwidth, halfwidth, radius*2-halfwidth, radius*2-halfwidth), 90, 180, pen)

    #north-east corner

    draw.arc((width-radius*2+halfwidth, halfwidth, width-halfwidth, radius*2-halfwidth), 0, 90, pen)

    #south-west corner

    draw.arc((halfwidth, height-radius*2+halfwidth, radius*2-halfwidth, height-halfwidth), 180, 270, pen)

    #south-east corner

    draw.arc((width-radius*2+halfwidth, height-radius*2+halfwidth, width-halfwidth, height-halfwidth), 270, 360, pen)    

    #four edge line

    draw.line((halfwidth, radius, halfwidth, height-radius), pen)

    draw.line((radius, halfwidth, width-radius, halfwidth), pen)

    draw.line((width-halfwidth, radius, width-halfwidth, height-radius), pen)

    draw.line((radius, height-halfwidth, width-radius, height-halfwidth), pen)    

    draw.flush()

    del draw    

    return image

def reduce_opacity(im, opacity):

    """Returns an image with reduced opacity."""

    assert opacity >= 0 and opacity <= 1

    if im.mode != 'RGBA':

        im = im.convert('RGBA')

    else:

        im = im.copy()

    alpha = im.split()[3]

    alpha = ImageEnhance.Brightness(alpha).enhance(opacity)

    im.putalpha(alpha)

    return im

#为照片加水印

def Watermark(image, markimage, position, opacity=1):

    """Adds a watermark to an image."""

    im = image

    mark = markimage

    if opacity < 1:

        mark = reduce_opacity(mark, opacity)

    if im.mode != 'RGBA':

        im = im.convert('RGBA')

    # create a transparent layer the size of the image and draw the

    # watermark in that layer.

    layer = Image.new('RGBA', im.size, (0,0,0,0))

    if position == 'tile':

        for y in range(0, im.size[1], mark.size[1]):

            for x in range(0, im.size[0], mark.size[0]):

                layer.paste(mark, (x, y))

    elif position == 'scale':

        # scale, but preserve the aspect ratio

        ratio = min(

            float(im.size[0]) / mark.size[0], float(im.size[1]) / mark.size[1])

        w = int(mark.size[0] * ratio)

        h = int(mark.size[1] * ratio)

        mark = mark.resize((w, h))

        layer.paste(mark, ((im.size[0] - w) / 2, (im.size[1] - h) / 2))

    else:

        layer.paste(mark, position)

    # composite the watermark with the layer

    return Image.composite(layer, im, layer)


#为照片增加文字

def Signature(image, type, text, position, font=None, color=(255, 0, 0)):

    """

    imprints a PIL image with the indicated text in lower-right corner

    """
    
    if type not in ["c","v"]:
        raise
        
    if image.mode != "RGBA":

        image = image.convert("RGBA")

    textdraw = ImageDraw.Draw(image)
    
    j = 1
    lst = text.split('\n')
    lst.reverse()
    z = 0
    newlst = []
    maxline = ''
    max = 0
    for line in lst:
        #print len(line)
        if len(line)> 25:
            
            l1 = line[0:25]
            maxline = l1
            max = 25
            l2 = line[25:]
            newlst.append(l2)
            newlst.append(l1)
        else:
            newlst.append(line)
            if len(line) >max:
                max = len(line)
                maxline = line
        z = z +1
        
    #print maxline.encode('utf8')
    textsize = textdraw.textsize(maxline, font=font)
    #print("textsize:",(textsize))
    for line in newlst:
        #textpos = [image.size[i]-j*textsize[i]-position[i] for i in [0,1]]
        textpos = [0,0]
        for i in [0,1]:
            if i == 1:
                textpos[i] = image.size[i] - j*textsize[i]-position[i]
            else:
                textpos[i] = image.size[i]-textsize[i]-position[i]
                #print "%s- %s - %s" % ( image.size[i], textsize[i], position[i])
        #print "POS:", textpos
        textdraw.text(textpos, line, font=font, fill=color)
        j = j + 1

    del textdraw

    return image


def gen_image(title, conf):    
   
    fn = 'Christmas2015.png'    

    newimg = Image.open(fn) 
    
    #ft = ImageFont.truetype('simsun.ttc', 20)
    #ft = ImageFont.truetype('segoeprb.ttf',29)
    
    ft = ImageFont.truetype('jokerman.ttf',32)
    
    fts = ImageFont.truetype('VLADIMIR.TTF',30)
    
    #ft = ImageFont.truetype('xujinglei.fon',38)
    #ft = ImageFont.truetype('maozedong.ttf',40)
    #ft = ImageFont.truetype('jx.ttf',40)
    #ft = ImageFont.truetype('minijian.ttf',30)
    #ft = ImageFont.truetype('lianliantiw2.otf',30)
    #ft = ImageFont.truetype('FZHCJW.TTF',38)
    #print (ft.getname())
    #print (dir(ft))
    
    #ft = ImageFont.truetype('hycaolufan.ttf',24)
    
    #x = ft.getsize()  #'font', 'getmask', 'getmask2', 'getmetrics', 'getname', 'getsize']
    #print x
    
    #now = strftime('%y年%m月%d日 %H:%M',localtime())
    #now =unicode(now,'utf8')
    
    text = conf["image"]["title"].decode('utf-8') %(title)
    
    textdraw = ImageDraw.Draw(newimg)
    textsize = textdraw.textsize(text, font=ft)
    del textdraw
    
    #print textsize
    r = 510 - textsize[0]
    #print "R:", r
    newimg = Signature(newimg, "v", text, [r,200], ft, (255,255,255)) #560
    newimg = Signature(newimg, "c", conf["image"]["body"].decode('utf-8'), [120,100], ft, (255,255,255)) #560
    newimg = Signature(newimg, "c", conf["image"]["signature"].decode('utf-8'), [40,42], fts, (255,255,255)) #560
    newimg = Signature(newimg, "c", conf["image"]["date"].decode('utf-8'), [37,12], fts, (255,255,255)) #560
    #(image, radius, line_width, line_color, opacity=1.0)
    
    #newimg = RoundCorner(newimg, 15)
    
    #newimg = RoundCornerFrame(newimg, 15, 1,(0,0,0))
    
    #newimg.save('img11.png')
    
    m = hashlib.md5()
    
    z= text.encode('utf8')
    
    m.update(z)
    
    t = m.hexdigest()
    #.digest()
    out = "out\\mmf_%s.png" %(t)
    newimg.save(out) #815060
    return out


if __name__ == '__main__':
    
    import toml
    
    conf_fn = "conf_en.toml"
    
    with open(conf_fn) as conf_fh:
        
        conf = toml.loads(conf_fh.read())
        
    print gen_image(u"Happy", conf)
    #print gen_image(u"王总", conf)
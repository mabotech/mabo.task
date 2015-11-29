import matplotlib.patches as mpatch
import matplotlib.pyplot as plt

styles = mpatch.BoxStyle.get_styles()

figheight = (len(styles)+.5)

fig1 = plt.figure(1, (30,30))

fontsize = 3 * 72

#for i, (stylename, styleclass) in enumerate(styles.items()):
    
#    print i, stylename, styleclass
    
fig1.text(0.5, (float(len(styles)) - 0.5 - 0)/figheight, "12",
          ha="center",
          size=fontsize,
          transform=fig1.transFigure,
          bbox=dict(boxstyle="square", fc="w", ec="k"))
plt.draw()
plt.show()
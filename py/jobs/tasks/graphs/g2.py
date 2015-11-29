import matplotlib.pyplot as plt



plt.text(0.5, 0.4, "test", size=50, rotation=0,
         ha="right", va="top",
         bbox = dict(boxstyle="square",
                     ec=(1., 0.5, 0.5),
                     fc=(1., 0.8, 0.8),
                     )
         )


plt.draw()
plt.show()
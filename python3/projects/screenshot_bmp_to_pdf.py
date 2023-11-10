import os
import img2pdf
import glob



with open("screenshots.pdf","wb") as f:
    f.write(img2pdf.convert(glob.glob("C:/Users/tftbe1/Pictures/Screenshots/*.bmp")))
from PIL import Image
import sys
import os

path = sys.argv[1]
prefix = os.path.splitext(path)[0]

#print prefix
Image.open(path).convert('LA').save(prefix+ "-grey.png")
#!/usr/bin/env python

import sys
from nltk.tokenize import wordpunct_tokenize
from collections import Counter

cat = open('cats_txt.txt','r',encoding='utf-8')
cats = cat.read().replace("\n"," ")
cat.close()

cats = cats.lower()
token = wordpunct_tokenize(cats)
cats_file =Counter(token)
print(cats_file)
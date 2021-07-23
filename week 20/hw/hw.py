#!/usr/bin/env python

import sys
import nltk
from nltk import tokenize
from collections import Counter
from nltk.tokenize import wordpunct_tokenize

cats_file = open('cats_txt.txt','r')
cats = cats_file.read().replace("\n"," ")
cats_file.close()  

lower_cat = cats.lower()

    
#print(cats)
tokens = wordpunct_tokenize(cats)

#lower_tokens = [t.lower() for t in tokens]


 
bow_counter = Counter(tokens)

#sorted_bow = sorted(bow_counter, key=lambda w:w[1], reverse=True)

print(bow_counter.most_common())




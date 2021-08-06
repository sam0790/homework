#!/usr/bin/env python

import sys
import nltk
from nltk import tokenize
from collections import Counter
from nltk.tokenize import wordpunct_tokenize

cats_file = open('./cats_txt.txt','r',encoding='utf-8')
cats = cats_file.read().replace("\n"," ")
cats_file.close()  

#with cats_file as cats_file:
#        for line in cats_file:
#                lower_case=line.lower()
                #split lines into words
#                words=lower_case.split()


#cats_lower = cats_file.lower()

    
#print(cats)
tokens = wordpunct_tokenize(cats)

lower_tokens = [t.lower() for t in tokens]


 
bow_counter = Counter(lower_tokens)

#sorted_bow = sorted(bow_counter, key=lambda w:w[1], reverse=True)

print(bow_counter.most_common())

#cats_file.close()
#print('hello')


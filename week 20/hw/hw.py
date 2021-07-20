#!/usr/bin/env python

import sys
from nltk import tokenize
from collections import Counter
import nltk

#stdin = standard input
for line in sys.stdin:
    
    #strip white spaces at beginning and end of line
    lines = line.strip()

    #split each line into words
    #words = line.split()
cats = nltk.corpus.open('cats_txt.txt','r')
    
#for line in cats:
    

tokens = tokenize.word_tokenize(cats)

lower_tokens = [t.lower() for t in tokens]


 
bow_counter = Counter(lower_tokens)

#sorted_bow = sorted(bow_counter, key=lambda w:w[1], reverse=True)

print(bow_counter)




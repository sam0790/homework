#!/usr/bin/env python
#shebang line 

import sys

current_word = None
current_word = 0
word = None

#lines getting passed in from the mapper
for line in sys.stdin:
    line = line.strip()
    
    word, count = line.split("\t",1)

    #make sure count is an int, so we can add
    try:
        count = int(count)
    except:
        print("an error occured")
        continue

    #sorted values are passed in 
    if current_word == word:
        current_count += count
        #current_count += 1
    else:
        #if there is a current word (its not none)
        if current_word:
            print(current_word + "\t " + str(current_count))

        current_count = count
        current_word = word

if current_word == word:
    print(current_word + "\t" + str(current_count))


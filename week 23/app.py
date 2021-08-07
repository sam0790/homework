#!/usr/bin/env python

from flask import Flask, render_template, request
from flask_pymongo import PyMongo
from pymongo.uri_parser import parse_host

app = Flask(__name__)

#setup mongo connection
app.config["MONGO_URI"] = "mongodb://localhost:27017/shows_db"
mongo = PyMongo(app)

#connect to collection
tv_shows = mongo.db.tv_shows

#READ
@app.route("/")
def index():
    #find all items in db and save to variable
    all_shows = list(tv_shows.find())
    print(all_shows)

    return render_template("index.html",data=all_shows)


#INSERT
@app.route("/insert", methods=['POST','GET'])
def insert_show():
    #form = '<form name="insert" action="#" method="post">
    #What is the show name? <input type="text" name="show_name">
    #Number of Seasons:  <input type="text" name="seasons">
    #How long is each show?  <input type="text" name="duration">
    #What year did the show start? <input type="text" name="year">
    #<input type="submit" value="Submit">
    #</form>' 
    #show_name = input('What is the show name? ')
    #seasons = input('Number of Seasons: ')
    #duration = input('How long is each show? ')
    #year = input('What year did the show start? ')

    if request.method == 'POST':

        data = request.form

        post_data = {'name':data['name'],
             'seasons':data['seasons'],
             'duration':data['duration'],
             'year':data['year'],
             #'date_added':datetime.datetime.utcnow()
            }
        tv_shows.insert_one(post_data)
        return render_template("index.html", data=post_data)

    else:
        return render_template('insert.html')


#DELETE
@app.route("/delete", methods=['POST','GET'])
def del_show():

    if request.method == 'POST':

        data = request.form

        tv_shows.delete_one({'name':data['name']})

        return render_template("index.html")

    else:

        #show_name = ''<form action="#" method='post'><p>What tv show would you like to delete : </p><input type="text" name="show_name"/><input type='submit' value='submit'/>''

        

        return render_template('delete.html')



if __name__ == "__main__":
    app.run(debug=True) 

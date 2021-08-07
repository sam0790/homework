from flask import Flask, render_template
from flask_pymongo import PyMongo

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

@app.route("/insert")
def insert():

    show_name = input('What is the show name? ')
    seasons = input('Number of Seasons: ')
    duration = input('How long is each show? ')
    year = input('What year did the show start? ')


    post_data = { 'name': show_name,
                'seasons': seasons,
                'duration': duration,
                'year': year,
                'date_added':datetime.datetime.utcnow()
                }

    tv_shows.insert_one(post_data)

    return render_template('index.html',data=post_data)


#Update
@app.route("/update")
def update():
    show_name = request.form['name']
    seasons = request.form['season']
    duration = request.form['duration']
    year = request.form['year']

    post_data = { 'name': show_name,
                'seasons': seasons,
                'duration': duration,
                'year': year,
                'date_added':datetime.datetime.utcnow()
                }

    tv_shows.update_one(post_data)

    return render_template('index.html',data=post_data)

#delete
@app.route('/delete')
def del():
    show_name = input('What is the show name? ')
    tv_shows.delete_one(show_name)




if __name__ == "__main__":
    app.run(debug=True)
#!/usr/bin/env python

#import necessary libraries
# pip install flask 
#export FLASK_APP=flask-app
#flask run
from flask import Flask, json, render_template, request, redirect, url_for
import os

from werkzeug.utils import redirect

#create instance of Flask app
app = Flask(__name__)

#decorator 


@app.route("/all")
def all():
    json_url = os.path.join(app.static_folder,"","nobel1.json")
    data_json = json.load(open(json_url))
    #render_template is always looking in templates folder
    return render_template('index.html',data=data_json)

@app.route("/<year>", methods=['GET'])
def year_get(year):
    json_url = os.path.join(app.static_folder,"","nobel1.json")
    data_json = json.load(open(json_url))
    data = data_json['prizes']
    year = request.view_args['year']

    #request.method == 'GET':
    output_data = [x for x in data if x['year']==year]

    return render_template('index.html',data=output_data)


@app.route("/<year>P",methods=['GET','POST'])
def year_post(year):
    #render_template('form.html')
    if request.method == 'POST':
    #req_data=request.get_json()
        year = request.form["year"]
        category = request.form["category"]
        my_id = request.form["id"]
        firstname = request.form["firstname"]
        surname = request.form["surname"]
        motivation = request.form["motivation"]
        
        nobel_year = {'year':year,
                    'category':category,
                      'laureates':[{'id':id,
                                   'firstname':firstname,
                                    'surname':surname,
                                    'motivation':motivation
    
                                    }]  
                       }

        with open('./static/nobel.json', 'r+') as file:
            file_data=json.load(file)
            file_data['prizes'].append(nobel_year)
            file.seek(0)
            json.dump(file_data, file, indent=4)
        
        return redirect(url_for("nobel_year", year=year))


    else:
        
        return render_template("form.html")
    
        #with open(filename, "w") as file:
        #    json.dump(data, file)
        
   # year = request.form['year']
   # category = request.form['category']
   # id = request.form['id']
   # firstname = request.form['firstname']
   # surname = request.form['surname']
   # motivation = request.form['motivation']
   # share = request.form['share']
   # nobel_year = {'year':year,
   #                 'category':category,
    #                  'laureates':[{'id':id,
    #                               'firstname':firstname,
    #                                'surname':surname,
    #                                'motivation':motivation,
    
    #                                'share':share}]  
     #                   }

    #with open('nobel.json','r+') as nobel:
    #    nobel_data = json.load(nobel)
    #    nobel_data['prizes'].append(nobel_year)
    #    file.seek(0)
    #   json.dump(nobel_data, nobel, indent=4)

   # return render_template('form.html')
    #return redirect(url_for('year',year=year))

    #elif request.method == 'GET':
    #    output_data = [x for x in data if x['year']==year]

    #    return render_template('index.html',data=output_data)

        #new_data = {'year':year,'category':category}   
        #json_url = os.path.join(app.static_folder,"","nobel.json")
        #data_json = json.load(open(json_url))
        #data = data_json[1]
        #year = request.view_args['year']
        #output_data = [x for x in data if x['date']==year]
        #render_template is always looking in templates folder
        #return render_template('index.html',data=output_data)


    #return '''<form action="#"  method='POST'>
    #    Year <input type="text" name="year">
    #    Category <input type="text" name="category">
    #    <input type="submit" value="value">
    #    </form>'''

    
if __name__ == "__main__":
    app.run(debug=True)

#student details

import os
import sqlite3
from flask import Flask,request,g,redirect,url_for,render_template,flash,session
from functools import wraps


app = Flask(__name__)
app.config.from_object(__name__)

app.config.update(dict(
   DATABASE=os.path.join(app.root_path,'stu.db'),
   DEBUG=True,
   SECRET_KEY='jibin jose',
   USERNAME='admin',
   PASSWORD='default'
))
app.config.from_envvar('FLASKR_SETTINGS',silent=True)



def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash(' You need to login first.')
            return redirect(url_for('login'))
    return wrap


def connect_db():
  rv=sqlite3.connect(app.config['DATABASE'])
  rv.row_factory=sqlite3.Row
  return rv

def init_db():
  with app.app_context():
     db=get_db()
     with app.open_resource('schema.sql',mode='r')as f:
	db.cursor().executescript(f.read())
     db.commit()


def get_db():
  if not hasattr(g,'sqlite_db'):
     g.sqlite_db=connect_db()
  return g.sqlite_db



@app.route('/add',methods=['GET','POST'])
@login_required
def add():
  if request.method=='POST':
    if request.form['add']=="add":
      print "in add"
      print request
      print request.form['name'],request.form['mark']
      db=get_db()
      db.execute('insert into student(name,mark) values(?,?)',[request.form['name'],request.form['mark']])
      db.commit()
      flash(' Details added')
  return render_template('add.html')

@app.route('/view',methods=['GET','POST'])
def view():
      
     db = get_db()
     cur = db.execute('select name,mark from student')
     entries = cur.fetchall()
     return render_template('view.html', entries=entries)

     
   
	  
	   
@app.route('/search',methods=['GET','POST'])
def search():
	
	if request.method=='POST':
		if request.form['search']=="SEARCH":
		  db=get_db()
		  cur=db.execute('select * from student where name = ? ', (request.form['s_name'],) )
		  entries=cur.fetchall()
		  return render_template('view.html', entries=entries)
	return render_template('search.html')


@app.route('/delete',methods=['GET','POST'])
@login_required
def delete():
    if request.method=='POST':
        if request.form['delete']=="delete":
            print "haaaaaaaaaaai"
            print request.form['d_name']
            db=get_db()
            cur=db.execute('delete from student where name = ? ', (request.form['d_name'],) )		
            db.commit()
            flash('Sucessfully Deleted')
    return render_template('delete.html')

@app.route('/',methods=['GET','POST'])
def home():
  if request.method=='POST':
    if request.form['opt']=="LOGIN":
		  return redirect(url_for('login'))
    if request.form['opt']=="LOGOUT":
      return redirect(url_for('logout'))
  return render_template('home.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = "username"
        elif request.form['password'] != app.config['PASSWORD']:
            error = "password"
        else:
            session['logged_in'] = True
            flash('You were logged in')
            return redirect(url_for('home'))
    return render_template('login.html', error=error)

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash(' You were logged out')
    return redirect(url_for('home'))

@app.teardown_appcontext
def close_db(error):
  if hasattr(g,'sqlite_db'):
     g.sqlite_db.close()



if __name__=='__main__':
 app.run(debug=True)

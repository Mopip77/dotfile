#!/usr/local/env python3

import json
import sys
import getpass
from datetime import datetime
from pprint import pprint

path_to_todos = "/Users/" + getpass.getuser() + "/.todos.json"
line_spacing  = "10px"
color_id      = "#0099FF"
color_due     = "#f0d847"
color_subject = "#f2f3fa"
color_project = "#9dd6d8"
color_context = "#c8c2df"

def formatDate ( date ):
	return datetime.strptime(str(date), '%Y-%m-%d').strftime('%a, %b %d')

def printLineStart ():
	return "<div style=\"padding-top: "+line_spacing+";\">"

def printLineEnd ():
	return "</div>"

def printID ( id ):
	out = "<div style=\"display: inline; color: "+color_id+";\">"
	#format id to have a unified look
	if( id/10 < 1 ):
		out += "0"+str(id)+"&nbsp;&nbsp;</div>"
	elif( id/10 < 10 ):
		out += str(id)+"&nbsp;&nbsp;</div>"
	else:
		out += "</div>"
	return out

def printDue ( due ):
	if( str(i['due']) != "" ):
		out = "<div style=\"display: inline; color: "+color_due+";"
		if( datetime.strptime(i['due'], '%Y-%m-%d') < datetime.now() ):
			out += "font-weight: bold;"
		out += "\">"+formatDate(i['due'])+"&nbsp;&nbsp;</div>"
	else:
		out = "<div style=\"display: inline;\"></div>"
	return out

def printSubject ( subject, projects, contexts, completed ):
	#out = subject
	#check for projects
	for i in projects:
		subject = subject.replace("+"+i, "<div style=\"display: inline; color: "+color_project+";\">"+"+"+i+"</div>")
	#check for contexts
	for j in contexts:
		subject = subject.replace("@"+j, "<div style=\"display: inline; color: "+color_context+";\">"+"@"+j+"</div>")
	out = "<div style=\"display: inline; color: "+color_subject+"; "
	if(completed):
		out += "text-decoration: line-through;"
	out += "\">"+subject+"</div>"
	return out

with open( path_to_todos, "r", encoding="utf-8" ) as file:
	data = json.load(file)

out = "<div>"

for i in data:
	if ( not(i['archived']) ):
		out += printLineStart() + printID( i['id'] ) + printDue( i['due'] ) + printSubject( i['subject'], i['projects'], i['contexts'],  i['completed']  ) + printLineEnd()
out += "</div>"

sys.stdout.buffer.write( out.encode("utf8") )
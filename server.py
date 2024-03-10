from flask import Flask, render_template, Response

from database import Database

app = Flask(__name__)

database = Database()
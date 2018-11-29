from flask import Flask


app = Flask(__name__)

app.add_url_rule('/', view_func=lambda: 'hello world!', methods=['GET'])
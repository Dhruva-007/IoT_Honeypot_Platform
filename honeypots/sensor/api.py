from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route("/sensor")
def sensor():
    return jsonify({
        "temperature": round(random.uniform(25, 40), 2),
        "humidity": round(random.uniform(30, 60), 2),
        "status": "OK"
    })

app.run(host="0.0.0.0", port=5001)

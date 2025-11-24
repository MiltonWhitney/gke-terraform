from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

@app.route("/info")
def info():
    return jsonify({
        "app": "gke-flask-api",
        "version": "1.0",
        "environment": os.getenv("ENV", "development")
    })

@app.route("/echo/<msg>")
def echo(msg):
    return jsonify({"you_said": msg})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

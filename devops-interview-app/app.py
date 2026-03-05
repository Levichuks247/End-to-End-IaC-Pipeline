from flask import Flask, jsonify

app = Flask(__name__)

questions = [
    {"id": 1, "question": "What is the difference between a Container and a VM?", "answer": "Containers share the host OS kernel, VMs have a full guest OS."},
    {"id": 2, "question": "What is GitOps?", "answer": "Using Git as the single source of truth for infrastructure and applications."},
    {"id": 3, "question": "Explain Blue-Green Deployment.", "answer": "Two identical environments; one is live (blue), one is idle (green) for testing new releases."}
]

@app.route("/")
def home():
    return "<h1>DevOps Interview Prep API</h1><p>Status: Online</p>"

@app.route("/questions", methods=["GET"])
def get_questions():
    return jsonify({"status": "success", "data": questions})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

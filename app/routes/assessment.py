from flask import Blueprint, request, jsonify
from app.ai.orchestrator import Orchestrator

assessment_bp = Blueprint("assessment", __name__)
orch = Orchestrator()


@assessment_bp.route("/start", methods=["POST"])
def start_assessment():
    data = request.get_json() or {}
    test_type = data.get("test_type", "stress")

    first_question = orch.get_first_question(test_type)

    return jsonify({
        "question": first_question
    })


@assessment_bp.route("/answer", methods=["POST"])
def answer_question():
    data = request.get_json() or {}

    test_type = data.get("test_type", "stress")
    current_id = data.get("current_question_id")
    answer = data.get("answer")

    if not current_id or not answer:
        return jsonify({"error": "current_question_id and answer required"}), 400

    next_question = orch.get_next_question(
        test_type,
        current_id,
        answer
    )

    return jsonify({
        "next": next_question
    })

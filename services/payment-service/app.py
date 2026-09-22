from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({"status": "ok", "service": "payment-service"})

@app.route('/api/payments', methods=['POST'])
def process_payment():
    data = request.json or {}
    return jsonify({
        "status": "success",
        "transactionId": "txn_123456",
        "amount": data.get("amount", 0)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({"status": "ok", "service": "product-service"})

@app.route('/api/products')
def get_products():
    return jsonify([
        {"id": 1, "name": "Laptop", "price": 999.99},
        {"id": 2, "name": "Smartphone", "price": 499.99}
    ])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

#!/bin/bash
echo "Running smoke tests..."
curl -f http://localhost:80/api/users || exit 1
curl -f http://localhost:80/api/products || exit 1
curl -f http://localhost:80/api/orders || exit 1
# skip payment post
echo "Smoke tests passed."

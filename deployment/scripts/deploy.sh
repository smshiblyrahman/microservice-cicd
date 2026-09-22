#!/bin/bash
echo "Deploying Green environment..."
helm upgrade --install ecommerce-green helm/ecommerce --set global.tag=$1
echo "Running smoke tests..."
bash tests/smoke_test.sh
if [ $? -eq 0 ]; then
  echo "Smoke tests passed. Switching traffic to Green."
  # In a real environment, update Ingress to point to green service
else
  echo "Smoke tests failed. Triggering rollback."
  bash deployment/scripts/rollback.sh
fi

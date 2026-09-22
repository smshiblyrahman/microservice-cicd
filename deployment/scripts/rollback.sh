#!/bin/bash
echo "Rolling back to previous stable release (Blue)..."
helm rollback ecommerce-green 0
echo "Rollback initiated. Alerting team via Slack..."
# curl -X POST -H 'Content-type: application/json' --data '{"text":"Rollback initiated for ecommerce-green"}' $SLACK_WEBHOOK_URL

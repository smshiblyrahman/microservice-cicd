# Rollback Runbook

## Overview
Rollback is a standard operation to revert a problematic deployment to a known good state.

## Triggers
- Smoke test failure post-deployment.
- Error rate spike (>5% 5xx errors).
- Latency regression.
- CrashLoopBackOff in pods.
- Critical security incident.

## Procedure

1. **Detect Issue:** Alert received via Azure Monitor or Slack.
2. **Verify State:** Check pod logs.
3. **Execute Rollback:**
   Run the rollback script locally or via CI/CD pipeline:
   ```bash
   bash deployment/scripts/rollback.sh
   ```
4. **Health Check:** Verify service health via `curl http://<gateway>/health`.
5. **Notify:** Update the team in the #deployments Slack channel.
6. **RCA:** Create an incident ticket to investigate why the new version failed.

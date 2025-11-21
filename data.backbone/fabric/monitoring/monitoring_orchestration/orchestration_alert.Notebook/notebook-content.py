# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

# Replace with the activator parameters

pipeline_name = ""
pipeline_run_id = ""
workspace_name = ""
job_start_time = "" 
job_end_time = ""
job_status = "Failed"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import json
import requests

# RECOMMENDED: move this to a Key Vault / Fabric connection
TEAMS_WEBHOOK_URL = "https://manuchar.webhook.office.com/webhookb2/acfb120c-ba5e-47b2-9b68-ae8ad8057fcc@1da4383b-8064-4d80-ad26-7ee24a0ac477/IncomingWebhook/755c86d58d064fd1baa1568634054771/9649d664-b107-4cc0-bd95-baff161fb1a3/V2kMxrdMN64V5Zi8UK-c9JCJz4cgJuQVVKFyHlzPe8Yls1"

payload = {
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "summary": "DBB Orchestration Alert",
    "themeColor": "FF0000",  # red border
    "title": "🚨 DBB Orchestration Alert",  # plain title bar
    "sections": [
        {
            "activityTitle": f"⚠️ **{pipeline_name}** Failed in **{workspace_name}**",
            "markdown": True,
            "facts": [
                {"name": "• Pipeline Name:", "value": pipeline_name},
                {"name": "• Pipeline Run ID:", "value": pipeline_run_id},
                {"name": "• Workspace Name:", "value": workspace_name},
                {"name": "• Start (UTC):", "value": job_start_time},
                {"name": "• End (UTC):", "value": job_end_time},
                {"name": "• Status:",  "value": job_status},
            ],
        }
    ],
    
    # Optional: add a button that deep-links to the failed run
    # ⚠️ To do this, the workspace_id and pipeline_id are missing (not able to pass more than 5 parameters from the Activator to this notebook) ⚠️
    
    #  "potentialAction": [
    #      {
    #          "@type": "OpenUri",
    #          "name": "🔍 View Run Details",
    #          "targets": [{"os": "default", "uri": f"https://app.powerbi.com/workloads/data-pipeline/artifactAuthor/workspaces/{workspace_id}/pipelines/{pipeline_id}/{pipeline_run_id}"}]
    #      }
    # ]
}

response = requests.post(
    TEAMS_WEBHOOK_URL,
    headers={"Content-Type": "application/json"},
    data=json.dumps(payload),
    timeout=15,
)

if response.status_code == 200:
    print("✅ Teams notification sent.")
else:
    print(f"❌ Failed to send Teams notification: {response.status_code} - {response.text}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

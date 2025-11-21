# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "26d71613-5ee6-4522-a720-0f4dfa85c17b",
# META       "default_lakehouse_name": "OSS_Dynamics_MHQ_Lakehouse",
# META       "default_lakehouse_workspace_id": "5c450b57-bfb8-4fc6-b34c-e6fe494e12c1",
# META       "known_lakehouses": [
# META         {
# META           "id": "26d71613-5ee6-4522-a720-0f4dfa85c17b"
# META         }
# META       ]
# META     },
# META     "warehouse": {
# META       "default_warehouse": "6d51c555-fae7-a886-4e4e-f16a55458af9",
# META       "known_warehouses": [
# META         {
# META           "id": "6d51c555-fae7-a886-4e4e-f16a55458af9",
# META           "type": "Datawarehouse"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

import msal
import requests
import json
import datetime
import pandas as pd
from datetime import datetime, date, timedelta
import com.microsoft.spark.fabric
from com.microsoft.spark.fabric.Constants import Constants

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Format warehousename.schemaname.tablename
group_table_name = "OSS_GenericData_MHQ_Warehouse.REF_Entra.MS_Entra_Groups"

# Format warehousename.schemaname.tablename
group_members_table_name = "OSS_GenericData_MHQ_Warehouse.REF_Entra.MS_Entra_GroupMembers"

#########################################################################################
# Read secretes from Azure Key Vault
#########################################################################################
## This is the name of my Azure Key Vault
key_vault = "https://be-kv-fab-dbb-nonprd.vault.azure.net/"

tenant_id = mssparkutils.credentials.getSecret(key_vault, "FAB-TENANT-ID")
## This is  application Id for  service principal account
client_id = mssparkutils.credentials.getSecret(key_vault, "FAB-GRAPH-CLIENT-ID")
## This is my Client Secret for my service principal account
client_secret = mssparkutils.credentials.getSecret(key_vault, "FAB-GRAPH-SECRET")


authority_url = f"https://login.microsoftonline.com/{tenant_id}"
graph_api_url = "https://graph.microsoft.com/v1.0"

# Create MSAL client application
app = msal.ConfidentialClientApplication(
    client_id, authority=authority_url, client_credential=client_secret
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# Function to get an access token
def get_access_token():
    token_response = app.acquire_token_for_client(scopes=["https://graph.microsoft.com/.default"])
    return token_response.get("access_token")


# Getting all Groups and Members with Pagination
# NOTE: This can take over 30 mins to get all the information.

access_token = get_access_token()

def get_paginated_results(url, headers):
    results = []
    while url:        
        response = requests.get(url, headers=headers)
        data = response.json()        
        results.extend(data.get('value', []))
        url = data.get('@odata.nextLink')       
    return results

def get_user(url, headers):            
    response = requests.get(url, headers=headers)
    results = response.json()                 
    return results


def main():
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    allgroups = []
    groupFilters = ["GLO_P_PA","GLO_Q_PA","GLO_A_PA","GLO_T_PA","GLO_A_SA","GLO_P_SA","GLO_T_SA", "MAL_P_SA",
"MAR_P_SA",
"PSL_P_SA",
"MBGD_P_SA",
"BAU_P_SA",
"BIDCO_P_SA",
"DISEU_P_SA",
"EXP_P_SA",
"FINCO_P_SA",
"LDINT_P_SA",
"MEUR_P_SA",
"MITS_P_SA",
"MNV_P_SA",
"MPPA_P_SA",
"MST_P_SA",
"MWOO_P_SA",
"PTC_P_SA",
"TOPCO_P_SA",
"U1_P_SA",
"MLBO_P_SA",
"CLBR_P_SA",
"CQBR_P_SA",
"FSA_P_SA",
"GIBR_P_SA",
"IFBR_P_SA",
"GT_P_SA",
"MABR_P_SA",
"MCE_P_SA",
"MLBR_P_SA",
"PQBR_P_SA",
"TSUA_P_SA",
"TGBVI_P_SA",
"MCA_P_SA",
"ILCL_P_SA",
"MCHIL_P_SA",
"NLCL_P_SA",
"PMCL_P_SA",
"PQCL_P_SA",
"PTCL_P_SA",
"TLCL_P_SA",
"MSHAN_P_SA",
"MSHANC_P_SA",
"MSHSC_P_SA",
"SEAM_P_SA",
"FCO_P_SA",
"MCO_P_SA",
"MLOG_P_SA",
"MDR_P_SA",
"MAPRI_P_SA",
"QUIMA_P_SA",
"UNICH_P_SA",
"MES_P_SA",
"DISFR_P_SA",
"MGR_P_SA",
"MGU_P_SA",
"MGY_P_SA",
"PAKGY_P_SA",
"MAHN_P_SA",
"MHO_P_SA",
"EHK_P_SA",
"GLA_P_SA",
"MHK_P_SA",
"MSTHK_P_SA",
"OBHK_P_SA",
"YL_P_SA",
"ZWHK_P_SA",
"MINDI_P_SA",
"MINDO_P_SA",
"MCI_P_SA",
"ESL_P_SA",
"FWE_P_SA",
"MKE_P_SA",
"SLKE_P_SA",
"MMY_P_SA",
"MMEX_P_SA",
"MNIG_P_SA",
"MPA_P_SA",
"MPY_P_SA",
"CUSA_P_SA",
"LINSU_P_SA",
"MAPE_P_SA",
"MAPH_P_SA",
"MPH_P_SA",
"MPL_P_SA",
"MRO_P_SA",
"KMSAU_P_SA",
"MSAU_P_SA",
"BLPM_P_SA",
"LLPM_P_SA",
"MPMY_P_SA",
"MVN_P_SA",
"MVNS",
"MVT_P_SA",
"TLPM_P_SA",
"VLIN_P_SA",
"ANSA_P_SA",
"CBSA_P_SA",
"CHEMSA_P_SA",
"MSA_P_SA",
"MTH_P_SA",
"MTT_P_SA",
"ACEM_P_SA",
"MCST_P_SA",
"MME_P_SA",
"MUAE_P_SA",
"MTR_P_SA",
"ESLUG_P_SA",
"MISR_P_SA",
"MMIEG_P_SA",
"ECSTA_P_SA",
"MAGUS_P_SA",
"MUSA_P_SA",
"EXUY_P_SA",
"MQEC_P_SA",
"ACEMUS_P_SA",
"MSTUS_P_SA",
"SATURN_P_SA",
"TPBR_P_SA",
"TPBR"
]

    for groupfilter in groupFilters:
        # Get all groups
        #groups_url = 'https://graph.microsoft.com/v1.0/groups'
        ## Security enabled groups
        ##groups_url = 'https://graph.microsoft.com/v1.0/groups?$filter=mailEnabled eq false&securityEnabled eq true'
        print(groupfilter)
        groups_url = "https://graph.microsoft.com/v1.0/groups?$filter=startswith(displayName,'"+ (groupfilter)+"')"
        print(groups_url)
        groups = get_paginated_results(groups_url, headers)        
        allgroups.extend(groups)
        #print(f'Type results:', type(groups))
        
    #print(allgroups)   
    dfgroupsfull = pd.DataFrame(allgroups) 
    #display(dfgroupsfull) 
     ## Transform and load data into spark frame only group id and group name columns
    dfgroupsfull.rename(columns={'id': 'Group_Id', 'displayName': 'Group_Name'}, inplace=True)
    #display(dfgroupsfull) 
    
    dfgroups = dfgroupsfull[['Group_Id','Group_Name']]
    sp_df = spark.createDataFrame(dfgroups)
    
    #sp_df.write.mode("overwrite").option("delta.columnMapping.mode", "name").option("mergeSchema", "true").format("delta").save("Tables/" + group_table_name)
    # save the data to warehouse
    sp_df.write.mode("overwrite").synapsesql(group_table_name)

    all_groups_members = []

    print(len(allgroups))
    groupnumber = 1
    # Get members of each group
    for group in allgroups:
        print("GroupNumber : ", groupnumber)
        group_id = group['id']
        group_name = group['displayName'],        
        print(f"Fetching members for group: {group_name}")
        members_url = f'https://graph.microsoft.com/v1.0/groups/{group_id}/members'
        members = get_paginated_results(members_url, headers)
        groupid_key = "group_id"
        groupid_value = group_id
        groupname_key = "group_name"
        groupname_value = group['displayName']
        members = list(map(lambda d, idx: {**d, groupid_key: groupid_value}, members, range(len(members))))
        members = list(map(lambda d, idx: {**d, groupname_key: groupname_value}, members, range(len(members))))
        groupnumber+=1
        print(members)            
        # save the data to warehouse
        if(len(members) != 0 ):
            for member in members:
                #print(member['@odata.type'])
                if member['@odata.type'] == '#microsoft.graph.user' :
                    user_id = member['id']
                    user_url = f"https://graph.microsoft.com/v1.0/users/{user_id}?$select=displayName,jobTitle,officeLocation,companyName,userPrincipalName," 
                    user_details = get_user(user_url,headers) 
                    print (user_details)
                    dfgroupsmembersfull = pd.DataFrame(user_details,index=[0])
                    display(dfgroupsmembersfull)
                    dfgroupsmembersfull["jobTitle"].fillna("NotAvailable", inplace = True) 
                    dfgroupsmembersfull["officeLocation"].fillna("NotAvailable", inplace = True)   
                    dfgroupsmembersfull["displayName"].fillna("NotAvailable", inplace = True)
                    dfgroupsmembersfull["companyName"].fillna("NotAvailable", inplace = True)
                    dfgroupsmembersfull["groupID"] = group_id
                    dfgroupsmembersfull["groupName"] = group_name
                    display(dfgroupsmembersfull)    
                    sp_df_groupmembers = spark.createDataFrame(dfgroupsmembersfull)
                    sp_df_groupmembers.write.mode("append").synapsesql(group_members_table_name)
        

if __name__ == '__main__':
    main()


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

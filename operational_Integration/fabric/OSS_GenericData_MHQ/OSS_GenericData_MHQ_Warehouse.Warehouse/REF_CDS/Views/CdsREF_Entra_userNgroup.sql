-- Auto Generated (Do not modify) 77E2FC87EA9485B21F55B3CC986FC517E1A5CA37775BBA29D4C5C64D16F6C375

CREATE VIEW [REF_CDS].[CdsREF_Entra_userNgroup]
AS (
SELECT
[userPrincipalName]		as Entra_userPrincipalName
,[displayName]			as Entra_userdisplayName
,[jobTitle]				as Entra_userjobTitle
,[officeLocation]		as Entra_useroffice
,[companyName]			as Entra_company
,[groupID]				as Entra_groupID
,[groupName]			as Entra_groupName
FROM [REF_Entra].[MS_Entra_GroupMembers]
)
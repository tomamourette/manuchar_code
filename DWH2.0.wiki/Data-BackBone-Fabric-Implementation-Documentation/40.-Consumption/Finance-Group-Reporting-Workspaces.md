# Finance Group Reporting Workspaces

[[_TOC_]]

## Overview

The **Finance Group Reporting [<environment>]** workspace in Microsoft Fabric hosts the **Finance Data Product’s** semantic models and Power BI reports.  

Each environment (e.g. `TST`, `ACC`, `QUAL`, `PRD`) has its own workspace instance to ensure separation and controlled promotion of analytical assets.

The workspace acts as the **consumption layer** for Finance-related Data Products, exposing validated and reconciled data to end users through certified semantic models and governed reports.

---

## Workspace Structure

The workspace follows a clear, **data product–centric** folder structure:

```
Finance Group Reporting [<environment>]

│
├── Group-FinancialStatements
│   ├── Group-FinancialStatements.SemanticModel
│   └── Reports
│       └── Corporate Performance Financials.Report
│
├── Group-SalesAndMargin
│   ├── Group-SalesAndMargin.SemanticModel
│   └── Reports
│       └── Sales and Margin Overview.Report
│
└── [Other Data Products...]
```

**Folder explanation:**

- Each **Data Product** (e.g. `Group-FinancialStatements`, `Group-SalesAndMargin`) has its own folder.

- Inside each folder:

  - The `.SemanticModel` subfolder contains the **Power BI semantic model** used for that Data Product.

  - The `Reports` subfolder stores **linked Power BI reports** that consume the semantic model.

---

## Row-Level Security (RLS)

Access to data within semantic models is restricted using **Row-Level Security (RLS)** roles defined directly in the model.  

Members (e.g., Entra ID groups) are assigned to these roles to control visibility per user or group.

Example configuration for the *UserBased* RLS role:

```
GLO_P_SA_FAB-DP_FinGroup-FinancialStatements_All

GLO_Q_SA_FAB-DP_FinGroup-FinancialStatements_All

``` 

This ensures environment-specific access control between Production (PRD), Qualification (QUAL), and other environments.

---

## Version Control and DevOps Integration

All semantic models and reports are **version controlled** within the Azure DevOps repository:

```

https://dev.azure.com/manuchar/Databackbone/_git/data.grabit4finance

```

Repository structure:

```

data.grabit4finance/
│
├── Group-FinancialStatements/
│   ├── Group-FinancialStatements.SemanticModel/
│   │   └── definition.pbir
│   └── Reports/
│       └── Corporate Performance Financials.Report/
│           └── definition.pbir
│
├── Group-SalesAndMargin/
│   ├── Group-SalesAndMargin.SemanticModel/
│   │   └── definition.pbir
│   └── Reports/
│       └── Sales and Margin Overview.Report/
│           └── definition.pbir
│
└── [Other Data Product folders...]

```  

**Versioning workflow:**

- Changes to semantic models or reports are made in Fabric and exported as `.pbism` or `.pbir` files.

- These files are committed to the corresponding folder in the DevOps repository.

- CI/CD pipelines can be configured to deploy these assets across environments (`TST → ACC → QUAL → PRD`).

---

## Summary

- **Workspace:** Finance Group Reporting [<environment>]  

- **Purpose:** Hosts the semantic models and reports per Finance Data Product.  

- **Structure:** Organized by data product folders, separating models and reports.  

- **Security:** Managed via RLS and Entra ID groups per environment.  

- **Versioning:** Controlled via Azure DevOps (`data.grabit4finance`) for reproducibility and governance.
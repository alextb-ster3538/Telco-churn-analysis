<img width="1528" height="510" alt="Copilot_20260704_203630" src="https://github.com/user-attachments/assets/739734b4-154c-48d6-8143-43b4a04655c2" />

---

A complete end‑to‑end churn analytics project using **PostgreSQL**, **Python**, and **Power BI** to uncover churn drivers, quantify revenue at risk, and identify high‑value customer segments requiring proactive retention strategies.

---

## 🧩 Project Overview

This project analyzes customer churn for a telecommunications company using a full analytics pipeline:

- **PostgreSQL** for data storage, cleaning, validation, and aggregation  
- **Python** for EDA, feature engineering, and churn risk scoring  
- **Power BI** for interactive dashboards and storytelling  
- **Excel** for initial exploration and sanity checks  

The final dashboard provides segmentation, churn patterns, revenue risk, and actionable retention recommendations.

---

## 🧮 Data Preparation & Analysis Workflow

### 🗄️ PostgreSQL
- Imported raw Telco dataset into PostgreSQL.
- Cleaned and validated data:
  - Removed duplicates and nulls in critical fields.
  - Standardized categorical values.
  - Converted `TotalCharges` to numeric and handled missing values.
- Performed analytical SQL queries:
  - Churn rate calculations.
  - Revenue at risk by contract type and service.
  - Monthly charge distribution by tenure group.
  - Payment method churn behavior.
- Created SQL **views** for:
  - High‑risk customer segmentation  
  - Contract‑based churn patterns  
  - Revenue risk modeling  
- Exported cleaned datasets for Python and Power BI.

### 🐍 Python (Pandas, Seaborn, Matplotlib)
- Conducted EDA:
  - Churn distribution by demographics, contract type, payment method.
  - Monthly charge variance across tenure groups.
  - Correlation analysis between churn and tech support/autopay.
- Feature engineering:
  - Tenure bins (0–6, 7–24, 25–48, 49+ months).
  - Churn risk scoring based on contract type, monthly charges, and services.
- Visualization:
  - Histograms, boxplots, churn heatmaps.
  - Service‑based churn comparisons.
- Exported engineered dataset for Power BI dashboard integration.

### 📊 Power BI
- Built a multi‑page dashboard:
  - Churn overview  
  - Tenure segmentation  
  - Contract type analysis  
  - Internet service churn  
  - Payment method behavior  
  - Revenue at risk waterfall chart  
- Added slicers for contract type, tenure, payment method, and service category.
- Designed clean, modern visuals with consistent color themes.

---

## 🔍 Key Insights Summary

### 📉 Overall Churn & Revenue
- **26.58% churn rate** (1,869 of 7,032 customers).  
- **$139K+ revenue at risk**, largely from high‑value churners.  
- Churned customers spend **21.14% more per month** than retained customers.

### ⏳ Tenure
- Largest group: **49+ months (31.84%)**.  
- New customers (0–6 months) show **higher, more scattered monthly charges**.

### 📑 Contracts
- **Month‑to‑month churn: 42.71%** (highest).  
- One‑year: **11.28%** · Two‑year: **2.85%**.  
- Month‑to‑month revenue at risk: **$120.85K**.

### 🌐 Internet Service
- **Fiber optic churn: 41.89%** (highest).  
- DSL churn: **19%** · No internet: **7.43%**.

### 💳 Payment & Autopay
- **Electronic check users: 45.29%** of churn.  
- **34.74%** of churned customers did **not** use autopay.

### 🛠️ Tech Support
- **41.65%** of churned customers lacked tech support.

### 👥 Demographics
- **32.98%** have no partner.  
- **83.76%** are not senior citizens.

### 💰 Revenue Insights
- Month‑to‑month fiber customers: **~$100K revenue risk**.  
- High‑value customers (mostly two‑year contracts) stabilize revenue.  
- 📊📉 Waterfall chart shows:
  - High‑value customers add positive revenue.
  - At‑risk segments reduce cumulative revenue.
  - Month‑to‑month contracts drive most negative change.

---

## 🧠 Technical Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Data storage, cleaning, validation, aggregation |
| **Python (Pandas, Seaborn, Matplotlib)** | EDA, feature engineering, churn risk scoring |
| **Power BI** | Dashboard visualization and storytelling |
| **Excel** | Initial data exploration and sanity checks |

---

## 🧭 Author

**Aleksandra Burmester**  
Junior Data Analyst   
🔗 LinkedIn: *https://www.linkedin.com/in/aleksandra-burmester-1823b72a/*  
💻 GitHub: *https://github.com/alextb-ster3538*

---

## 🏁 Final Takeaway

This project demonstrates a complete analytics workflow — from SQL data engineering to Python EDA to Power BI storytelling — delivering actionable churn insights and revenue‑saving recommendations.

---
## 📚 Dataset Source & Credits
This project uses the Telco Customer Churn dataset originally published on Kaggle:

Dataset: Telco Customer Churn  
Author: Blastchar

Source: https://www.kaggle.com/datasets/blastchar/telco-customer-churn*




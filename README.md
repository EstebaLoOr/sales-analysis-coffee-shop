# 📊 Sales Analysis to Identify Low-Profitability Products  
### Coffee Shop Business Intelligence Case Study

> **English version first for U.S. recruiters and hiring managers**  
> *Versión en español más abajo.*

---

# 🇺🇸 English Version

## 📌 Project Overview

Sales analysis of a real coffee shop located in Cuernavaca, Mexico, focused on identifying low-profitability products, customer purchasing behavior, and revenue growth opportunities using **SQL** and **Power BI**.

The main objective was to transform historical sales data into actionable business decisions to increase revenue and optimize the product mix.

---

# 🧠 Business Problem

The coffee shop **Corazón de Piedra** had historical sales data available, but lacked visibility into:

- Which products generated the most value
- Which items underperformed
- When demand peaked during the week
- How to increase average ticket size without increasing customer traffic

### Stakeholders

- Business Owner / Management

---

# 📈 Featured Dashboard

The dashboard includes executive KPIs such as:

- Net Revenue
- Average Ticket Size
- Number of Transactions
- Monthly Sales Trend
- Sales by Category
- Top Selling Products
- Sales by Hour

![Dashboard preview](images/dashboard_preview.PNG)

### Why it matters

It helps quickly identify:

- Peak days and hours
- Best-selling products
- Cross-sell opportunities
- Weekend dependency
- Revenue trends

---

# 📂 Dataset

**Source:** Internal Point-of-Sale (POS) export  
**Size:** 16,656 rows / 23 columns  
**Format:** CSV → SQL Database → Power BI

### Key Variables

- `fecha` → Transaction date & time  
- `numero_de_recibo` → Receipt ID  
- `categoria` → Product category  
- `articulo` → Product name  
- `cantidad` → Units sold  
- `ventas_netas` → Net sales amount  
- `tipo_de_recibo` → Sale / Refund  
- `tipo_de_pedido` → Dine-in / Takeaway

### Data Quality Notes

- ~3% duplicate records removed
- Missing customer fields
- UTF-8 encoding issues fixed
- Some missing categories manually reclassified

---

# 🔍 Analysis Process

## 1. Exploratory Data Analysis (EDA)

- Sales distribution by category and product
- Revenue by day, month, and hour
- Average ticket analysis
- Top-selling products
- Cross-sell behavior (drink + food)

## 2. Data Cleaning / Preprocessing

- Null handling
- Duplicate removal
- Data type conversion
- Text normalization
- Encoding corrections
- Manual product categorization

## 3. Business Analysis

- KPI development
- Revenue opportunity sizing
- Product performance review
- Operational demand analysis

---

# 💡 Key Findings

📌 The coffee shop generated **$1.20M MXN** in less than one year.  

📌 Average ticket size reached **$258 MXN**, strong for a local coffee shop.  

📌 Only **48.85%** of tickets included both drink + food, showing cross-sell opportunity.  

📌 Friday, Saturday, and Sunday concentrated the highest demand.  

📌 Estimated potential of **+10% revenue growth** through ticket optimization and slow-day activation.

---

# 📈 Business Impact

### Estimated Revenue Drivers

- Increase average ticket size by 10%
- Improve food + drink bundle rate
- Activate low-performing weekdays
- Improve product mix decisions

### Estimated Outcome

**+$120K to +$180K MXN annual upside potential**

---

# 🛠️ Tools & Technologies

- SQL (MySQL)
- Power BI
- Excel
- Git
- GitHub

---

# 📁 Repository Structure

```text
📦 sales-analysis-coffee-shop
┣ 📂 SQL
┃ ┗ 📄 coffee_shop_analysis.sql
┣ 📂 dashboard
┃ ┗ 📄 coffee_shop_dashboard.pbix
┣ 📂 data
┃ ┗ 📄 clean_coffee_shop_data.csv
┣ 📂 images
┃ ┗ 📄 dashboard_preview.PNG
┣ 📄 README.md
┗ 📄 LICENSE
```

# How to Use This Project
- Clone Repository
- git clone https://github.com/EstebaLoOr/sales-analysis-coffee-shop.git
- cd sales-analysis-coffee-shop

# Open Files
- [SQL analysis](SQL/coffee_shop_analysis.sql)
- [Power Bi Dashboard](dashboard/coffee_shop_dashboard.pbix)
- [Data](data/clean_coffee_shop_data.csv)

# E-commerce Growth Analysis

## 1. Project Overview

This project analyzes user growth, conversion, and monetization patterns in an e-commerce platform using transactional data.

The goal is to evaluate whether platform growth is sustainable and identify the key drivers behind user behavior and revenue.

**Full analysis (Notion):**  
https://abiding-puppet-076.notion.site/E-commerce-Growth-Analysis-User-Behavior-Cohort-Dynamics-and-Monetization-34445a9fe7e28025a52bf1082163c443

---

## 2. Business Objective

This analysis focuses on answering the following key questions:

1. Is user growth accompanied by stable or improving conversion rates?
2. Are users becoming more engaged (repeat purchase behavior)?
3. What drives revenue growth: user expansion or user value?
4. What role do promotions play in influencing purchase behavior?

---

## 3. Dataset & Scope

- Data period: 2016 Q3 – 2022 Q2 (full quarters only)
- Users: age ≥ 16 at join
- Transactions: only successful payments included
- Cohort windows: 30-day and 90-day

**Data source (Kaggle):**  
https://www.kaggle.com/datasets/bytadit/transactional-ecommerce

---

## 4. Data Preparation

- Cleaned and standardized customer and transaction tables
- Removed incomplete time periods and invalid age groups
- Transformed raw data into analysis-ready tables:
  - `customer_analysis`: user-level features (age, cohort, first order)
  - `customer_metrics`: aggregated purchase behavior at user level

---

## 5. Metrics Definition

| Metric | Definition |
|--------|-----------|
| Conversion Rate | Users with ≥1 order / total users |
| Repeat Rate | Users with ≥2 orders / converted users |
| Average Orders per User | Total orders / converted users |
| AOV | Total revenue / total orders |
| ARPPU | Total revenue / converted users |
| Promo Order Rate | Promo orders / total orders |
| Discount Rate | Promo amount / (revenue + promo amount) |

---

## 6. Analysis Framework

The analysis is structured into four key areas:

1. **User Profile & Growth**  
   → Understand user composition and growth trends

2. **Purchase Behavior**  
   → Analyze repeat purchase and monetization patterns

3. **Conversion Analysis (Cohort-based)**  
   → Evaluate how effectively new users convert

4. **Promotion Impact**  
   → Assess the role of promotions in driving purchases

---

## 7. Key Insights

- User growth is strong and continuous, with seasonal peaks in Q1 and Q3  
  → No consistent low season is observed

- Conversion rates decline over time across all cohorts  
  → Suggesting growth may be driven by lower-quality users

- Repeat purchase behavior improves over time  
  → Converted users tend to remain engaged

- Revenue growth is driven by both user expansion and increasing ARPU

- Promotions are widely used but have minimal financial impact  
  → Discount rates remain extremely low

---

## 8. Business Implications

- Growth quality should be monitored alongside user volume
- Improving early conversion is critical for long-term value
- Retention strategies may be more effective than acquisition
- Promotions are not a primary driver of revenue growth

---

## 9. Tools & Skills

- SQL (data cleaning, aggregation, cohort analysis)
- Power BI (data visualization)
- Data modeling and metric design
- Growth analysis and cohort analysis

---

## 10. Project Structure
```
Ecommerce-Growth-Analysis/
│
├── README.md #  Project overview (EN)          
├── README_CN.md #  中文版本        
│
├── SQL/ # Data preparation & analysis queries
├── Data/ 
└── Source: Kaggle dataset
```

# ⚽ Football Player Value & Performance Optimization

## 📌 Project Overview

This project develops a data-driven football scouting and player valuation platform for **ZDIP United**, a mid-tier European football club preparing for the summer transfer window.

The objective is to identify undervalued players ("Hidden Gems"), analyze player performance metrics, and predict player market values using Machine Learning techniques.

---

## 🎯 Business Problem

ZDIP United operates with a limited transfer budget and requires a data-driven recruitment strategy to identify high-performing players available below their expected market value.

Traditional scouting methods are expensive and subjective, so this project uses analytics to support transfer decision-making.

---

## 🎯 Project Objectives

- Identify undervalued players across European leagues.
- Analyze player performance metrics and market value relationships.
- Develop a player market value prediction model.
- Build interactive Power BI dashboards for scouting and recruitment.
- Support transfer decision-making using data analytics.

---

## 🛠 Technologies Used

- SQL
- Python
- Pandas
- NumPy
- Scikit-Learn
- Matplotlib
- Seaborn
- Power BI
- GitHub

---

## 🗄 Database Schema

### Fact Table
- Fact_MatchPerformance

### Dimension Tables
- Dim_Player
- Dim_Club
- Dim_League
- Dim_Position
- Dim_Season

---

## 📊 Dataset Features

### Player Information
- PlayerName
- Age
- Height
- Weight
- Nationality
- PreferredFoot

### Financial Metrics
- MarketValueEUR
- WageEUR

### Performance Metrics
- Goals
- Assists
- GoalContribution
- xG
- xA
- PassAccuracy
- KeyPasses
- TacklesWon
- Interceptions
- DefensiveDuelsWon
- Shots
- ShotsOnTarget
- DribblesCompleted
- ProgressivePasses
- ProgressiveCarries
- PerformanceScore

---

## 🗃 SQL Development

SQL was used for:

- Data cleaning and transformation
- Creating analytical views
- Joining fact and dimension tables
- Aggregation and KPI calculations

### SQL Views Created
- `vw_GoalMarketValueRatio`
- `vw_TopPerformers`
- `vw_PlayerDashboard`

---

## 🐍 Python Analysis

Python was used for:

- Exploratory Data Analysis (EDA)
- Descriptive Statistics
- Correlation Analysis
- Outlier Detection
- Similarity Scoring using Euclidean Distance
- Feature Engineering

### Visualizations
- Correlation Heatmap
- Boxplots
- Market Value Distribution
- Age vs Market Value Analysis

---

## 🤖 Machine Learning Model

### Model Used
- Linear Regression

### Target Variable
- MarketValueEUR

### Features Used
- Age
- Goals
- Assists
- xG
- xA
- PassAccuracy
- GoalContribution
- PerformanceScore
- Defensive Metrics
- Progressive Actions

### Model Performance

| Metric | Value |
|--------|-------|
| R² Score | 0.262 |
| Mean Absolute Error (MAE) | €17.72 Million |

---

## 💎 Hidden Gems Identification

Players were classified as **Undervalued** when:

```text
Predicted Market Value > Actual Market Value
```

These players represent potential transfer opportunities for ZDIP United.

---

## 📈 Power BI Dashboards

### Page 1 — Executive Overview Dashboard
- KPI Cards
- Player Distribution by Position
- Market Value by League
- Market Value by Age
- League Performance Analysis

### Page 2 — Player Performance Analysis
- Market Value vs Goal Contribution
- xG vs Goals
- Top Players by Performance Score
- Preferred Foot Distribution

### Page 3 — AI Value Predictor
- Actual vs Predicted Market Value
- Top Undervalued Players
- Hidden Gems Analysis

### Page 4 — Scouting Insights Dashboard
- Position Distribution
- Geographic Analysis
- Recruitment Insights
- Transfer Market Opportunities
## Dashboard Preview

![Overview Dashboard]
(<img width="1920" height="1080" alt="Screenshot 2026-07-08 165709" src="https://github.com/user-attachments/assets/94974fda-e09b-46f1-9b36-d18870375c1d" />
)

![Player Analysis Dashboard]
(<img width="1920" height="1080" alt="Screenshot 2026-07-08 165717" src="https://github.com/user-attachments/assets/e3f16f61-678e-4c59-892a-e52a8c12c69d" />
)

![AI Value Predictor Dashboard]
(<img width="1920" height="1080" alt="Screenshot 2026-07-08 165724" src="https://github.com/user-attachments/assets/d4668acc-84a9-4ddb-8038-2a3cb37e4a31" />
)

---

## 📁 Repository Structure

```text
Football-Player-Value-Optimization/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── sql/
│   ├── schema.sql
│   ├── views.sql
│   └── queries.sql
│
├── notebooks/
│   ├── EDA.ipynb
│   ├── Feature_Engineering.ipynb
│   ├── Linear_Regression_Model.ipynb
│   └── Hidden_Gems_Analysis.ipynb
│
├── dashboards/
│   ├── Football_Analytics.pbix
│   └── screenshots/
│
├── documentation/
│   ├── Technical_Documentation.docx
│   └── Project_Report.pdf
│
├── requirements.txt
└── README.md
```

---

## 🚀 Key Outcomes

- Developed a complete football scouting analytics pipeline.
- Identified undervalued players using machine learning.
- Built interactive dashboards for recruitment analysis.
- Integrated SQL, Python, Machine Learning, and Power BI into a single solution.

---

## 🔮 Future Improvements

- Random Forest and XGBoost models.
- Real-time football API integration.
- Injury and contract analysis.
- Advanced player similarity models.

---

## 👤 Author

**Haritha Nanganuru**



---

## 📜 License

This project was developed for educational and internship purposes.

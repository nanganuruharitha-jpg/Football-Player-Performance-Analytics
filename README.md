# Football-Player-Performance-Analytics
Football Player Performance Analytics using SQL, Python, Machine Learning, and Power BI.
# Football Player Performance Analytics

## Project Overview

The **Football Player Performance Analytics** project analyzes football player statistics using **SQL, Python, Machine Learning, and Power BI**. The project focuses on cleaning and transforming player data, identifying top-performing players, predicting player market values using a **Linear Regression** model, and presenting insights through an interactive Power BI dashboard.

---

##  Objectives

* Analyze football player performance using statistical data.
* Clean and preprocess the dataset using SQL and Python.
* Predict player market value using Machine Learning.
* Create an interactive Power BI dashboard for visualization.
* Identify top-performing players based on key performance metrics.

---

##  Dataset Information

The dataset contains football player statistics, including:

* Player ID
* Player Name
* Age
* Team
* League
* Position
* Goals
* Assists
* Minutes Played
* Market Value
* Match Performance Statistics

The dataset was transformed into dimension and fact tables for analysis.

---

## 🛠️ Technologies Used

| Technology       | Purpose                                    |
| ---------------- | ------------------------------------------ |
| SQL Server       | Data storage, cleaning, and transformation |
| Python           | Data preprocessing and Machine Learning    |
| Jupyter Notebook | Model development and analysis             |
| Pandas           | Data manipulation                          |
| Scikit-learn     | Linear Regression model                    |
| Power BI         | Interactive dashboard creation             |
| GitHub           | Project version control and sharing        |

---

## 📂 Project Structure

```text
Football-Player-Performance-Analytics/
│
├── Dataset/
│   ├── Dim_Date.csv
│   ├── Dim_League.csv
│   ├── Dim_Match.csv
│   ├── Dim_Player.csv
│   ├── Dim_Team.csv
│   ├── Fact_MatchPerformance.csv
│   ├── PlayerPerformance.csv
│   ├── EfficiencyScore.csv
│   ├── GoalMarketValueRatio.csv
│   ├── TopPerformers.csv
│   └── Predicted_Player_Values.xls
│
├── SQL/
│   └── SQL Queries.sql
│
├── Python/
│   └── Football_Player_Analytics.ipynb
│
├── PowerBI/
│   └── Football_Player_Dashboard.pbix
│
├── Images/
│   └── dashboard.png
│
├── README.md
└── Technical_Documentation.md
```

---

## ⚙️ Project Workflow

1. Import the football player dataset.
2. Clean and preprocess data using SQL and Python.
3. Create dimension and fact tables.
4. Engineer features for Machine Learning.
5. Train a Linear Regression model.
6. Predict player market values.
7. Export prediction results.
8. Build an interactive Power BI dashboard.
9. Publish the complete project on GitHub.

---

## 📈 Machine Learning Model

**Algorithm Used**

* Linear Regression

**Input Features**

* Goals
* Assists
* Minutes Played
* Age
* Position
* Other player performance metrics

**Target Variable**

* Market Value

**Evaluation Metrics**

* R² Score
* RMSE
* MAE

---

## 📊 Power BI Dashboard Features

* KPI Cards
* Scatter Plot (Market Value vs Goal Contributions)
* Top Performers Bar Chart
* League Filter
* Position Filter
* Interactive Cross-filtering

---

## 📷 Dashboard Screenshot

Add your dashboard screenshot to the **Images** folder and name it:

<img width="1920" height="1080" alt="Screenshot 2026-06-26 195814" src="https://github.com/user-attachments/assets/86cdea1b-aa76-4707-9efd-7f3a2a09892b" />


Then GitHub will automatically display it using:

```markdown
![Power BI Dashboard](Images/dashboard.png)
```
<img width="1920" height="1080" alt="Screenshot 2026-06-26 195808" src="https://github.com/user-attachments/assets/9ac0d07a-772f-475c-9177-4da4ca6e181e" />

---

## 🚀 Future Improvements

* Improve prediction accuracy using advanced ML models.
* Connect the dashboard to live football data.
* Add player comparison features.
* Deploy the dashboard online.
* Include additional player performance metrics.

---

## 👨‍💻 Author

**Nanganuru Haritha**

Project developed as part of a Data Analytics internship using SQL, Python, Machine Learning, Power BI, and GitHub.

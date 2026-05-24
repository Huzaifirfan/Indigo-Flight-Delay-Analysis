# ✈️ IndiGo Flight Delay Analysis

## 📌 Project Overview
A complete Flight Delay Analysis System built
for IndiGo Airlines using MySQL.
Analyzes flight delays across routes, aircraft,
crew performance and weather conditions.

## 🗄️ Database Structure
- **8 Tables:** airports, aircraft, routes,
  flights, delays, passengers, crew, weather
- **Normalization:** 3NF
- **Records:** 20 flights, 10 airports,
  10 aircraft, 15 routes

## 🔗 Table Connections
airports → routes → flights → delays
                 → passengers
                 → crew
weather → airports

## 💡 Key Insights
- Most delayed route identified
- Weather impact on delays analyzed
- Captain experience vs on-time performance
- Aircraft model performance comparison

## 🛠️ SQL Concepts Used
- Complex Multi-table JOINs
- Window Functions (RANK, ROW_NUMBER)
- CTEs (Common Table Expressions)
- Subqueries
- Aggregate Functions
- CASE WHEN statements
- Date & String Functions

## 📊 Analysis Queries
1. Total flights by status
2. Most delayed routes
3. Delay reason analysis
4. Weather vs delay correlation
5. Captain performance report
6. Aircraft model comparison
7. Complete delay report (7 table JOIN)

## 🚀 How to Run
1. Open MySQL Workbench
2. Run indigo_flight_analysis.sql
3. Database will be created automatically
4. Run analysis queries from queries.sql

## 👨‍💻 Tech Stack
- MySQL 8.0
- MySQL Workbench

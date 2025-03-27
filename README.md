# ✈️ Airline Data Analysis - SQL Project

## 📌 Project Overview
This project analyzes airline flight delays and cancellations using **MySQL Workbench**. The dataset contains flight performance data, including delayed flights, cancellation reasons, and delay causes. The goal is to extract meaningful insights into the **busiest airports, most delayed airlines, seasonal trends, and main causes of delays**.

## 🗂️ Dataset Information
- **Source**: BTS Airline On-Time Performance Data  
- **File Format**: CSV  
- **Rows**: 1928  
- **Columns**: Flight information, delays, and causes  

## 🏗️ Database Schema
The project is structured into multiple tables for better data organization:
- **`airlines`** - Stores airline carrier names.  
- **`airports`** - Stores airport names.  
- **`flights`** - Contains flight records, including delays and cancellations.  
- **`delay_causes`** - Breaks down delay reasons (weather, security, etc.).  
- **`flight_delays`** (Temporary) - Used to load raw CSV data before transformation.  

## 🔍 Key Insights & SQL Queries
1️⃣ Top 10 Airlines with Most Delays
Finds airlines with the highest number of delayed flights.
2️⃣ Worst Airports for Flight Delays
Identifies airports with the most flight delays.
3️⃣ Main Causes of Flight Delays
Breaks down delay reasons (weather, carrier, security, NAS, late aircraft).
4️⃣ Flight Delays by Month (Seasonal Trends)
Analyzes which months and seasons experience the most delays.
5️⃣ Flight Delays Over the Years
Shows trends in flight delays over time (increasing or decreasing).
6️⃣ Airlines with Longest Average Delay Duration
Finds which airlines have the worst delay times on average.
7️⃣ Airports with Longest Total Delay Time
Identifies airports where flights face the most delay minutes.
8️⃣ Total Delays Grouped by Cause per Year
Examines if specific delay causes (weather, carrier issues, etc.) have worsened over time.
9️⃣ Worst Month for Weather-Related Delays
Finds the month with the highest weather-related disruptions.
🔟 Airlines with Most Weather-Related Delays
Identifies airlines most affected by weather delays.
1️⃣1️⃣ Airports with Worst Security-Related Delays
Lists airports with the longest security-related delays.
1️⃣2️⃣ Percentage of Flights Delayed vs. Total Flights
Calculates how much of an impact delays had on overall flight operations.
1️⃣3️⃣ Busiest Airports by Number of Flights
Ranks airports handling the highest volume of flights.

🏗️ Project Steps
Loaded CSV Data into MySQL Workbench.

Designed relational database schema (airlines, airports, flights, delay causes).

Transferred cleaned data into structured tables.

Executed SQL queries to generate insights.

Analyzed the results and identified trends in delays and cancellations.

🚀 Tools & Technologies Used
MySQL Workbench – Database management and SQL execution.

BTS Dataset – Real-world airline data.

SQL Queries – Data extraction and analysis.

📌 How to Run This Project
1. Clone the repository:
git clone https://github.com/your-username/Airline-Data-Analysis-SQL.git
2. Import the dataset into MySQL Workbench.
3. Run the SQL scripts provided in queries.sql.
4. Modify queries if needed to analyze different insights.

📢 Connect with Me
👤 B Tejaswini
📧 Email: [btejaswini1909@gmail.com]

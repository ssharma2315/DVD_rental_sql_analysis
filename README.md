# DVD Rental Business Analysis
### SQL Portfolio Project | PostgreSQL

---

## Project Overview

This project analyzes a DVD rental business database using advanced SQL queries
to answer 10 real business questions. The analysis covers revenue performance,
customer behavior, inventory management, and business growth trends.

**Tools Used:** PostgreSQL, pgAdmin  
**Dataset:** DVD Rental Sample Database  
**Skills Demonstrated:** JOINs, CTEs, Window Functions, Aggregations, 
Subqueries, Date Functions

---

## Business Questions Answered

| # | Question | Key Finding |
|---|----------|-------------|
| 1 | Which film categories generate the most revenue? | Sports leads with $4,892 (7.98%) |
| 2 | Who are the top 10 customers by lifetime spend? | Eleanor Hunt tops at $211.55 |
| 3 | Which months had highest and lowest rental activity? | Peak: Jul 2005 (6,709 rentals) Low: Feb 2006 (182 rentals) |
| 4 | What is average rental duration by category? | Travel has longest avg at 5.35 days |
| 5 | Which films have never been rented? | 43 films identified as dead inventory |
| 6 | Who are top 5 actors by film appearances? | Gina Degeneres leads with 42 films |
| 7 | Which store performs better in revenue? | Store 2 leads with $30,683 vs $30,628 |
| 8 | Active vs inactive customer breakdown? | 584 active (97.5%) vs 15 inactive (2.5%) |
| 9 | Which films are rented most frequently? | Bucket Brotherhood tops with 34 rentals |
| 10 | What is month over month revenue growth? | March 2007 had highest growth at +$15,534 |

---

## Key Business Insights

**Revenue**
- Sports and Sci-Fi are the top revenue generating categories
- Both stores perform almost equally — Store 2 leads by only $54
- March 2007 saw the highest revenue jump of $15,534 month over month
- May 2007 shows negative growth due to incomplete month data

**Inventory**
- 43 films have never been rented — dead inventory worth reviewing
- Bucket Brotherhood is the most rented film with 34 rentals
- Travel category films have the longest rental duration at 5.35 days

**Customers**
- 97.5% of customers are active — strong retention rate
- Top 10 customers contribute significantly to revenue
- Eleanor Hunt is the highest value customer at $211.55 lifetime spend

**Actors**
- Gina Degeneres appears in 42 films — most prolific actor in catalog
- Top 5 actors each appear in 37+ films

---

## How to Run

1. Install PostgreSQL
2. Download the DVD Rental dataset from [PostgreSQL Tutorial](https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/)
3. Restore the database:
```bash
pg_restore -U postgres -d dvdrental dvdrental.tar
```
4. Open `dvdrental_analysis.sql` in pgAdmin or any SQL client
5. Run queries individually or all at once

---

## Project Structure
```
dvdrental-analysis/
│
├── dvdrental_analysis.sql    # All 10 business queries with comments
├── README.md                 # Project documentation
```

---

## Skills Demonstrated

- **Multi-table JOINs** — connecting up to 5 tables in a single query
- **CTEs** — breaking complex logic into readable steps
- **Window Functions** — LAG for month over month comparison
- **Aggregations** — revenue, counts, averages by category
- **NULL handling** — identifying dead inventory using LEFT JOIN
- **Date functions** — TO_CHAR, EXTRACT for time-based analysis
- **Business thinking** — translating business questions into SQL

----


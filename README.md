# Marketing Analytics Mini Project (SQL & BigQuery)

## Project Overview

This project combines GA4 event-level data and advertising datasets to analyze user behavior, conversion funnels, and marketing performance.

It demonstrates an end-to-end analytics workflow from raw event data extraction to business-level insights.

---

## Data Sources

* Google BigQuery (GA4 dataset)
* PostgreSQL (Facebook Ads & Google Ads data)

---

## Analysis Areas

### 1. Event-Level Data Extraction

Extracted key fields from GA4 event data including session_id, user, device, and traffic source.

### 2. Funnel Analysis

Built a session-level funnel:

* session_start → add_to_cart → checkout → purchase

Calculated conversion rates across different traffic sources.

### 3. Landing Page Performance

Analyzed landing page effectiveness by measuring:

* session volume
* purchases
* conversion rates

### 4. Engagement Analysis

Measured correlation between:

* user engagement
* engagement time
* purchase behavior

### 5. Marketing Performance (PostgreSQL)

* ROMI analysis (profitability)
* Platform comparison (Facebook vs Google)
* Weekly and monthly performance trends
* Campaign growth analysis

### 6. Adset Activity Analysis

Identified longest active streaks of adsets using window functions.

---

## Key Techniques

* UNNEST (GA4 nested data)
* Session-level aggregation
* Funnel conversion logic
* Regex for URL parsing
* Window functions (LAG, ROW_NUMBER)
* Correlation analysis
* Multi-source data integration

---

## Tools Used

* Google BigQuery
* PostgreSQL
* SQL
* DBeaver

---

## Key Insights

* Conversion rates vary significantly across traffic sources
* User engagement is positively correlated with purchase behavior
* Landing page performance strongly impacts conversion rates
* Marketing efficiency differs across platforms and campaigns
* Campaign activity patterns can be analyzed over time

---

## Conclusion

This project demonstrates how raw data can be transformed into actionable insights using SQL and BigQuery, enabling data-driven decision-making in marketing and product analytics.

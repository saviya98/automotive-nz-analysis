# Data Dictionary — NZ Automotive Aftermarket Analysis

This document describes all tables and fields in the dataset.
All data is synthetic and generated for portfolio purposes.

---

## Table: orders
**Type:** Fact table
**Rows:** 5,000
**Description:** Central fact table recording every sales transaction
across all branches over a 2-year period (2023–2024).

| Column | Data Type | Description | Example |
|---|---|---|---|
| order_id | INTEGER | Unique identifier for each order | 1, 2, 3 |
| order_date | DATE | Date the order was placed | 2024-06-15 |
| branch_id | INTEGER | Foreign key linking to branches table | 3 |
| customer_id | INTEGER | Foreign key linking to customers table | 47 |
| product_id | INTEGER | Foreign key linking to products table | 82 |
| quantity | INTEGER | Number of units ordered (1–5) | 2 |
| unit_price | FLOAT | Selling price per unit at time of order (RRP) | 145.50 |
| revenue | FLOAT | Total revenue for the order (unit_price × quantity) | 291.00 |

**Notes:**
- quantity is weighted — single unit orders are most common (40%)
- revenue is pre-calculated as unit_price × quantity
- order_date has slight drift beyond Dec 2024 due to Faker behaviour

---

## Table: branches
**Type:** Dimension table
**Rows:** 10
**Description:** Reference table describing each branch location,
brand, region, and business segment.

| Column | Data Type | Description | Example |
|---|---|---|---|
| branch_id | INTEGER | Unique identifier for each branch | 1 |
| branch_name | TEXT | Full name of the branch | BNT Auckland Central |
| brand | TEXT | Brand the branch operates under | BNT |
| region | TEXT | NZ region where branch is located | Auckland |
| segment | TEXT | Business segment the branch belongs to | Trade |

**Brand values:**
- BNT — general trade parts
- Autolign — steering and suspension wholesale
- HCB — auto electrical specialist
- Battery Town — battery service centres
- Diesel Dist — diesel fuel injection specialist

**Segment values:**
- Trade — supplies independent workshops and chain mechanics
- Specialist Wholesale — higher value parts distribution
- Service — retail and service centre operations

**Region values:**
- Auckland (4 branches — 40% of total)
- Wellington (2 branches)
- Christchurch (1 branch)
- Hamilton (2 branches)

---

## Table: products
**Type:** Dimension table
**Rows:** 120
**Description:** Reference table describing each product including
category, brand, cost price, and recommended retail price.
20 products per category × 6 categories = 120 total.

| Column | Data Type | Description | Example |
|---|---|---|---|
| product_id | INTEGER | Unique identifier for each product | 45 |
| part_number | TEXT | Unique part reference code | BNT-SUS-1045 |
| category | TEXT | Product category | Suspension |
| brand | TEXT | Manufacturer brand | Monroe |
| unit_cost | FLOAT | Cost price to the distributor | 87.50 |
| rrp | FLOAT | Recommended retail price (cost × margin) | 140.00 |

**Category values and price ranges:**

| Category | Cost Range | Margin Applied | Notes |
|---|---|---|---|
| Brakes | $15–$180 | 30–80% | High volume, mid margin |
| Filters | $8–$45 | 30–80% | Highest volume, lowest revenue |
| Suspension | $40–$320 | 30–80% | High value, lower volume |
| Batteries | $80–$280 | 30–80% | Seasonal demand peak in winter |
| Electrical | $12–$150 | 30–80% | Steady demand year-round |
| Engine | $20–$95 | 30–80% | Oil and consumables |

**Notes:**
- Margin is randomised between 30% and 80% per product
- part_number format: BNT-{CAT}-{ID} where CAT is first 3 letters

---

## Table: customers
**Type:** Dimension table
**Rows:** 200
**Description:** Reference table describing each customer including
their type, region, and when they first joined.

| Column | Data Type | Description | Example |
|---|---|---|---|
| customer_id | INTEGER | Unique identifier for each customer | 12 |
| customer_name | TEXT | Company name (synthetic) | Smith Auto Ltd |
| customer_type | TEXT | Type of customer business | Independent Workshop |
| region | TEXT | NZ region of the customer | Auckland |
| join_date | DATE | Date the customer first joined | 2022-08-14 |

**Customer type distribution (weighted):**

| Customer Type | Weight | Rationale |
|---|---|---|
| Independent Workshop | 45% | Core B2B trade customer base |
| Chain Mechanic | 25% | Franchise and chain workshops |
| Retail | 20% | Walk-in retail customers |
| Fleet Manager | 10% | Corporate fleet accounts |

**Region distribution (weighted by NZ population):**

| Region | Weight |
|---|---|
| Auckland | 45% |
| Wellington | 25% |
| Christchurch | 20% |
| Hamilton | 10% |

---

## Relationships (Star Schema)
branches (branch_id) ←── orders (branch_id)
products (product_id) ←── orders (product_id)
customers (customer_id) ←── orders (customer_id)

orders is the central fact table.
All other tables are dimension tables joined via foreign keys.

---

## Qlik Cloud Data Model Notes

The following field renames were applied in the Qlik load script
to resolve synthetic key conflicts:

| Original Field | Table | Renamed To | Reason |
|---|---|---|---|
| brand | branches | branch_brand | Clashed with products.brand |
| region | branches | branch_region | Clashed with customers.region |
| brand | products | product_brand | Clashed with branches.brand |
| region | customers | customer_region | Clashed with branches.region |

---

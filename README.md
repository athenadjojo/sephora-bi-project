markdown# Sephora Product Intelligence Dashboard

A full end-to-end Business Intelligence project analyzing 8,000+ Sephora 
products and 1M+ skincare reviews to identify which products are genuinely 
worth buying, which are overrated, and which are hidden gems.

---

## Project Overview

This project simulates a real BI engineering workflow — from raw data 
extraction through cleaning, feature engineering, machine learning, and 
analytical insights. The core question driving the analysis:

**Do skincare products live up to their hype, or are customers paying 
for brand perception over formula quality?**

---

## Business Questions Answered

- Which skincare products are most underrated — good formula, fair price, 
  lower rating than deserved?
- Which products are overrated — inflated ratings driven by brand hype 
  rather than objective quality?
- Do expensive products actually have better ingredients?
- Which ingredients appear most in highly rated products?
- Which brands consistently deliver the best rated products?
- What actually drives skincare product ratings — ingredients, price, 
  or something else?

---

## Dataset

**Source:** Kaggle — Sephora Products and Skincare Reviews  
**Link:** https://www.kaggle.com/datasets/nadyinky/sephora-products-and-skincare-reviews

| File | Description | Size |
|---|---|---|
| product_info.csv | 8,494 products with pricing, ingredients, brand info | 7.91 MB |
| reviews_0-250.csv | User reviews batch 1 | — |
| reviews_250-500.csv | User reviews batch 2 | — |
| reviews_500-750.csv | User reviews batch 3 | — |
| reviews_750-1250.csv | User reviews batch 4 | — |
| reviews_1250-end.csv | User reviews batch 5 | — |

**After scoping to skincare only:**
- 1,952 skincare products across 8 subcategories
- 980,344 individual reviews
- 1,915 products with review data for ML modeling

---

## Project Structure
sephora-bi-project/
data/
raw/                         ← original Kaggle CSVs (not tracked in git)
processed/                   ← cleaned and engineered datasets
notebooks/
01_EDA.ipynb                 ← exploratory data analysis
02_cleaning.ipynb            ← data cleaning and scoping
03_features.ipynb            ← feature engineering
04_ml.ipynb                  ← machine learning model
05_ingredient_analysis.ipynb ← ingredient deep dive
sql/
analytics_queries.sql        ← SQL analytics layer
README.md

---

## ETL Pipeline
Kaggle CSVs (raw)
↓
Python Extraction — pandas, glob
↓
Data Validation — nulls, duplicates, rating ranges
↓
Data Cleaning — drop columns, fix casing, filter categories
↓
Feature Engineering — 24 engineered features
↓
SQLite Database — analytics-ready data model
↓
ML Model — Gradient Boosting, predicted ratings, gap analysis
↓
Business Insights — overrated/underrated products, category rankings

---

## Notebooks

### 01_EDA.ipynb — Exploratory Data Analysis
- Loaded 8,494 products and 1,094,411 reviews
- Validated data quality — zero duplicates, 100% valid ratings
- Explored 9 primary categories, 304 brands, $3–$1,900 price range
- Identified positivity bias — 700,000+ of 1M reviews are 5-star
- Found weak price-rating relationship — sweet spot at $75–$150
- Made scope decision — focus on skincare (1,952 products)

### 02_cleaning.ipynb — Data Cleaning
- Dropped 5 high-null columns (sale_price_usd 96.8% null, etc.)
- Standardized brand name casing across products and reviews
- Filtered to 8 skincare subcategories — removed gifts, tools, minis
- Validated cleaned output — zero nulls in core columns
- Saved to data/processed/

### 03_features.ipynb — Feature Engineering
Built 24 features across 5 groups:

| Group | Features |
|---|---|
| Review metrics | avg_rating, review_count, five_star_share, one_star_share, recommendation_rate, avg_helpfulness |
| Price & value | price_rank_pct, rating_per_dollar, price_tier |
| Engagement | loves_count, engagement_quality, review_volume_rank |
| Ingredients | ingredient_score, good_bad_ratio, powerhouse_flag, value_score, good/bad counts |
| Product flags | limited_edition, new, online_only, sephora_exclusive |

### 04_ml.ipynb — Machine Learning Model
- Trained Linear Regression, Random Forest, and Gradient Boosting
- Deliberately excluded sentiment features to force model to learn 
  from objective signals — ingredients, price, engagement
- Gradient Boosting selected as best model (R²=0.54, RMSE=0.269)
- Generated predicted ratings for all 1,915 products
- gap = predicted_rating - actual_rating
- Flagged top/bottom 10% gap as underrated/overrated (50+ review threshold)

### 05_ingredient_analysis.ipynb — Ingredient Deep Dive
- Correlation between ingredient score and rating: 0.057 (near zero)
- Price vs ingredient score correlation: -0.031 (luxury scores lowest)
- Ceramide is the strongest positive ingredient signal (+3.7% in high rated)
- Treatments category has best ingredient profiles (score 0.138)
- Paying more does NOT get better ingredients

---

## Key Findings

### Overrated Products
Products where brand hype inflates ratings beyond objective quality signals.

| Product | Brand | Price | Actual | Predicted | Gap |
|---|---|---|---|---|---|
| Black Tea Anti-Aging Moisturizer | Fresh | $95 | 4.844 | 4.483 | -0.361 |
| Lactic Acid 10% + HA | The Ordinary | $8.90 | 4.501 | 4.125 | -0.376 |
| Ultimate Revival Cream | SK-II | $400 | 4.467 | 4.014 | -0.452 |
| KateCeuticals Lifting Eye Cream | Kate Somerville | $140 | 4.635 | 4.173 | -0.463 |
| Honey Halo Moisturizer Jumbo | Farmacy | $74 | 4.730 | 4.251 | -0.479 |

### Underrated Products
Hidden gems where objective quality exceeds what ratings suggest.

| Product | Brand | Price | Actual | Predicted | Gap |
|---|---|---|---|---|---|
| Vitamin C Brightening Cream | The Inkey List | $10.99 | 3.031 | 3.800 | +0.769 |
| Clean Lip Balm & Scrub | Sephora Collection | $7 | 2.280 | 3.067 | +0.787 |
| Tatcha Silk Sunscreen | Tatcha | $62 | 3.396 | 4.009 | +0.614 |
| Focuspot Micro Tip Patches | Dr. Jart+ | $20 | 3.041 | 3.602 | +0.560 |
| Avocado Nourishing Hydration Mask | Kiehl's | $48 | 3.902 | 4.437 | +0.535 |

### What Actually Drives Skincare Ratings
1. rating_per_dollar (28.4%) — value efficiency is the strongest predictor
2. avg_helpfulness (25.1%) — review trustworthiness matters more than volume
3. Price features combined (27.4%) — expensive products face higher expectations
4. Ingredient features (2%) — formula quality has modest but real impact

### Ingredient Insights
- Price and ingredient quality are unrelated (correlation -0.031)
- Luxury products score lowest on ingredients (0.072 vs 0.099 for mid-tier)
- Ceramide is the strongest positive ingredient signal (+3.7% in high rated)
- Caffeine and aloe barbadensis more common in low rated products
- Treatments have the best ingredient profiles (score 0.138)

---

## Data Validation

| Check | Result |
|---|---|
| Duplicate product IDs | 0 |
| Duplicate reviews | 0 |
| Invalid ratings outside 1-5 | 0 |
| Products with missing price | 0 |
| Reviews with missing rating | 0 |
| Review product IDs exist in products | 100% |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Python 3.12 | Core language |
| pandas | Data manipulation |
| numpy | Numerical computing |
| matplotlib / seaborn | Data visualization |
| scikit-learn | Machine learning |
| SQLite | Analytics database |
| Jupyter Notebook | Interactive analysis |

---

## How to Run

1. Clone the repository
2. Download the dataset from Kaggle and place CSVs in `data/raw/`
3. Install dependencies: `pip install pandas numpy matplotlib seaborn scikit-learn jupyter`
4. Run notebooks in order: 01 → 02 → 03 → 04 → 05

---

## Resume Bullet

Built a Sephora consumer product intelligence pipeline analyzing 8,000+ 
products and 1M+ skincare reviews using Python, SQLite, and scikit-learn; 
designed ETL pipelines, engineered 24 analytical features across review 
quality, pricing, engagement, and ingredient composition; trained Gradient 
Boosting models to identify overrated and underrated skincare products by 
comparing predicted vs actual ratings from objective quality signals.
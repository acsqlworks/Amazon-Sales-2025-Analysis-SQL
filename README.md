# Amazon Diwali Sales 2025 Analysis Using SQL
![Amazon](https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg)

## Project Overview

This project analyzes Amazon India's e-commerce sales data for 2025, featuring 15,000 synthetic transactions that simulate real-world purchasing behavior during the Diwali shopping season. Using advanced SQL techniques including CTEs, window functions, and complex aggregations, this analysis provides comprehensive insights into sales performance, customer behavior, payment preferences, delivery metrics, and regional market trends across Indian states.

## Dataset Information

**Data Source:**
- **Synthetic Dataset:** 15,000 e-commerce transactions
- **Time Period:** January 2025 - December 2025
- **Geographic Coverage:** Multiple Indian states
- **Purpose:** Educational analysis of e-commerce patterns

**Company Background:**
- **Platform:** Amazon India
- **Industry:** E-commerce & Retail
- **Market:** Indian consumer market
- **Focus:** Diwali shopping season sales patterns

**Key Columns (14 fields):**
1. **Order_ID:** Unique identifier for each order
2. **Date:** Order placement date
3. **Customer_ID:** Unique customer identifier
4. **Product_Category:** Main product category
5. **Product_Name:** Specific product within category
6. **Quantity:** Number of units ordered
7. **Unit_Price_INR:** Price per unit in Indian Rupees (₹)
8. **Total_Sales_INR:** Total sales value (Quantity × Unit_Price_INR)
9. **Payment_Method:** Payment mode used
10. **Delivery_Status:** Order status (Delivered, Pending, Returned)
11. **Review_Rating:** Customer product rating
12. **Review_Text:** Customer review sentiment
13. **State:** Indian state for delivery
14. **Country:** Order country (India)

## SQL Skills Demonstrated

This project showcases advanced SQL querying techniques:

### Core SQL Commands
- `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
- `DISTINCT`, `TOP`, `UNION ALL`

### Advanced Techniques
- **Common Table Expressions (CTEs):** WITH clause for complex multi-query analysis
- **Window Functions:** `OVER()`, `SUM() OVER()`, `COUNT() OVER()`
- **Aggregate Functions:** `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- **Type Conversions:** `CAST()` for decimal precision
- **Conditional Logic:** `CASE` statements for categorization
- **Date Functions:** `YEAR()`, `MONTH()`, `DATENAME()`, `DATEPART()`
- **Percentage Calculations:** Dynamic percentage computations
- **Complex Filtering:** Multiple WHERE conditions and subqueries

### Database Design Concepts
- Primary Keys (Order_ID)
- Foreign Keys (Customer_ID)
- Constraints and validation
- Clustered and Non-Clustered indexes
- Identity columns for auto-increment
- Unique key constraints

## Technical Implementation

### Database Setup
- **Platform:** Microsoft SQL Server Management Studio (SSMS)
- **Import Method:** Flat File Source (CSV import)
- **Data Cleaning:** Data type validation, NULL handling, constraint implementation
- **Optimization:** Indexed columns for performance

### Query Architecture
- **Single Comprehensive Query:** 15 CTEs combined with UNION ALL
- **Modular Design:** Each business question as separate CTE
- **Unified Output:** All results in single result set with report sections

## 15 Business Questions Analyzed

### BASIC SALES & PRODUCT ANALYSIS

#### 1. What are the top 10 products by total sales revenue (Total_Sales_INR)?
```sql
SELECT TOP 10 
    Product_Name,
    SUM(Total_Sales_INR) AS Total_Revenue,
    COUNT(*) AS Order_Count
FROM amazon_sales_2025_INR
GROUP BY Product_Name
ORDER BY Total_Revenue DESC
```

#### 2. Which product category generated the highest total revenue? Order by category.
```sql
SELECT 
    Product_Category,
    SUM(Total_Sales_INR) AS Total_Revenue,
    COUNT(*) AS Order_Count
FROM amazon_sales_2025_INR
GROUP BY Product_Category
ORDER BY Total_Revenue DESC
```

#### 3. What is the average Total_Sales_INR across all orders?
```sql
SELECT 
    AVG(Total_Sales_INR) AS Avg_Order_Value,
    MIN(Total_Sales_INR) AS Min_Order_Value,
    MAX(Total_Sales_INR) AS Max_Order_Value
FROM amazon_sales_2025_INR
```

#### 4. How many orders had a Total_Sales_INR greater than ₹100,000?
```sql
SELECT 
    COUNT(*) AS High_Value_Order_Count,
    SUM(Total_Sales_INR) AS Total_High_Value_Revenue
FROM amazon_sales_2025_INR
WHERE Total_Sales_INR > 100000
```

#### 5. What is the average quantity ordered per product category?
```sql
SELECT 
    Product_Category,
    AVG(Quantity) AS Avg_Quantity_Per_Category,
    SUM(Quantity) AS Total_Quantity
FROM amazon_sales_2025_INR
GROUP BY Product_Category
ORDER BY Avg_Quantity_Per_Category DESC
```

### CUSTOMER & GEOGRAPHIC ANALYSIS

#### 6. Which customers (Customer_ID) placed more than 5 orders? Count their orders.
```sql
SELECT 
    Customer_ID,
    COUNT(*) AS Order_Count,
    SUM(Total_Sales_INR) AS Total_Spent
FROM amazon_sales_2025_INR
GROUP BY Customer_ID
HAVING COUNT(*) > 5
ORDER BY Order_Count DESC
```

#### 7. What is the total sales revenue (Total_Sales_INR) for each state? Order by revenue descending.
```sql
SELECT 
    State,
    SUM(Total_Sales_INR) AS Total_Revenue,
    COUNT(*) AS Order_Count,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM amazon_sales_2025_INR
GROUP BY State
ORDER BY Total_Revenue DESC
```

#### 8. Which 5 states generated the highest total sales in 2025?
```sql
SELECT TOP 5
    State,
    SUM(Total_Sales_INR) AS Total_Revenue,
    COUNT(*) AS Order_Count,
    AVG(Total_Sales_INR) AS Avg_Order_Value
FROM amazon_sales_2025_INR
WHERE YEAR(Date) = 2025
GROUP BY State
ORDER BY Total_Revenue DESC
```

#### 9. How many unique customers placed orders from each state?
```sql
SELECT 
    State,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(*) AS Total_Orders
FROM amazon_sales_2025_INR
GROUP BY State
ORDER BY Unique_Customers DESC
```

### PAYMENT & DELIVERY ANALYSIS

#### 10. What percentage of orders used each payment method?
```sql
SELECT 
    Payment_Method,
    COUNT(*) AS Order_Count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage,
    SUM(Total_Sales_INR) AS Total_Revenue
FROM amazon_sales_2025_INR
GROUP BY Payment_Method
ORDER BY Order_Count DESC
```

#### 11. Count how many orders were Delivered, Pending, or Returned. What's the delivery success rate?
```sql
SELECT 
    Delivery_Status,
    COUNT(*) AS Status_Count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage,
    SUM(Total_Sales_INR) AS Total_Revenue
FROM amazon_sales_2025_INR
GROUP BY Delivery_Status
ORDER BY Status_Count DESC
```

#### 12. Which product categories have the highest number of returned orders?
```sql
SELECT 
    Product_Category,
    COUNT(*) AS Return_Count,
    SUM(Total_Sales_INR) AS Lost_Revenue,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Return_Percentage
FROM amazon_sales_2025_INR
WHERE Delivery_Status = 'Returned'
GROUP BY Product_Category
ORDER BY Return_Count DESC
```

#### 13. What is the average order value for Cash on Delivery orders vs digital payment methods?
```sql
SELECT 
    CASE 
        WHEN Payment_Method = 'Cash on Delivery' THEN 'Cash on Delivery'
        ELSE 'Digital Payments'
    END AS Payment_Type,
    AVG(Total_Sales_INR) AS Avg_Order_Value,
    COUNT(*) AS Order_Count,
    SUM(Total_Sales_INR) AS Total_Revenue
FROM amazon_sales_2025_INR
GROUP BY 
    CASE 
        WHEN Payment_Method = 'Cash on Delivery' THEN 'Cash on Delivery'
        ELSE 'Digital Payments'
    END
```

### TIME-BASED ANALYSIS

#### 14. What was the total sales revenue for each month in 2025? Identify peak sales months.
```sql
SELECT 
    YEAR(Date) AS Year_Val,
    MONTH(Date) AS Month_Val,
    DATENAME(MONTH, Date) AS Month_Name,
    SUM(Total_Sales_INR) AS Total_Revenue,
    COUNT(*) AS Order_Count,
    AVG(Total_Sales_INR) AS Avg_Order_Value
FROM amazon_sales_2025_INR
WHERE YEAR(Date) = 2025
GROUP BY YEAR(Date), MONTH(Date), DATENAME(MONTH, Date)
ORDER BY Month_Val
```

#### 15. What is the average review rating for each product category? Which categories have ratings above 4.0?
```sql
SELECT 
    Product_Category,
    AVG(Review_Rating) AS Avg_Rating,
    COUNT(*) AS Review_Count,
    MIN(Review_Rating) AS Min_Rating,
    MAX(Review_Rating) AS Max_Rating
FROM amazon_sales_2025_INR
WHERE Review_Rating IS NOT NULL
GROUP BY Product_Category
HAVING AVG(Review_Rating) > 4.0
ORDER BY Avg_Rating DESC
```

## Key Insights

### Sales Performance
- Comprehensive product and category revenue analysis reveals top performers
- High-value orders (>₹100,000) represent significant revenue concentration
- Average order values vary significantly across categories and payment methods

### Customer Behavior
- Repeat customer analysis identifies loyal customer segments
- Geographic distribution shows concentrated sales in specific states
- Customer purchase frequency patterns enable targeted marketing

### Payment & Delivery Metrics
- Payment method preferences indicate digital adoption rates
- Delivery success rates highlight operational efficiency
- Return patterns by category inform inventory and quality decisions
- COD vs digital payment value comparison guides payment strategy

### Regional Trends
- State-wise sales reveal geographic market opportunities
- Top revenue states guide expansion and marketing investment
- Customer density by state informs logistics optimization

### Temporal Patterns
- Monthly sales trends identify seasonal peaks (Diwali impact)
- Year-over-year patterns inform forecasting and planning
- Peak shopping periods guide inventory and staffing decisions

### Quality Metrics
- Review ratings by category indicate customer satisfaction
- High-rated categories (>4.0) demonstrate product-market fit
- Rating distribution guides quality improvement initiatives

## Files Included

- **`Amazon_Sales_Business_Solutions.sql`** - Comprehensive 15-query CTE analysis
- **`Amazon_Sales_Business_Problems.sql`** - All 15 business questions
- **`amazon_sales_2025_INR.csv`** - Original synthetic dataset
- **`amazon_sales_2025_INR_cleaned.csv`** - Cleaned and validated dataset
- **`README.md`** - This documentation file

## How to Use

### Setup Instructions

1. **Import Data into SSMS:**
   - Open SQL Server Management Studio
   - Right-click on database → Tasks → Import Flat File
   - Select `amazon_sales_2025_INR_cleaned.csv`
   - Configure data types (INR columns as DECIMAL, dates as DATE)

2. **Set Up Database Schema:**
   ```sql
   -- Create table with constraints
   ALTER TABLE amazon_sales_2025_INR
   ADD CONSTRAINT PK_Order_ID PRIMARY KEY (Order_ID);
   
   -- Add indexes for performance
   CREATE INDEX IDX_Date ON amazon_sales_2025_INR(Date);
   CREATE INDEX IDX_Customer_ID ON amazon_sales_2025_INR(Customer_ID);
   CREATE INDEX IDX_State ON amazon_sales_2025_INR(State);
   ```

3. **Run Analysis:**
   - Open `Amazon_Sales_Business_Solutions.sql`
   - Execute the comprehensive CTE query
   - Review results organized by report sections

4. **Individual Queries:**
   - Extract specific CTEs for targeted analysis
   - Modify WHERE clauses for custom filtering
   - Adjust date ranges for period-specific insights

## Learning Outcomes

This project demonstrates:

### SQL Proficiency
- Advanced query construction with CTEs and window functions
- Complex aggregation and percentage calculations
- Sophisticated date manipulation and time-series analysis
- Dynamic conditional logic with CASE statements

### Business Intelligence Skills
- E-commerce metrics analysis and KPI development
- Customer segmentation and behavioral analysis
- Geographic market analysis and regional insights
- Payment and delivery operations optimization
- Product performance and category analysis

### Database Management
- Table design with proper constraints and keys
- Index optimization for query performance
- Data cleaning and validation procedures
- Type conversion and data integrity maintenance

### Analytical Thinking
- Multi-dimensional business problem decomposition
- Metric selection for actionable insights
- Pattern recognition in sales and customer data
- Strategic recommendations from data analysis

## Future Enhancements

### Advanced SQL Techniques
- Implement recursive CTEs for customer lifetime value
- Add pivoting for cross-category comparisons
- Create stored procedures for automated reporting
- Develop user-defined functions for complex calculations

### Enhanced Analysis
- Customer cohort analysis and retention metrics
- Product recommendation analysis using association rules
- Time-series forecasting with SQL window functions
- Basket analysis for cross-selling opportunities

### Performance Optimization
- Implement materialized views for frequent queries
- Add columnstore indexes for large aggregations
- Partition tables by date for improved query speed
- Create computed columns for common calculations

### Integration & Visualization
- Connect to Power BI for interactive dashboards
- Export to Python for machine learning models
- Integrate with Tableau for visual analytics
- Create automated email reports with SQL Agent

### Business Expansion
- Add supplier and inventory data for supply chain analysis
- Include marketing campaign data for attribution modeling
- Integrate customer service data for satisfaction analysis
- Add competitor pricing data for market positioning

## Use Cases

### Business Strategy
- **Market Expansion:** Identify high-potential states and categories
- **Product Planning:** Optimize inventory based on sales patterns
- **Pricing Strategy:** Analyze price sensitivity by category
- **Customer Retention:** Target high-value repeat customers

### Operations
- **Delivery Optimization:** Reduce return rates by category
- **Payment Processing:** Optimize payment gateway costs
- **Logistics Planning:** Allocate resources based on state demand
- **Inventory Management:** Stock planning based on seasonal trends

### Marketing
- **Campaign Targeting:** Focus on high-revenue states and categories
- **Customer Segmentation:** Personalize offers based on behavior
- **Seasonal Planning:** Maximize Diwali and festival sales
- **Channel Optimization:** Allocate budget to effective payment methods

### Educational
- **SQL Training:** Learn advanced query techniques
- **E-commerce Analytics:** Understand online retail metrics
- **Data Analysis:** Practice business intelligence skills
- **Portfolio Development:** Demonstrate SQL proficiency

## Technical Notes

### Data Type Specifications
```sql
Order_ID: VARCHAR(50) PRIMARY KEY
Date: DATE
Customer_ID: VARCHAR(50)
Product_Category: VARCHAR(100)
Product_Name: VARCHAR(200)
Quantity: INT
Unit_Price_INR: DECIMAL(10,2)
Total_Sales_INR: DECIMAL(15,2)
Payment_Method: VARCHAR(50)
Delivery_Status: VARCHAR(50)
Review_Rating: DECIMAL(2,1)
Review_Text: TEXT
State: VARCHAR(100)
Country: VARCHAR(50)
```

### Query Performance Tips
- Use indexes on frequently filtered columns (Date, State, Customer_ID)
- Limit result sets with TOP when exploring data
- Avoid SELECT * in production queries
- Use EXISTS instead of IN for large subqueries
- Consider query execution plans for optimization

## Author

Created as part of SQL learning and portfolio development  
**GitHub:** [acsqlworks](https://github.com/acsqlworks)

## Acknowledgments

- **Dataset:** Synthetic Amazon India sales data (educational purposes)
- **Platform:** Microsoft SQL Server Management Studio
- **Inspiration:** Real-world e-commerce analytics challenges
- Data compiled and analyzed November 2025

## License

This project uses a synthetic dataset for educational purposes.  
Code and documentation available under MIT License.

---

*Note: This is an educational project using synthetic data for demonstrating SQL analysis skills. The dataset does not represent actual Amazon sales data and should not be used for business decisions.*

---

## Contact & Feedback

For questions, suggestions, or collaboration opportunities:
- **GitHub Issues:** Report bugs or request features
- **Pull Requests:** Contribute improvements
- **Discussions:** Share insights or ask questions

**Happy Querying! 📊🚀**

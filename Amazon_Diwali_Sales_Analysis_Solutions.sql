-- ============================================================================
-- COMPREHENSIVE AMAZON SALES 2025 ANALYSIS - 15 BUSINESS QUESTIONS
-- ============================================================================

WITH 

-- ============================================================================
-- BASIC SALES & PRODUCT ANALYSIS
-- ============================================================================

-- Question 1: What are the top 10 products by total sales revenue (Total_Sales_INR)?
TopSellingProducts AS (
    SELECT TOP 10 
        Product_Name,
        SUM(Total_Sales_INR) AS Total_Revenue,
        COUNT(*) AS Order_Count,
        'Top 10 Products by Revenue' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Product_Name
    ORDER BY Total_Revenue DESC
),

-- Question 2: Which product category generated the highest total revenue? Order by category.
CategoryPerformance AS (
    SELECT 
        Product_Category,
        SUM(Total_Sales_INR) AS Total_Revenue,
        COUNT(*) AS Order_Count,
        'Category Performance' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Product_Category
),

-- Question 3: What is the average Total_Sales_INR across all orders?
AverageOrderValue AS (
    SELECT 
        AVG(Total_Sales_INR) AS Avg_Order_Value,
        MIN(Total_Sales_INR) AS Min_Order_Value,
        MAX(Total_Sales_INR) AS Max_Order_Value,
        'Average Order Value' AS Analysis_Type
    FROM amazon_sales_2025_INR
),

-- Question 4: How many orders had a Total_Sales_INR greater than ₹100,000?
HighValueOrders AS (
    SELECT 
        COUNT(*) AS High_Value_Order_Count,
        SUM(Total_Sales_INR) AS Total_High_Value_Revenue,
        'Orders > 100000 INR' AS Analysis_Type
    FROM amazon_sales_2025_INR
    WHERE Total_Sales_INR > 100000
),

-- Question 5: What is the average quantity ordered per product category?
ProductQuantityDistribution AS (
    SELECT 
        Product_Category,
        AVG(Quantity) AS Avg_Quantity_Per_Category,
        SUM(Quantity) AS Total_Quantity,
        'Avg Quantity by Category' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Product_Category
),

-- ============================================================================
-- CUSTOMER & GEOGRAPHIC ANALYSIS
-- ============================================================================

-- Question 6: Which customers (Customer_ID) placed more than 5 orders? Count their orders.
CustomerPurchaseFrequency AS (
    SELECT 
        Customer_ID,
        COUNT(*) AS Order_Count,
        SUM(Total_Sales_INR) AS Total_Spent,
        'Customers with >5 Orders' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Customer_ID
    HAVING COUNT(*) > 5
),

-- Question 7: What is the total sales revenue (Total_Sales_INR) for each state? Order by revenue descending.
StateWiseSales AS (
    SELECT 
        State,
        SUM(Total_Sales_INR) AS Total_Revenue,
        COUNT(*) AS Order_Count,
        COUNT(DISTINCT Customer_ID) AS Unique_Customers,
        'State-wise Sales' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY State
),

-- Question 8: Which 5 states generated the highest total sales in 2025?
TopRevenueStates AS (
    SELECT TOP 5
        State,
        SUM(Total_Sales_INR) AS Total_Revenue,
        COUNT(*) AS Order_Count,
        AVG(Total_Sales_INR) AS Avg_Order_Value,
        'Top 5 States 2025' AS Analysis_Type
    FROM amazon_sales_2025_INR
    WHERE YEAR(Date) = 2025
    GROUP BY State
    ORDER BY Total_Revenue DESC
),

-- Question 9: How many unique customers placed orders from each state?
CustomerCountByState AS (
    SELECT 
        State,
        COUNT(DISTINCT Customer_ID) AS Unique_Customers,
        COUNT(*) AS Total_Orders,
        'Customers per State' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY State
),

-- ============================================================================
-- PAYMENT & DELIVERY ANALYSIS
-- ============================================================================

-- Question 10: What percentage of orders used each payment method?
PaymentMethodPreferences AS (
    SELECT 
        Payment_Method,
        COUNT(*) AS Order_Count,
        CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage,
        SUM(Total_Sales_INR) AS Total_Revenue,
        'Payment Method Distribution' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Payment_Method
),

-- Question 11: Count how many orders were Delivered, Pending, or Returned. What's the delivery success rate?
DeliverySuccessRate AS (
    SELECT 
        Delivery_Status,
        COUNT(*) AS Status_Count,
        CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage,
        SUM(Total_Sales_INR) AS Total_Revenue,
        'Delivery Status Distribution' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY Delivery_Status
),

-- Question 12: Which product categories have the highest number of returned orders?
ReturnsByCategory AS (
    SELECT 
        Product_Category,
        COUNT(*) AS Return_Count,
        SUM(Total_Sales_INR) AS Lost_Revenue,
        CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Return_Percentage,
        'Returns by Category' AS Analysis_Type
    FROM amazon_sales_2025_INR
    WHERE Delivery_Status = 'Returned'
    GROUP BY Product_Category
),

-- Question 13: What is the average order value for Cash on Delivery orders vs digital payment methods?
CODvsDigitalPayments AS (
    SELECT 
        CASE 
            WHEN Payment_Method = 'Cash on Delivery' THEN 'Cash on Delivery'
            ELSE 'Digital Payments'
        END AS Payment_Type,
        AVG(Total_Sales_INR) AS Avg_Order_Value,
        COUNT(*) AS Order_Count,
        SUM(Total_Sales_INR) AS Total_Revenue,
        'COD vs Digital Avg Value' AS Analysis_Type
    FROM amazon_sales_2025_INR
    GROUP BY 
        CASE 
            WHEN Payment_Method = 'Cash on Delivery' THEN 'Cash on Delivery'
            ELSE 'Digital Payments'
        END
),

-- ============================================================================
-- TIME-BASED ANALYSIS
-- ============================================================================

-- Question 14: What was the total sales revenue for each month in 2025? Identify peak sales months.
MonthlySalesTrends AS (
    SELECT 
        YEAR(Date) AS Year_Val,
        MONTH(Date) AS Month_Val,
        DATENAME(MONTH, Date) AS Month_Name,
        SUM(Total_Sales_INR) AS Total_Revenue,
        COUNT(*) AS Order_Count,
        AVG(Total_Sales_INR) AS Avg_Order_Value,
        'Monthly Sales 2025' AS Analysis_Type
    FROM amazon_sales_2025_INR
    WHERE YEAR(Date) = 2025
    GROUP BY YEAR(Date), MONTH(Date), DATENAME(MONTH, Date)
),

-- Question 15: What is the average review rating for each product category? Which categories have ratings above 4.0?
ReviewRatingAnalysis AS (
    SELECT 
        Product_Category,
        AVG(Review_Rating) AS Avg_Rating,
        COUNT(*) AS Review_Count,
        MIN(Review_Rating) AS Min_Rating,
        MAX(Review_Rating) AS Max_Rating,
        'Category Ratings Above 4.0' AS Analysis_Type
    FROM amazon_sales_2025_INR
    WHERE Review_Rating IS NOT NULL
    GROUP BY Product_Category
    HAVING AVG(Review_Rating) > 4.0
)

-- ============================================================================
-- COMBINE ALL RESULTS INTO ONE OUTPUT
-- ============================================================================

SELECT 
    'TOP_SELLING_PRODUCTS' AS Report_Section, 
    Product_Name AS Dimension, 
    Total_Revenue AS Metric1, 
    Order_Count AS Metric2, 
    NULL AS Metric3,
    NULL AS Metric4
FROM TopSellingProducts

UNION ALL

SELECT 
    'CATEGORY_PERFORMANCE', 
    Product_Category, 
    Total_Revenue, 
    Order_Count, 
    NULL,
    NULL
FROM CategoryPerformance

UNION ALL

SELECT 
    'AVERAGE_ORDER_VALUE', 
    'Overall Statistics', 
    Avg_Order_Value, 
    Min_Order_Value, 
    Max_Order_Value,
    NULL
FROM AverageOrderValue

UNION ALL

SELECT 
    'HIGH_VALUE_ORDERS', 
    'Orders > 100K INR', 
    High_Value_Order_Count, 
    Total_High_Value_Revenue, 
    NULL,
    NULL
FROM HighValueOrders

UNION ALL

SELECT 
    'PRODUCT_QUANTITY_DISTRIBUTION', 
    Product_Category, 
    Avg_Quantity_Per_Category, 
    Total_Quantity, 
    NULL,
    NULL
FROM ProductQuantityDistribution

UNION ALL

SELECT 
    'CUSTOMER_PURCHASE_FREQUENCY', 
    Customer_ID, 
    Order_Count, 
    Total_Spent, 
    NULL,
    NULL
FROM CustomerPurchaseFrequency

UNION ALL

SELECT 
    'STATE_WISE_SALES', 
    State, 
    Total_Revenue, 
    Order_Count, 
    Unique_Customers,
    NULL
FROM StateWiseSales

UNION ALL

SELECT 
    'TOP_REVENUE_STATES_2025', 
    State, 
    Total_Revenue, 
    Order_Count, 
    Avg_Order_Value,
    NULL
FROM TopRevenueStates

UNION ALL

SELECT 
    'CUSTOMER_COUNT_BY_STATE', 
    State, 
    Unique_Customers, 
    Total_Orders, 
    NULL,
    NULL
FROM CustomerCountByState

UNION ALL

SELECT 
    'PAYMENT_METHOD_PREFERENCES', 
    Payment_Method, 
    Order_Count, 
    Percentage, 
    Total_Revenue,
    NULL
FROM PaymentMethodPreferences

UNION ALL

SELECT 
    'DELIVERY_SUCCESS_RATE', 
    Delivery_Status, 
    Status_Count, 
    Percentage, 
    Total_Revenue,
    NULL
FROM DeliverySuccessRate

UNION ALL

SELECT 
    'RETURNS_BY_CATEGORY', 
    Product_Category, 
    Return_Count, 
    Lost_Revenue, 
    Return_Percentage,
    NULL
FROM ReturnsByCategory

UNION ALL

SELECT 
    'COD_VS_DIGITAL_PAYMENTS', 
    Payment_Type, 
    Avg_Order_Value, 
    Order_Count, 
    Total_Revenue,
    NULL
FROM CODvsDigitalPayments

UNION ALL

SELECT 
    'MONTHLY_SALES_TRENDS', 
    Month_Name, 
    Total_Revenue, 
    Order_Count, 
    Avg_Order_Value,
    Month_Val
FROM MonthlySalesTrends

UNION ALL

SELECT 
    'REVIEW_RATING_ANALYSIS', 
    Product_Category, 
    Avg_Rating, 
    Review_Count, 
    Min_Rating,
    Max_Rating
FROM ReviewRatingAnalysis

ORDER BY Report_Section, Metric1 DESC;

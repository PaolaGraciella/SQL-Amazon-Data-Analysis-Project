## ***Amazon USA Sales Analysis Project***

## **Difficulty level : Advanced**

I have worked on analyzing a dataset of over 20,000 sales records from an amazon e-commerce platform. This project involves extensive querying of customer behavior, product performance, and sales trends using postgreSQL. Through this project, i have trackled various SQL problems, including revenue analysis, customer segmentation, and inventory management. 

The project also focused on data cleaning, handling null values, and solving real-world business problems using structured queries. 

And ERD diagram is included to visually represent the database schema and relationships between tables. 

---

##**Database Setup & Design**

###**Schema Structure**
- The database contains **8 tables**: 'customers', 'sellers', 'products', 'orders', 'order_items', 'inventory', 'payments' and 'shippings'.
- These tables are designed with **primary keys**, **foreign key constraints**, and proper indexing to maintain data integrity and optimize query perfromance.
- You can find the SQL script for setting up the databse schema ![Capture d’écran 2025-02-16 201105](https://github.com/user-attachments/assets/4f37ee28-0a9f-4fd8-a245-b06d8ca91751)

### **Constraints**
- Referential integrity is enforced using foreign keys.
- Default values and dta types are applied where necessary to maintain consistency.
- Uniqueness is guaranteed for fields like 'product_id' , 'order_id', and 'customer_id'.

---

## **Task : Data cleaning**

I cleaned the dataset by: 
- **Removing duplicated**: duplicated in the customer and order tables were identified and removed.
- **Handling missing values**: Null values in critical fields (e.g., customer address, payment status) were either filled with default values or handled using appropriate methods.

____

## **Handling Null Values**

Null values were handled based on their context:
- **Customer addresses**: Misiing addresses were assigned default placeholder values.
- **Payment statuses**: Orders with null payment statuses were categorized as "Pending".
- **Shipping information**: Null return dates were left as is, as not all shipments are returned. 

## **Identifying Business Problems**
Key business problems identified :
- Low product availability due to inconsistend restocking.
- High return rates for specific product categories.
- Significant delays in shipments and inconsistencies in delivery times.
- High customer acquisition costs with a low customer retention rate.

## **Solving Business Problems**

### Solution Implemented: 
- **Restock Prediction**: By forecasting product demand based on past saled, I optimized restocking cycles, minimizing stockouts.
- **Product Performance** : Identified high-return products and optimized their sales strategies, such as product bundling and pricing adjustments.
- **Shipping Optimiztion**: Analyzed shipping times and delivery providers to recommend better logistics strategies and improve customer statisfaction.
- **Customer Segmentation**: Conducted RFM analysis to target marketing efforts towards "At-Risk" customers, improving retention and loyalty.

---

## **Objective**

The primary objective of this project is to showcase SQL proficiency through complex queries that address real-world e-commerce business challenges. The analysis covers various aspects of e-commerce operations, including: 
- customer behavior
- Sales trends
- Inventory management
- Payment and shipping analysis
- Forecasting and product performance

---

## **Learning Outcomes**

This project enabled me to: 
- Design and implement a normalized database schema.
- Clean and preprocess real-world datasets for analysis.
- Use advanced SQL techniques, including window functions, subqueries and joins.
- Conduct in-depth busimess analysis using SQL.
- Optimize query performance and handle large datasets efficiently.

## **Conclusion**

This advanced SQL project successfully demonstrates my ability to solve real-world e-commerce problems using structured queries. From improvinf customer retention to optimizing inventory and logistics, the project provides valuable insights into operational challenges and solutions. 
By completing this project, I have gained a deeper understanding of how SQL can be used to tackle complex data problmens and drive business decision-making. 

Analysis Questions Resolved
During the analysis, the following key questions were addressed using SQL queries and data analysis techniques:

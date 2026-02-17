🛒 E-Commerce Backend Database

A production-style relational database system that simulates the backend of an e-commerce platform (Amazon-lite).

This project demonstrates real-world database design, transactions, analytics, and performance optimization using SQL.

🚀 Features

User registration system

Product catalog with categories

Shopping cart management

Order processing with transactions

Inventory tracking & stock reduction

Payment recording

Product reviews

Sales analytics

Best-selling products reporting

Monthly revenue reports

User purchase history

🧠 Technical Highlights

Fully normalized relational schema

Foreign key integrity

ACID-compliant transactions

Stored procedures for business logic

Analytical reporting queries

Index optimization

Dashboard views

Performance-focused design

🗂 Project Structure
schema.sql            → database schema
seed_data.sql         → sample data
procedures.sql        → stored procedures
views.sql             → analytics dashboards
analytics_queries.sql → business reports
indexes.sql           → performance tuning

🧱 Database Architecture

The system models a real e-commerce backend with the following core entities:

Users

Products

Categories

Inventory

Carts

Orders

Order Items

Payments

Reviews

The design separates transactional data from analytical reporting to simulate production systems.

📊 Example Analytics

Best-selling products

Monthly revenue trends

Customer lifetime value

Inventory alerts

Revenue by category

Average product ratings

🔒 Transactions

Order placement uses database transactions to ensure:

stock consistency

atomic order creation

rollback on failure

This prevents overselling and maintains data integrity.

📚 Documentation

See /docs/design_explanation.md for detailed schema reasoning and architecture decisions.

🎯 Purpose

This project was built as a portfolio piece to demonstrate backend database engineering skills including:

relational modeling

SQL optimization

transactional safety

business analytics

production-style design

🧑‍💻 Author

Nicholas Florczyk

📌 Status

In development — new features and optimizations are being added.

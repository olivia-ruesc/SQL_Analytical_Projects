# Database Design Foundations

## Overview

This project demonstrates relational database design, implementation, and application-layer integration through a healthcare treatment scheduling system. The database models relationships between doctors, patients, hospitals, treatments, and treatment schedules.
The project highlights core database development concepts including schema design, data population, indexing, view creation, and programmatic interaction using Java.
 
---

## Project Objectives
- Design a normalized relational database schema
- Implement SQL scripts to create and populate tables
- Improve performance through indexing
- Create SQL views to simplify complex queries
- Demonstrate database interaction using Java
- Document entity relationships and design decisions

## Database Structure

The system consists of five related tables:
- Doctors – Stores provider and professional information
- Patients – Contains patient demographic and identifying data
- Hospitals – Represents healthcare facilities
- Treatments – Defines medical procedures and services
- Treatment Schedule – Connects patients, doctors, hospitals, and treatments while storing scheduling details

---

## Key Features
- Schema Design
- Relational schema built using normalization principles
- Foreign keys enforce referential integrity
- ER diagram visually documents entity relationships

### Data Population
- Synthetic, realistic data generated using Mocaroo
- Data inserted using SQL scripts to simulate real-world healthcare datasets

### Indexing
Indexes were created on selected columns to improve query performance, particularly for joins and filtering operations.

### View Creation
Custom SQL views were developed to:
- Simplify multi-table joins
- Support reporting and data retrieval
- Improve query readability and maintainability

### Java Database Integration
Java programs demonstrate application-level interaction with the database, including:
- Establishing database connections using JDBC
- Inserting records programmatically
- Querying and retrieving table data
- Displaying structured query results
This demonstrates how relational databases integrate with software systems in real-world applications.

---

## Technologies Used
- SQL
- Relational Database Design
- Mocaroo
- Java
- JDBC
- ER Modeling

## Skills Demonstrated
- Data Modeling and Schema Design
- Relational Database Implementation
- Query Optimization
- View Construction for Reporting
- Backend Data Integration
- Technical Documentation

---

## Author
### Olivia Rueschhoff
Master of Science in Mathematics
Bachelor of Science in Mathematics with an Emphasis in Data Science and Statistics
Minor in Computer Science – Algorithms and Data Structures

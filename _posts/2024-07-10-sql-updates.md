---
title: Add Required column to existing SQL Database Table
date: 2024-07-10 10:46:00 +0100
categories: [Templates, sql]
tags: [alter,sql]     # TAG names should always be lowercase
---

When working with SQL databases, there might be times when you need to add a new column to an existing table. If this column is meant to be mandatory (i.e., it cannot be NULL), you need to ensure that all existing rows have a default value before enforcing the NOT NULL constraint. Here’s a simple step-by-step template to accomplish this.

```sql
-- Add the new column (allowing NULLs initially)
ALTER TABLE <table_name>
ADD <column_name> <sql_type> NULL
GO

-- Populate the new column with a default value
UPDATE <table_name> SET <column_name> = <default_value>

-- Alter the column to make it NOT NULL
ALTER TABLE <table_name>
ALTER COLUMN <column_name> <sql_type> NOT NULL
GO
```

#### Example

Let’s see a practical example. Suppose we have a table called `employees`, and we want to add a new column named `hire_date` of type `DATE`, and we want to set the default value to `GETDATE()`. Here’s how we can do it:

```sql
-- Step 1: Add the new column
ALTER TABLE employees
ADD hire_date DATE NULL
GO

-- Step 2: Populate the new column with the default value
UPDATE employees SET hire_date = GETDATE()

-- Step 3: Alter the column to make it NOT NULL
ALTER TABLE employees
ALTER COLUMN hire_date DATE NOT NULL
GO
```

#### Conclusion

Adding a required new column to an existing SQL table involves a few careful steps to avoid errors and ensure data integrity. By initially allowing NULLs, populating the column with default values, and then enforcing the NOT NULL constraint, you can seamlessly introduce new required columns to your database schema.

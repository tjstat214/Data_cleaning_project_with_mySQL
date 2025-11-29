/* DATA CLEANING PRACTISE OF LEARNING_WITH_CONFIDENCE_COMMUNITY BY TIJANI TAIWO AKANNI
        
	Business Problem: TechSolutions Ltd. needs help in improving the quality of their project tracking database to better manage 
    resources, budgets, and project timelines. This will help them make more informed decisions. They have observed a significant
    amount of inconsistent and missing data in their tracking system.
    
*/
/* -- Creating a new database (lwc_data_cleaning) for the project
CREATE DATABASE lwc_data_cleaning;

-- Navigating to the database
USE lwc_data_cleaning ;   					*/

-- Checking the imported raw data
SELECT * 
FROM tech_solutions_data;

-- Creating a copy of the data imported and name it raw_data. This is to ensure the primary data remain safe
CREATE TABLE raw_data
SELECT * 
FROM tech_solutions_data;

-- DATA CLEANING BEGIN.................................................... 

-- Changing some of imported columns datatypes, leaving the date for later transformation. 
ALTER TABLE raw_data
MODIFY COLUMN project_id VARCHAR(22);

ALTER TABLE raw_data
MODIFY COLUMN project_name VARCHAR(55);

ALTER TABLE raw_data
MODIFY COLUMN project_manager VARCHAR(55);

ALTER TABLE raw_data
MODIFY COLUMN team_members VARCHAR(55);

ALTER TABLE raw_data
MODIFY COLUMN status VARCHAR(55);

ALTER TABLE raw_data
MODIFY COLUMN budget DECIMAL(15,4) ;

ALTER TABLE raw_data
MODIFY COLUMN expenditure DECIMAL(15,4) ;	

ALTER TABLE raw_data
MODIFY COLUMN client VARCHAR(55);

-- End of modifying data types.............  

-- TASK 1. Remove Duplicate Records: Find and remove duplicate rows where all column values match. 

-- Checking for duplicates records
SELECT *,
 COUNT(*) AS count
FROM raw_data
GROUP BY 1,2,3,4,5,6,7,8,9,10 			-- Grouping by all columns in the table
HAVING count > 1  ;

-- THERE IS NO DUPLICATE FOUND IN THE DATASET. 

-- TASK 2. Remove Invalid Values: Remove Invalid Values: Remove any rows with invalid or negative values in budget or expenditure.
SELECT *
FROM raw_data
WHERE budget <= 0 OR expenditure <= 0 ; -- checking for negative values in budget/expenditure

-- Deleting rows with negative values in budget/expenditure
DELETE FROM raw_data
WHERE budget <= 0 OR expenditure <= 0 ;

/* TASK 3. Handle Missing Values:
 ○ Check for missing values in columns such as end_date, budget, expenditure, and team_members.
 ○ For end_date, fill in missing values where applicable or set a default value (e.g., ‘N/A’).
 ○ For budget and expenditure, fill missing values with the average of those columns. 				*/
 
  -- Checking for missing Values in column end_date
SELECT *
FROM raw_data
WHERE end_date IS NULL;

-- inputing N/A for missing values in end_date
UPDATE raw_data
SET end_date = 'N/A'
WHERE end_date IS NULL ;

-- Handling the missing values in budget columns
SELECT *
FROM raw_data
WHERE budget IS NULL ;  -- Checking for budget with NULL values 

-- Finding average Budgets
SELECT AVG(budget)
FROM raw_data;

-- Creating CTE table to display budget with NULL values and corresponding AVG_budget. 
WITH budget_cte AS (
SELECT *,
		CASE
		WHEN budget IS NULL THEN AVG(budget) OVER ()
		ELSE budget
		END new_budget
FROM raw_data )
SELECT * 
FROM budget_cte 
WHERE budget IS NULL ;

-- Updating my table by changing NULL values in budget column to the calculated AVG_budget_value

SET @avg_budget = (SELECT AVG(budget) FROM raw_data); -- Creating a user-defined variable @avg_budget

UPDATE raw_data
SET budget = @avg_budget
WHERE budget IS NULL; -- Setting NULL budget to the defined variable created(avg_budget);

-- Handling Missing Values In Expenditure column
SELECT * FROM raw_data
WHERE expenditure IS NULL OR expenditure = " ";  -- looking into the expenditure with missing values

SELECT AVG(expenditure)
FROM raw_data; 				-- Calculating average expenditure

SET @avg_expenditure = (SELECT AVG(expenditure) FROM raw_data); -- setting avg_expenditure variable as USER_defined_variable.

-- Creating CTE table to display expenditure with NULL values and corresponding AVG_expenditure.
WITH expenditure_cte AS (
SELECT *,
		CASE
		WHEN expenditure IS NULL THEN AVG(expenditure) OVER () 
        ELSE expenditure
		END AS expenditure1
FROM raw_data )
SELECT *
FROM expenditure_cte 
WHERE expenditure IS NULL;

UPDATE raw_data
SET expenditure = @avg_expenditure
WHERE expenditure IS NULL ; -- Setting NULL expenditure to the defined variable created(avg_expenditure)


-- Identifying team_members with NULL or empty VALUES
SELECT * FROM raw_data
WHERE team_members IS NULL OR team_members = " ";

-- UPDATing the team_members column to change NULL values to  ' No Team assigned '
UPDATE raw_data
SET team_members = 'No Team assigned'
WHERE team_members IS NULL ;

/* TASK 4. Standardize Text Data:
 ○ Clean any leading/trailing whitespaces in project_manager and status.
 ○ Standardize values in the status column (e.g., make all statuses consistent like 'Completed' instead of 'completd').
 ○ Standardize capitalization for project_name, team_members, and client fields									*/
 
-- Checking and Cleaning any leading/trailing whitespaces in project_manager column
 SELECT project_manager,
 TRIM( project_manager)
 FROM raw_data ;								-- The checking

UPDATE raw_data
SET project_manager = TRIM( project_manager) ;	-- The cleaning

-- Checking and Cleaning any leading/trailing whitespaces in status column
 SELECT status,
 TRIM(status)
 FROM raw_data ;

UPDATE raw_data
SET status = TRIM(status);

-- Standardize values in the status column (e.g., make all statuses consistent like 'Completed' instead of 'completd')
SELECT DISTINCT status 			-- Checking for unique value in status column
FROM raw_data ;

UPDATE raw_data
SET status = 'Pending'
WHERE status = 'pennding' ;		-- Changing all pennding values to Pending

-- Standardize capitalization for project_name, team_members, and client fields. 
SELECT project_name,
team_members,
`client`
FROM raw_data ;    							-- the data is already in standardize capitalization

/* TASK 5. Fix Date Format:
○ Convert all date columns (start_date, end_date) to a consistent date format (e.g., 'YYYY-MM-DD').
○ Check for invalid date entries and correct them.   	*/
   
-- Looking into start and end date in the dataset
SELECT start_date, end_date
FROM raw_data ;
    
-- Modifying Start_date to normal date format
SELECT start_date, str_to_date( start_date, "%m/%d/%Y %H:%i")
FROM raw_data ;
    
UPDATE raw_data
SET start_date = str_to_date( start_date, "%m/%d/%Y %H:%i") ;

-- Changing Start_date column from text to DATETIME data types in the new table created. 
ALTER TABLE raw_data
MODIFY COLUMN start_date DATETIME ;

-- Modifying end_date to normal date format
SELECT end_date, str_to_date( end_date, "%m/%d/%Y %H:%i")
FROM raw_data ;
  
  -- Setting Missing values ( N/A) in end_date to null
UPDATE raw_data
SET end_date = NULL
WHERE end_date = 'N/A';

-- Standardizing The end_date column to DATETIME format
UPDATE raw_data
SET end_date = str_to_date( end_date, "%m/%d/%Y %H:%i") ;

SELECT *
FROM raw_data ;

-- Changing end_date data type from text to DATETIME format
ALTER TABLE raw_data
MODIFY COLUMN end_date DATETIME;


    /* TASK 6. Create a Data Quality Flag: ○ Add a new column data_quality_flag that marks rows with missing or
		incorrect data (e.g., a '1' for rows with missing values). */
        
-- Creating data_quality Column plus the raw_data table 
SELECT *,
		CASE
		WHEN (project_id IS NULL) OR (project_manager IS NULL) OR (start_date IS NULL)
            OR (end_date IS NULL) OR (project_name IS NULL) OR (team_members IS NULL) OR (status IS NULL)
            OR (budget IS NULL) OR (expenditure IS NULL) OR  (client IS NULL) 
		THEN 1
		ELSE 0
		END AS data_quality_flag
FROM raw_data;

-- Creating CTE with the querry above 
WITH data_quality_CTE AS (
SELECT *,
		CASE
		WHEN (project_id IS NULL) OR (project_manager IS NULL) OR (start_date IS NULL)
            OR (end_date IS NULL) OR (project_name IS NULL) OR (team_members IS NULL) OR (status IS NULL)
            OR (budget IS NULL) OR (expenditure IS NULL) OR  (client IS NULL) 
		THEN 1
		ELSE 0
		END AS data_quality_flag
FROM raw_data)
SELECT * 
FROM data_quality_CTE;

 -- Creating New table(transformed) with the result above.
 CREATE TABLE transformed
 WITH data_quality_CTE AS (
SELECT *,
		CASE
		WHEN (project_id IS NULL) OR (project_manager IS NULL) OR (start_date IS NULL)
			OR (end_date IS NULL) OR (project_name IS NULL) OR (team_members IS NULL) OR (status IS NULL)
            OR (budget IS NULL) OR (expenditure IS NULL) OR  (client IS NULL) 
		THEN 1
		ELSE 0
		END AS data_quality_flag
FROM raw_data)
SELECT * 
FROM data_quality_CTE;

/* TASK 7. Standardize Project Status: Make sure all statuses are either ‘Active’, ‘Completed’, or ‘Pending’. 
									Any other status should be replaced with 'Pending' 					*/

-- Displaying the unique values in the status column
SELECT DISTINCT status
FROM transformed ;

-- Updating the status column, changing all Cancelled values to Pending
UPDATE transformed
SET status = 'Pending'
WHERE status = 'Cancelled' ;

/* 8. Normalize Revenue Data: ○ Convert all monetary values (e.g., budget, expenditure) to the same currency or scale (e.g., millions).  */

SELECT budget,
expenditure					-- looking into budget and expenditure columns
FROM transformed ;

-- This transformation have been done at the beginning of the data cleaning. 		

SELECT * 
FROM transformed;

-- THE END OF THE DATA CLEANING!!....................................... 







































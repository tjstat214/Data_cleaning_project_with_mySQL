# Data_cleaning_project_with_mySQL
This project focuses on practicing and demonstrating advanced SQL data cleaning and manipulation skills.


## Project Goals: 
To significantly improve the quality and consistency of the datasets. project tracking database by addressing missing values, removing duplicates, standardizing formats, and correcting inconsistent entries. This prepares the data for accurate analysis.


## Data Source:
**Source:** Simulated project tracking database for TechSolutions Ltd, a fictional company specializing in developing software products and services.


### Initial Condition:
The dataset is "dirty" due to internal mismanagement and inconsistent data collection methods. It contains a significant amount of inconsistent and missing data.  
Initial row: 1800 rows  
Initial columns: 10 columns


 ### Dataset Columns Description:
 1. project_id (INT)– ID of the project
 2. project_name (VARCHAR)– Name of the project
 3. start_date (DATE)– Date when the project started
 4. end_date (DATE)– Date when the project was completed (nullable)
 5. project_manager (VARCHAR)– Name of the project manager
 6. team_members (VARCHAR)– Team members involved in the project(comma-separated)
 7. status (VARCHAR)– Current status of the project
 8. budget (FLOAT)– Budget allocated for the project
 9. expenditure (FLOAT)– Money spent on the project
 10.client (VARCHAR)– Name of the client company


## Tools Used: 
MySQL

## Key Cleaning Steps:
* Remove Duplicate Records 
* Handle Missing Values
* Standardize Text Data
* Fix Date Format
* Remove Invalid Values
* Fill or Remove Empty Columns
* Create a Data Quality Flag:
* Standardize Project Status
* Normalize Revenue Data
  










# Project Structure and Usage Guide

This project is structured to facilitate automation testing using the Robot Framework. Below is an overview of the project's directory structure and instructions on how to run the tests.

## Project Structure

The project consists of the following directories and files:

### Resources: 

#### Keyword definition: 
Holds the step definitions for test cases.

#### Test data: 
Stores element locators in a YAML file.

#### Utils and Custom Lib: 
Contains utility functions and a python file for custom library.

#### Tests: 
Contains the test case files.

### Results: 
This directory is generated after test execution and contains the test report and log files.

#### requirements.txt: 
Lists the required Python libraries for running the tests.

#### run_tests.sh: 
A shell script to automate the installation of requirements and execution of tests.

## Running the Tests

Before running the tests, ensure that Python and pip are installed on your system. Additionally, the required libraries specified in requirements.txt must be installed.

### Manual Execution
To manually run the tests:

1. Install required libraries using pip:

pip install -r requirements.txt

2. Execute the tests using the following command:

robot --outputdir results tests

This command will execute the tests and generate the report and log files in the results directory.

### Automated Execution (Using run_tests.sh)

Alternatively, you can use the provided shell script for automated execution:

1. Run the shell script 

This script will automatically install the required libraries and execute the tests. After the test run, the report and log files will be generated in the results directory.
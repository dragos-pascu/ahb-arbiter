# AHB Arbiter Verification Environment

## Description

This repository contains a comprehensive UVM-compliant verification environment designed for robust testing of an Advanced High-Performance Bus (AHB) arbiter. Our key focuses include:

- **Priority-Based Master Selection**: Ensures the arbiter selects the correct master based on priority.
- **AHB Protocol Adherence**: Verifies compliance with the AHB protocol standards.
- **Data Integrity Verification**: Ensures data is accurately transmitted and received without errors.

## Verification Plan

The verification plan is detailed and includes:

- **High-Level Overview**: A summary of the verification objectives and strategies.
- **Detailed Architecture**: Insights into the structural design of the verification environment.
- **Checkers Plan**: A list of checkers used to ensure protocol compliance and data integrity.
- **Coverage Metrics**: Metrics to evaluate the thoroughness of the testing process.
- **Diverse Test Suite**: A variety of tests, including:
  - Basic Tests
  - Random Tests
  - Error Tests
  - Direct Tests

For more in-depth information, including file structure, code snippets, diagrams, and tables from the verification plan, please refer to the bachelor's thesis document, which is presented in Romanian.

## How to Run Simulations

To start the simulation, navigate to the desired directory and execute the appropriate script:

### Command-Line Interface (CLI) & Graphical User Interface (GUI):

```bash
cd sim/cli_run
./run.sh
#
cd sim/gui_run
./gui_run.sh




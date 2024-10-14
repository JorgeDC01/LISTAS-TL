# LISTAS Language Translator - Language Theory Project

This repository contains the implementation of a project developed for the **Language Theory** course. The goal is to build a translator for a custom language called **LISTAS**, which facilitates working with different types of lists, variables, and instructions in a structured way. This project was divided into multiple phases to ensure efficient development and proper functionality.

## Project Overview

The objective of the project is to create a translator for the **LISTAS** language. **LISTAS** allows users to define and manipulate lists and variables easily through a block-structured program. The language is divided into sections where lists, variables, and instructions are defined. These sections are further broken down to facilitate the design and execution of programs.

### Key Features of the **LISTAS** Language:
- Block-based structure for defining lists, variables, and instructions.
- Easy-to-use syntax for list creation, manipulation, and execution of operations.
- A formal grammar to recognize programs written in **LISTAS**.
- Semantic controls to manage lists, variables, and potential errors.

### Development Phases:
The project was divided into four main phases:
1. **Phase 1 - Formal Language Generation**:
   - Identification of reserved words like `LISTAS`, `VARIABLES`, `INICIO`, `FIN`, and more.
   - Design of a formal grammar that allows recognition of **LISTAS** programs.
   
2. **Phase 2 - Data Structures Creation**:
   - Development of data structures to handle lists, variables, and their relationships.
   - Introduction of a **Set of Lists** structure to store and manage lists, and a **Symbol Table** to track declared variables.

3. **Phase 3 - Error Handling**:
   - Addition of error handling and semantic checks to ensure correct execution.
   - Generation of C++ code as an output representing the operations in **LISTAS**.

4. **Phase 4 - Documentation**:
   - Detailed documentation of design decisions and language specifications, summarizing the functionality and use of the **LISTAS** language.

## Data Structures

Two main data structures are implemented in the project:

1. **Set of Lists**:
   - Handles the creation, storage, and management of lists.
   - Lists can contain integers, floats, booleans, or identifiers.
   - Lists are represented using a dynamic vector (`IVector`) and include metadata like the list name, number of elements, and element type.

2. **Symbol Table**:
   - Stores and manages variables declared in **LISTAS**.
   - Variables can be of types: integer, float, boolean, or list.
   - Tracks the type, name, and value of each variable and provides operations for insertion, search, and display.

## Operations

The **LISTAS** language supports various operations on lists and variables:

### List Operations:
- **Initialize**: Creates a new empty list.
- **Insert**: Adds an element to a list if the types match.
- **Is Empty**: Checks if a list is empty.
- **Show List**: Displays a list’s contents.
- **Change List Name**: Updates the list's name.
- **Create List from Range**: Generates a list of numbers within a specified range.

### Symbol Table Operations:
- **Initialize**: Clears the symbol table.
- **Insert**: Adds a new variable to the table or updates its value.
- **Search**: Looks up a variable by name and returns its details.
- **Show Identifiers**: Displays all declared variables.

## Error Handling and Output Generation

To ensure proper execution, several modules are responsible for handling errors and generating the output code in C++. Some key features include:
- Checking for semantic errors, such as type mismatches or invalid operations.
- Translation of boolean values (`true`, `false`) to human-readable output (`"cierto"`, `"falso"`).
- Generation of C++ code before and after processing the **LISTAS** program.
- Implementation of common list functions such as `first()`, `last()`, and `nth()` for list manipulation.

## Running the Translator

To execute the translator, use the provided input files written in **LISTAS**. The translator will process these files and generate a C++ output.

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/LISTAS-translator.git
   cd LISTAS-translator
   
2. Compile and run the translator:
   ```bash
   make
   ./translator input_file.txt

3. The output will be a C++ file representing the program written in LISTAS.

## Conclusion
This project has provided valuable insight into the process of developing a programming language from scratch, including grammar design, semantic checking, and error handling. It also highlighted the complexities involved in building formal languages and translators. Through this project, we gained practical experience in creating a programming language and understanding the theoretical foundations behind it.

# Full Stack Product Management App (Flutter + Express.js + SQL Server)
# This repository contains the full source code for a complete CRUD (Create, Read, Update, Delete) system for managing products, built for an internship coding test.

# Backend: Node.js with Express.js, connected to a Microsoft SQL Server database.
# Frontend: Flutter application using Provider for state management.

# Repository Structure
- The repository is organized into two main folders, backend and frontend, along with the  necessary configuration and database scripts.

.CRUD APP
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   │   └── product.controller.js
│   │   ├── routes/
│   │   │   └── product.routes.js
│   │   ├── app.js
│   │   ├── config.js
│   │   └── db.js
│   ├── .env
│   └── package.json
│
├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   │   └── product.dart
│   │   ├── providers/
│   │   │   └── product_provider.dart
│   │   ├── screens/
│   │   │   ├── add_edit_product_screen.dart
│   │   │   └── product_list_screen.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   └── main.dart
│   └── pubspec.yaml
│
├── SQLQuery_1.sql
└── README.md

# API Base URL
- The backend REST API runs: http://localhost:3000/products

# Setup & Run Instructions
Follow these steps to get both the backend and frontend applications running.

+ Prerequisites
    - Node.js (v14 or higher)
    - An running instance of Microsoft SQL Server (Docker )
    - Flutter SDK (v3.0 or higher)
    - A code editor like VS Code
    - A SQL management tool like Azure Data Studio or SSMS

1. Database Setup
    + Using your SQL management tool, connect to my database instance.
    + Create a new database for the project.
        - CREATE DATABASE product_db;

    + Run the entire script provided in SQLQuery_1.sql against the new product_db database. This will create the PRODUCTS table and insert sample data.

2. Backend Setup (Node.js + Express)
    + Navigate to the backend directory:
        - cd backend
    + Install dependencies:
        - npm install
    + Configure environment variables:
        - Create a .env file 
        - Open the new .env file and fill in your SQL Server credentials. Ensure DB_DATABASE is set to product_db.
    + Start the backend server:
        - npm start
        The terminal should display Server is running on port 3000. Keep this terminal running.

3. Frontend Setup (Flutter)
    + Open a new terminal window.
    + Navigate to the frontend directory:
        - cd frontend
    + Install dependencies:
        - flutter pub get
    + Configure API Connection:
        - Open the file frontend/lib/services/api_service.dart.
        - Ensure the _baseUrl variable is correct for your target platform:
            - For iOS Simulator or Web: static const String _baseUrl = 'http://localhost:3000';
            - For Android Emulator: static const String _baseUrl = 'http://10.0.2.2:3000';
    + Run the app:
        - flutter run
     The Flutter application should now launch and connect to the running backend server.



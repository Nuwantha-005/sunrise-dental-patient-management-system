# Sunrise Dental Clinic – Patient Management System

## Overview

Sunrise Dental Clinic Patient Management System is a Java-based web application developed to manage the daily operations of a dental clinic. The system provides functionality for administrators, receptionists and patients, including patient management, appointment scheduling, dentist and treatment management, billing, reporting and patient portal access.

## Main Features

- Staff authentication and role-based access
- Patient registration and management
- Appointment booking and management
- Appointment conflict detection
- Dentist schedule availability validation
- Dentist management
- Treatment management
- Billing and receipt generation
- Reports and analytics
- Automated appointment confirmation emails
- Patient Portal
- Patient appointment and billing history
- Session-based authentication
- Remember Patient ID cookie functionality
- Contact message management
- Password hashing and authentication
- JUnit automated testing

## Technologies Used

- Java
- JSP
- Jakarta Servlets
- HTML5
- CSS3
- JavaScript
- MySQL
- JDBC
- Apache Tomcat
- JUnit 6
- Eclipse IDE
- Git and GitHub

## Architecture

The application follows a three-tier architecture:

1. **Presentation Tier** – JSP, HTML, CSS and JavaScript
2. **Application / Control Tier** – Java Servlets and supporting utility classes
3. **Data Access Tier** – DAO classes, JDBC and MySQL

The project also applies design approaches including:

- Model-View-Controller (MVC)
- Data Access Object (DAO)
- Intercepting Filter
- Centralized Database Connection Management

## User Roles

### Administrator

The Administrator can access administrative and management functionality, including:

- Manage patients
- Manage appointments
- Manage dentists
- Manage treatments
- Manage receptionist/staff accounts
- Generate bills
- View reports and analytics
- View contact messages

### Receptionist

The Receptionist can perform day-to-day clinic operations, including:

- Register and manage patients
- Book and manage appointments
- Check dentist availability
- Generate patient bills
- View appointment information
- View contact messages

### Patient

Patients can use the Patient Portal to:

- Log in using their portal credentials
- View profile information
- View appointment details and history
- View billing and receipt information

## Database

The application uses MySQL for persistent data storage.

Database scripts are available in the:

`database/`

directory.

These scripts can be used to create and configure the required database tables.

## Local Configuration

Sensitive configuration files are intentionally excluded from the GitHub repository.

Create the following files locally:

`src/main/resources/db.properties`

`src/main/resources/email.properties`

The `db.properties` file should contain the local MySQL connection configuration.

The `email.properties` file should contain the SMTP configuration required for appointment confirmation emails.

> Do not commit database passwords or email credentials to GitHub.

## Running the Application

1. Clone the repository.
2. Import the project into Eclipse.
3. Configure Apache Tomcat.
4. Create the MySQL database using the provided SQL scripts.
5. Configure `db.properties`.
6. Configure `email.properties` if email functionality is required.
7. Add the required MySQL Connector/J dependency.
8. Clean and build the project.
9. Run the application on the configured Tomcat server.
10. Open the application in a web browser.

## Automated Email Notification

After a successful appointment booking, the system can send an appointment confirmation email to the patient's registered email address.

The confirmation email contains appointment information and information required for accessing the Patient Portal.

## Testing

The project includes automated JUnit tests for DAO, model and utility components.

Main test groups include:

- UserDAO Integration / CRUD Tests
- PatientDAO Integration / CRUD Tests
- AppointmentDAO Integration / CRUD Tests
- BillDAO Integration / CRUD Tests
- Patient Model Tests
- Appointment Model Tests
- PasswordUtil Tests
- DBConnection Utility Tests

The completed JUnit test suite executed:

**50/50 tests passed – 0 failures – 0 errors**

## Security

The application includes:

- Password hashing
- Session-based authentication
- Authentication filtering
- Input and business-rule validation
- Appointment conflict detection
- Sensitive configuration exclusion through `.gitignore`

For production deployment, additional security improvements such as HTTPS, secure cookie attributes, connection pooling and one-time patient account activation should be considered.

## Version Control

Git and GitHub were used throughout development. Features were committed incrementally to maintain a clear history of project development.

## Future Improvements

Possible future improvements include:

- RESTful API integration
- SMS appointment reminders
- PDF/Excel report export
- Advanced reporting and charts
- Database connection pooling
- Additional automated integration testing
- One-time patient portal account activation
- Multi-branch clinic support

## Author

**Nuwantha Herath**

Software Engineering Undergraduate

## Academic Project

This system was developed as an academic software engineering project for the Sunrise Dental Clinic case study.

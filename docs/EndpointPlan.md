 RaceDay API Endpoint Plan

**Student:** Mashudu Junior Ramabulana
**Student Number:** ST10453352

This document outlines the RESTful API endpoints required for the RaceDay platform. It follows standard HTTP methods and uses JSON for request and response bodies. Authentication is handled via JWT (JSON Web Tokens) passed in the Authorization header.

 1. Authentication & User Management

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/auth/register` | Registers a new user (Organiser or Participant). Validates email uniqueness. | None (Public) | `{ "firstName": "John", "lastName": "Doe", "email": "john@test.com", "password": "SecurePassword123", "role": "Participant" }` | **201 Created:** User object. <br>**400 Bad Request:** Email already exists or validation failed. |
| **POST** | `/api/auth/login` | Authenticates a user and returns a JWT token. | None (Public) | `{ "email": "john@test.com", "password": "SecurePassword123" }` | **200 OK:** `{ "token": "eyJhbG...", "user": { ... } }` <br>**401 Unauthorized:** Invalid credentials. |
| **GET** | `/api/users/profile` | Retrieves the profile details of the currently logged-in user. | Any (Logged in) | None | **200 OK:** User profile object. <br>**401 Unauthorized** if token is missing/invalid. |
| **PUT** | `/api/users/profile` | Updates the profile details (name, email) of the logged-in user. | Any (Logged in) | `{ "firstName": "John", "lastName": "Smith", "email": "new@test.com" }` | **200 OK:** Updated user object. <br>**400 Bad Request:** Invalid data. |

 2. Event Management

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/events` | Retrieves a list of all upcoming events. Supports optional query parameters for filtering (e.g., `?location=Cape Town`). | None (Public) | None | **200 OK:** Array of event objects. |
| **GET** | `/api/events/{id}` | Retrieves detailed information for a specific event, including its categories and route info. | None (Public) | None | **200 OK:** Detailed event object. <br>**404 Not Found:** Event does not exist. |
| **POST** | `/api/events` | Creates a new event. The `OrganiserID` is automatically extracted from the JWT token. | Organiser | `{ "name": "Comrades Marathon", "location": "Durban", "eventDate": "2024-06-09T05:30:00", "description": "The Ultimate Human Race." }` | **201 Created:** Newly created event object. <br>**403 Forbidden:** User is not an Organiser. |
| **PUT** | `/api/events/{id}` | Updates an existing event. Only the Organiser who created the event can update it. | Organiser | `{ "name": "Comrades Marathon 2024", "location": "Durban", "eventDate": "2024-06-09T05:30:00", "description": "Updated description." }` | **200 OK:** Updated event object. <br>**403 Forbidden:** User does not own this event. <br>**404 Not Found.** |
| **DELETE** | `/api/events/{id}` | Deletes an event. Only the owning Organiser can delete it. | Organiser | None | **204 No Content:** Successfully deleted. <br>**403 Forbidden:** User does not own this event. <br>**404 Not Found.** |

 3. Category Management (Nested under Events)

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/events/{eventId}/categories` | Retrieves all categories (e.g., 10km, 21km, 42km) for a specific event. | None (Public) | None | **200 OK:** Array of category objects. <br>**404 Not Found:** Event does not exist. |
| **POST** | `/api/events/{eventId}/categories` | Adds a new category to a specific event. | Organiser | `{ "name": "Ultra Marathon", "distance": 89.0, "entryFee": 500.00 }` | **201 Created:** Newly created category object. <br>**403 Forbidden:** Not the event owner. |
| **PUT** | `/api/categories/{id}` | Updates an existing category. | Organiser | `{ "name": "Ultra Marathon", "distance": 90.0, "entryFee": 550.00 }` | **200 OK:** Updated category object. <br>**403 Forbidden.** |
| **DELETE** | `/api/categories/{id}` | Removes a category. | Organiser | None | **204 No Content.** <br>**403 Forbidden.** |

 4. Event Enrollments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/enrollments` | Enrolls the currently logged-in participant into a specific event category. | Participant | `{ "categoryId": 1 }` | **201 Created:** Enrollment record. <br>**400 Bad Request:** Category is full or invalid. <br>**409 Conflict:** User is already enrolled in this category. |
| **GET** | `/api/enrollments/my` | Retrieves the enrollment history for the currently logged-in participant. | Participant | None | **200 OK:** Array of enrollment objects with event details. |
| **DELETE** | `/api/enrollments/{id}` | Cancels an enrollment. Only allowed if the event has not happened yet. | Participant | None | **204 No Content.** <br>**400 Bad Request:** Event already occurred. <br>**403 Forbidden:** Not the owner of the enrollment. |

 5. Results Tracking

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/results` | Captures a race result for a specific participant enrollment. | Organiser | `{ "enrollmentId": 5, "finishTime": "04:30:00", "position": 15 }` | **201 Created:** Result object. <br>**400 Bad Request:** Invalid time format. <br>**403 Forbidden:** Not an Organiser. |
| **GET** | `/api/results/{eventId}` | Retrieves all results for a specific event (e.g., for a leaderboard). | None (Public) | None | **200 OK:** Array of results ordered by position. |
| **GET** | `/api/results/my` | Retrieves all personal results for the logged-in participant. | Participant | None | **200 OK:** Array of personal results. |

 6. Route & Weather Info (Race Day Prep)

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/events/{id}/route` | Retrieves route map, elevation, and live weather info for a specific event. | None (Public) | None | **200 OK:** `{ "routeMapUrl": "...", "elevationGain": 1200, "weather": { "temp": 22, "condition": "Sunny" } }` <br>**404 Not Found:** No route info available. |
| **POST** | `/api/events/{id}/route` | Adds or updates route and weather information for an event. | Organiser | `{ "routeMapUrl": "https://...", "elevationGain": 1200, "weatherConditions": "Sunny" }` | **201 Created:** Route info object. <br>**403 Forbidden.** |

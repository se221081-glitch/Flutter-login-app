# Flutter Login & Course Management App

A Flutter multi-screen authentication application extended with REST API integration for full CRUD operations on courses.

## Features

### Authentication & User Management
- User login with email and password validation
- User registration with comprehensive form validation
- Password visibility toggle
- Remember me functionality
- Secure user authentication flow

### Course Management (CRUD Operations)
- **Create (POST)**: Add new courses via form submission
- **Read (GET)**: Fetch and display course list from API
- **Update (PUT)**: Edit existing course details with pre-filled form
- **Delete (DELETE)**: Remove courses with confirmation dialog
- Real-time UI updates after API operations
- Loading, success, and error state handling

### UI/UX
- Warm earthy color palette (terracotta, olive, cream)
- Responsive design for mobile devices
- Smooth navigation between screens
- Error handling with user-friendly messages
- Loading indicators for async operations

## API Integration

### API Used
[JSONPlaceholder](https://jsonplaceholder.typicode.com/guide) - Free fake REST API for testing and development

### Endpoints Used
- **GET /posts** - Fetch all courses (limited to 10 for performance)
- **GET /posts/{id}** - Fetch individual course
- **POST /posts** - Create new course
- **PUT /posts/{id}** - Update existing course
- **DELETE /posts/{id}** - Delete course

### API Documentation Reference
Official JSONPlaceholder Guide: https://jsonplaceholder.typicode.com/guide

The API is used as follows:
- Posts are treated as Courses
- `title` field = Course Title
- `body` field = Course Description
- `userId` = User ID (default = 1)
- `id` = Course ID

## Project Structure

```
lib/
├── controllers/
│   ├── login_controller.dart        # Login logic
│   ├── registration_controller.dart # Registration logic
│   ├── dashboard_controller.dart    # Dashboard logic
│   └── course_controller.dart       # Course CRUD logic (NEW)
├── models/
│   ├── user.dart                    # User model
│   └── course.dart                  # Course model (NEW)
├── screens/
│   ├── login_screen.dart            # Login UI
│   ├── registration_screen.dart     # Registration UI
│   ├── dashboard_screen.dart        # Dashboard UI (updated)
│   └── courses_screen.dart          # Courses management UI (NEW)
├── utils/
│   ├── validators.dart              # Input validation
│   ├── app_theme.dart               # Theme configuration
│   └── api_service.dart             # API calls (NEW)
├── enums/
│   └── enums.dart                   # Enum definitions
└── main.dart                        # App entry point
```

## Architecture

### Service Layer Pattern
- **ApiService** (`lib/utils/api_service.dart`) handles all API communication
- Keeps API logic separate from UI
- Provides clean, reusable methods for CRUD operations
- Includes error handling and timeout management

### State Management
- **Provider** package for reactive state management
- **CourseController** extends `ChangeNotifier` for course state
- Handles loading, success, and error states
- Notifies listeners on state changes

### Model Layer
- **Course** model with `fromJson()` and `toJson()` factory methods
- Supports serialization/deserialization for API communication
- Immutable copy-with pattern for state updates

## Getting Started

### Prerequisites
- Flutter SDK (3.11.4 or higher)
- Dart SDK
- A code editor (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/se221081-glitch/Flutter-login-app.git
cd Flutter-login-app
```

2. Checkout the feature branch:
```bash
git checkout feature/course-api-integration
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Branches

- **main** - Original authentication and UI customization
- **feature/course-api-integration** - CRUD API integration using JSONPlaceholder (Current)

## Dependencies

- `flutter` - Flutter SDK
- `provider: ^6.0.0` - State management
- `http: ^1.1.0` - HTTP client for API calls
- `cupertino_icons: ^1.0.8` - iOS style icons

## How to Use

### Login Flow
1. Launch app → Login Screen
2. Enter valid credentials to proceed
3. If no account, click "Sign up" to register
4. After registration, login with new credentials

### Course Management
1. Login → Dashboard
2. Click "Manage Courses" button
3. View all courses fetched from JSONPlaceholder API
4. Use "+ Add" button to create new course
5. Click edit icon to modify existing course
6. Click delete icon to remove course (with confirmation)

## State Handling

### Loading State
- Shows circular progress indicator during API calls
- Disables buttons to prevent multiple submissions

### Success State
- Updates UI with new data
- Shows success snackbar message

### Error State
- Displays error message to user
- Provides retry option for failed operations
- Maintains previous data to prevent blank screens

## Key Implementation Details

### API Service (`ApiService`)
- Static methods for all CRUD operations
- Automatic JSON encoding/decoding
- 10-second timeout for all requests
- Comprehensive error messages

### Course Controller (`CourseController`)
- Extends `ChangeNotifier` for reactive updates
- Limits displayed courses to 10 for performance
- Maintains local list for instant UI updates
- Pre-fetches data on screen initialization

### Error Handling
- Try-catch blocks for all API calls
- Custom exception messages
- Graceful fallback UI for error states
- Retry mechanism for failed operations

## Screenshots

[To be added after testing]

## Testing the API

You can test the API endpoints directly in browser or tools like Postman:

```
Create: POST https://jsonplaceholder.typicode.com/posts
        Body: {"title": "Course", "body": "Description", "userId": 1}

Read:   GET https://jsonplaceholder.typicode.com/posts

Update: PUT https://jsonplaceholder.typicode.com/posts/1
        Body: {"id": 1, "title": "New Title", "body": "New Body", "userId": 1}

Delete: DELETE https://jsonplaceholder.typicode.com/posts/1
```

## Submission Details

- **Branch**: `feature/course-api-integration`
- **API Used**: JSONPlaceholder (https://jsonplaceholder.typicode.com)
- **Documentation Followed**: https://jsonplaceholder.typicode.com/guide
- **CRUD Operations**: Fully implemented (Create, Read, Update, Delete)

## Future Enhancements

- Add local database (SQLite) for offline support
- Implement pagination for large datasets
- Add search and filter functionality
- Real API backend integration
- Unit and widget testing
- User-specific course management

## License

This project is open source and available under the MIT License.

## Author

Developed as part of Flutter Application Development Extension Assignment.


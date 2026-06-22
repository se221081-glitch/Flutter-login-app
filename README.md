# Flutter Login & Course Management App - Extension Edition

A Flutter multi-screen authentication application extended with:
1. **REST API Integration** - Full CRUD operations on courses
2. **Offline Support** - Local data caching with Hive
3. **Enhanced State Management** - Repository pattern with Provider
4. **UX Improvements** - Pull-to-refresh, search, optimistic updates

## 🎯 Feature Branch

**Branch**: `feature/offline-cache-and-state-management`

This branch includes the complete extension assignment with offline support and state management upgrade.

## ✨ Features

### Original Features
- User login with email and password validation
- User registration with comprehensive form validation
- Secure user authentication flow
- Full CRUD operations on courses

### NEW - Extension Features

#### 1. Offline Data Persistence
- ✅ Local storage using **Hive**
- ✅ Automatic caching after API calls
- ✅ Seamless offline mode with cached data
- ✅ Automatic sync when coming online

#### 2. Repository Pattern
- ✅ Clean separation: UI → State → Repository → Data
- ✅ API service handles HTTP only
- ✅ Repository decides: API vs Local Storage
- ✅ Easy to test and maintain

#### 3. Enhanced State Management
- ✅ Provider-based reactive state
- ✅ Granular state tracking (initial, loading, success, error, empty)
- ✅ Proper error handling
- ✅ Search and filter capabilities

#### 4. Optimistic UI Updates
- ✅ Immediate feedback on user actions
- ✅ Automatic rollback on failure
- ✅ Smooth user experience
- ✅ Non-blocking sync

#### 5. Pull-to-Refresh
- ✅ Swipe to refresh course list
- ✅ Loading indicator
- ✅ Error handling on refresh

#### 6. Search & Filter
- ✅ Real-time search by title or body
- ✅ Works offline on cached data
- ✅ Integrated with state management

#### 7. UX Improvements
- ✅ Online/offline status indicator
- ✅ Empty state handling
- ✅ Better loading indicators
- ✅ Local course markers
- ✅ Improved error messages

#### 8. Connectivity Monitoring
- ✅ Real-time status tracking
- ✅ Automatic mode switching
- ✅ User notifications

## 📦 Dependencies (New & Updated)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | Latest | Flutter SDK |
| `provider` | ^6.0.0 | State management |
| `http` | ^1.1.0 | HTTP client for API |
| **`hive`** | ^2.2.3 | **Local database (NEW)** |
| **`hive_flutter`** | ^1.1.0 | **Hive Flutter support (NEW)** |
| **`connectivity_plus`** | ^5.0.0 | **Connectivity monitoring (NEW)** |
| `cupertino_icons` | ^1.0.8 | iOS style icons |

### Dev Dependencies
- **`hive_generator`** ^2.0.0 - Code generation for Hive
- **`build_runner`** ^2.4.0 - Build system

## 📊 Architecture Layers

## 📊 Architecture Layers

### Data Flow
```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer                             │
│              (Screens, Widgets)                         │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│           State Management Layer                        │
│     (CourseController with ChangeNotifier)              │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│           Repository Layer                              │
│    (Business logic - API vs Local decision)             │
└────────┬─────────────────────────────┬──────────────────┘
         │                             │
    ┌────▼──────────┐           ┌──────▼─────────┐
    │  Remote Data  │           │ Local Data     │
    │  (API)        │           │ (Hive DB)      │
    └───────────────┘           └────────────────┘
```

### Key Components

**1. UI Layer (Screens)**
- `courses_screen_enhanced.dart` - Main enhanced UI with all new features

**2. State Layer (state/)**
- `course_provider.dart` - Enhanced CourseController with repository integration

**3. Repository Layer (data/repositories/)**
- `course_repository.dart` - Smart data source selection (API/Local)

**4. Data Layer (data/)**
- Remote: `remote_api_service.dart` - HTTP communication only
- Local: `local_database.dart` - Hive storage operations

**5. Service Layer (services/)**
- `connectivity_service.dart` - Connectivity status monitoring

## 📁 Project Structure

```
lib/
├── main.dart                               # App entry point (updated)
├── models/
│   ├── user.dart                          # User model
│   └── course.dart                        # Course model (WITH Hive support)
├── screens/
│   ├── login_screen.dart                  # Login UI
│   ├── registration_screen.dart           # Registration UI
│   ├── dashboard_screen.dart              # Dashboard (updated to use enhanced)
│   ├── courses_screen.dart                # Original courses screen
│   └── courses_screen_enhanced.dart       # 🆕 ENHANCED with offline support
├── controllers/                           # Original controllers
│   ├── login_controller.dart
│   ├── registration_controller.dart
│   ├── dashboard_controller.dart
│   └── course_controller.dart
├── data/                                  # 🆕 DATA LAYER
│   ├── local/
│   │   └── local_database.dart           # Hive storage service
│   ├── remote/
│   │   └── remote_api_service.dart       # API service (HTTP only)
│   └── repositories/
│       └── course_repository.dart        # Repository pattern
├── services/                              # 🆕 SERVICES LAYER
│   └── connectivity_service.dart         # Connectivity monitoring
├── state/                                 # 🆕 STATE LAYER
│   └── course_provider.dart              # Enhanced CourseController
├── utils/
│   ├── validators.dart                    # Input validation
│   ├── app_theme.dart                     # Theme configuration
│   ├── api_service.dart                   # Legacy API service
│   └── enums.dart                         # Enum definitions
└── enums/
    └── enums.dart

```

## 📱 How to Use

### Basic Flow
1. **Launch App** → Login Screen
2. **Login/Register** → Dashboard
3. **Dashboard** → Tap "Manage Courses"
4. **Courses Screen** → All offline-enabled features

### Key Features in Action

#### Pull-to-Refresh
```
Swipe down on the courses list → Refreshes data from API
                                → Syncs local cache
```

#### Search Courses
```
Tap search icon → Type course title or keyword → Results filtered in real-time
Works offline using cached data
```

#### Add Course
```
Tap + button → Fill course details → Submit
Online: Sent to API, then cached locally
Offline: Saved locally, synced when online
```

#### Edit Course  
```
Tap edit icon → Modify details → Update
Optimistic update: UI updated immediately
If sync fails: Local changes preserved, retried on action
```

#### Delete Course
```
Tap delete icon → Confirm → Course removed
Optimistic delete: Immediately removed from UI
If sync fails: Rolled back to previous state
```

#### Offline Mode
```
Disable internet → App switches to offline mode
Badge appears: "Offline Mode - Using Cached Data"
All previous data remains accessible
Actions synced automatically when online
```

## 🔄 Offline Workflow

### Scenario 1: Create Course While Offline
```
1. User creates course (offline mode)
2. Course saved locally with temporary ID
3. Cloud icon indicates pending sync
4. Internet restored
5. Course synced to API automatically
6. ID updated to server ID
```

### Scenario 2: Edit & Delete While Offline
```
1. User modifies course (offline)
2. Changes saved locally immediately (optimistic)
3. App indicates local changes
4. Internet restored
5. Changes synced to API
6. Server confirms update
```

### Scenario 3: Network Failure During Sync
```
1. User creates course (online)
2. Course sent to API
3. Network fails mid-request
4. Course retained in local storage
5. Automatically retried on next action
6. No data loss
```

## 🌐 API Integration

### Endpoints Used
- **GET /posts** - Fetch courses
- **GET /posts/{id}** - Fetch single course
- **POST /posts** - Create course
- **PUT /posts/{id}** - Update course
- **DELETE /posts/{id}** - Delete course

### API Used
[JSONPlaceholder](https://jsonplaceholder.typicode.com) - Free fake REST API

### API Response Mapping
```
API Field     → Model Field
title         → title (course name)
body          → body (description)
id            → id (course identifier)
userId        → userId (owner)
```

## 🧠 State Management Details

### ApiState Enum
```dart
enum ApiState {
  initial,   // App startup
  loading,   // Data fetching
  success,   // Operation successful
  error,     // Error occurred
  empty      // No data available
}
```

### CourseController State Properties
- `state` - Current API operation state
- `courses` - Display list (with search applied)
- `allCourses` - Complete unfiltered list
- `isLoading` - Currently fetching data
- `isOnline` - Internet connectivity status
- `isEmpty` - No courses available
- `errorMessage` - Last error text
- `searchQuery` - Current search term

### State Flow Example
```
Initial State
    ↓
[Fetch Button Clicked]
    ↓
State = Loading (Loading spinner shown)
    ↓
[API Response Received]
    ↓
State = Success (Data displayed)
    ↓
[Cached to Local DB]
    ↓
Ready for Offline Use
```

## 🔐 Error Handling Strategy

### Network Errors
```
API Request Failed
    ├─ If offline: Load from local storage
    └─ If error: Show error message + retry button
```

### Sync Errors
```
Update/Delete Operation Failed
    ├─ If online: Non-blocking, retry on next action
    └─ Local changes preserved in storage
```

### Validation Errors
```
Invalid Input
    └─ Show validation message before submission
```

## 🆕 Key Improvements Over Previous Version

| Feature | Before | After |
|---------|--------|-------|
| Works Offline | ❌ | ✅ Yes |
| Local Caching | ❌ | ✅ Hive |
| Search Function | ❌ | ✅ Real-time |
| Pull-to-Refresh | ❌ | ✅ Yes |
| Connectivity Aware | ❌ | ✅ Real-time |
| Repository Pattern | ❌ | ✅ Full |
| Optimistic Updates | ❌ | ✅ Yes |
| Error Recovery | ⚠️ Limited | ✅ Robust |
| Empty States | ⚠️ Basic | ✅ Comprehensive |
| Code Organization | ⚠️ Mixed | ✅ Layered |

## 🎯 Submission Requirements Checklist

- [x] **Offline Data Persistence**
  - ✅ Implemented using Hive
  - ✅ Stores course data locally
  - ✅ Loads from local when offline
  - ✅ Syncs when online

- [x] **State Management Upgrade**
  - ✅ Using Provider (reactive state)
  - ✅ Manages loading, success, error, empty states
  - ✅ Separated UI from business logic
  - ✅ Clean state management layer

- [x] **Repository Pattern**
  - ✅ Clean architecture: UI → State → Repository → Data
  - ✅ API service handles HTTP only
  - ✅ Repository decides: API vs Local
  - ✅ Modular and reusable

- [x] **Optimistic UI Updates**
  - ✅ Immediate UI feedback
  - ✅ Rollback on failure
  - ✅ Responsive user experience
  - ✅ Non-blocking operations

- [x] **UX Improvements**
  - ✅ Pull-to-refresh functionality
  - ✅ Search and filter courses
  - ✅ Empty state handling
  - ✅ Online/offline indicator
  - ✅ Improved loading indicators

- [x] **Documentation**
  - ✅ This README
  - ✅ ARCHITECTURE.md (detailed docs)
  - ✅ Code comments throughout
  - ✅ Clear folder structure

## 📚 Additional Resources

### Documentation Files
- **README.md** - This file (overview and usage)
- **ARCHITECTURE.md** - Detailed architecture and technical docs
- **pubspec.yaml** - Dependencies and configuration
- **analysis_options.yaml** - Lint rules

### External Resources
- [Provider Documentation](https://pub.dev/packages/provider)
- [Hive Documentation](https://pub.dev/packages/hive)
- [Repository Pattern](https://en.wikipedia.org/wiki/Repository_pattern)
- [Offline-First Architecture](https://offlinefirst.org/)
- [JSONPlaceholder API Guide](https://jsonplaceholder.typicode.com/guide)

## 🔄 Development Tips

### Debugging Offline Mode
```bash
# Using Android Emulator
adb shell settings put global airplane_mode_on 1
adb shell settings put global wifi_on 0

# Or use Android Studio network throttling
Tools → Device Monitor → Network Throttling
```

### Monitoring Hive Database
```dart
// In your controller/provider:
print('Courses in local storage: ${await LocalDatabase().getCoursesCount()}');
```

### Testing API Responses
```bash
# Direct API testing
curl https://jsonplaceholder.typicode.com/posts
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","body":"Description","userId":1}'
```

## 🚀 Future Enhancement Ideas

- [ ] Implement background sync service
- [ ] Add conflict resolution for sync
- [ ] Implement data encryption in local storage
- [ ] Add pagination for large datasets
- [ ] Implement undo/redo functionality
- [ ] Add analytics for offline usage
- [ ] Create sync status dashboard
- [ ] Implement delta sync for bandwidth optimization

## 📞 Support & Troubleshooting

### Issue: Build fails with "Hive adapter not found"
**Solution**: Run `flutter pub run build_runner build` again

### Issue: Offline mode not working
**Solution**: Check `connectivity_plus` permissions in native files

### Issue: Local data not persisting
**Solution**: Ensure `local_database.initialize()` is called

### Issue: Search not working
**Solution**: Verify search controller is properly disposed in cleanup

## 📝 Notes

- All timestamps use device local time
- Negative course IDs indicate local-only courses
- API timeout is set to 10 seconds
- Max 10 courses displayed for performance
- Hive database stored in app documents directory

## 👨‍💻 Assignment Details

**Course**: Flutter Application Development - Extension  
**Topic**: Offline Support & State Management Upgrade  
**Branch**: `feature/offline-cache-and-state-management`  
**Status**: ✅ Complete  
**Last Updated**: 2026-06-22  
**Version**: 1.1.0 (Offline + Repository Pattern)

## 📄 License

This project is part of the Flutter Application Development assignment series.

---

**Happy Coding! 🚀**

For detailed architecture information, see [ARCHITECTURE.md](ARCHITECTURE.md)


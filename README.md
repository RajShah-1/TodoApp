# TodoApp

## Overview

TodoApp is an iOS-based task management application built with SwiftUI and Firestore. It enables users to securely create, edit, and manage tasks, categorizing them into "Active" and "Completed." The app integrates Google Authentication for user sign-in.

## Features

1. **User Authentication**:
   - Secure login via Google Authentication.

2. **Task Management**:
   - Add new tasks.
   - Edit existing tasks to update details.
   - Automatically categorize tasks as "Active" or "Completed" based on their status.

3. **Backend Integration**:
   - Real-time data storage and retrieval using Firestore.
   - Sync tasks seamlessly across devices.

4. **Collaboration**:
   - Partner-contributed feature: Task editing functionality.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/RajShah-1/TodoApp.git
   ```
2. **Open in Xcode**:
   - Open the `FirstProject.xcodeproj` file in Xcode.
3. **Configure Firebase**:
   - Add your `GoogleService-Info.plist` file for Firebase integration.
4. **Build and Run**:
   - Select a simulator or physical device and click "Run" in Xcode.

## Requirements

- Xcode 12.0 or later
- iOS 17.3 or later
- Swift 5.3 or later
- Firebase account (for Firestore and Google Auth setup)

## Backend Details

- **Firestore**:
  - Collection structure: One-to-one mapping between user IDs and task collections.
  - Example collection path: `todo-app-mas/<user_id>`
- **Endpoints**:
  - `GET`: Fetch tasks by status.
  - `POST`: Add new tasks.
  - `PUT`: Update task details.
  - `DELETE`: Remove tasks.

## Future Improvements

- Add push notifications for task reminders.
- Support multiple languages via localization.
- Enable location-based tasks using geolocation.

## Contact

- Raj Shah
- Collaborator: Raj Jignesh Shah

For questions or suggestions, open an issue in the repository.

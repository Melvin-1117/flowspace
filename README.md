<div align="center">
  # 🌌 FlowSpace
  
  **The ultimate developer-focused workspace, pomodoro scheduler, and activity tracker.**
  
  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.9.2-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
    <a href="https://pub.dev/packages/flutter_riverpod"><img src="https://img.shields.io/badge/Riverpod-State-8B5CF6?style=for-the-badge" alt="Riverpod"></a>
    <a href="https://isar.dev"><img src="https://img.shields.io/badge/Database-Isar-1E3A8A?style=for-the-badge" alt="Isar NoSQL"></a>
  </p>
  
  <p>
    <img src="https://img.shields.io/badge/Platform-Android_|_Web_|_Windows-7C3AED?style=flat-square" alt="Platforms">
    <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome">
  </p>
</div>

---

## 🌟 Overview

**FlowSpace** is a unified dashboard designed to maximize developer focus, catalog project tasks, map academic plans, and analyze coding habits. It bridges the gap between structured focus sessions and developer activity logs.

With beautiful dark-mode acoustics, responsive transitions, and a feature-first clean architecture, FlowSpace helps developers enter and sustain their optimal flow state.

---

## ⚡ Core Features

<table width="100%">
  <tr>
    <td width="50%" valign="top">
      <h3>⚡ Focus Dashboard</h3>
      <p>Your central command center. Instantly track daily focus statistics, current streak counts, upcoming deadlines, and overall productivity levels. Features responsive widgets and rapid-access shortcuts.</p>
    </td>
    <td width="50%" valign="top">
      <h3>🚀 DevTrack Analytics</h3>
      <p>A Git-inspired developer scoreboard right inside the app. Features an interactive contribution heatmap, language breakdowns, active workspace directories, and visual skill progression charts.</p>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <h3>⏱️ Pomodoro Engine</h3>
      <p>Maintain focus with customizable work-and-break cycles. Features foreground notifications (via <code>flutter_foreground_task</code>) for active background session tracking and custom alarm tones.</p>
    </td>
    <td width="50%" valign="top">
      <h3>📋 Kanban Task Board</h3>
      <p>Organize your project backlogs. Easily drag and drop tasks between <b>To Do</b>, <b>In Progress</b>, <b>Review</b>, and <b>Done</b> columns to keep your board current.</p>
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top">
      <h3>📅 Subject & Focus Planner</h3>
      <p>Plan your syllabus or project categories. Schedule dedicated daily blocks for specific focus areas, manage target criteria, and monitor milestones with precise countdown clocks.</p>
    </td>
    <td width="50%" valign="top">
      <h3>📊 Data-Driven Insights</h3>
      <p>Detailed chart feedback on your habits. View visual weekly task velocity graphs, time allocation breakdowns, and session distribution stats powered by <code>fl_chart</code>.</p>
    </td>
  </tr>
</table>

---

## 🛠️ Tech Stack & Key Packages

FlowSpace utilizes a highly modular and modern stack for optimal mobile, web, and desktop performance:

*   **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.9.2`)
*   **State Management**: [Riverpod](https://riverpod.dev) (for scalable, testable, and reactive state caching)
*   **Local Storage**: [Isar Database](https://isar.dev) (lightning-fast, ACID-compliant local NoSQL database)
*   **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (declarative routing structure)
*   **Visualizations**: [FL Chart](https://pub.dev/packages/fl_chart) (highly custom bar, line, and donut charts)
*   **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate) (clean, duration-tokenized transitions)
*   **Background Tasks**: [Flutter Foreground Task](https://pub.dev/packages/flutter_foreground_task) (ensures Pomodoro timers aren't killed by OS battery savers)
*   **Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications) (for timely alarms and alarms overlay warnings)

---

## 📁 Project Architecture

The codebase follows a **Feature-First Architecture** with a clear separation of core utilities, app-wide styles, and feature domains:

```text
lib/
├── app/                  # Theme configuration and app initialization
├── core/                 # Shared widgets, services, and constant design tokens
│   ├── constants/        # Unified animation and layout tokens
│   ├── providers/        # Shared Riverpod providers (Calendar, etc.)
│   ├── services/         # Database, notification, and onboarding configurations
│   ├── utils/            # Data formatting and string helpers
│   └── widgets/          # Global UI widgets (shimmer, avatar, etc.)
├── features/             # Feature domains (Encapsulates logic, state, & screens)
│   ├── analytics/        # Weekly statistics, chart components, and history
│   ├── dashboard/        # Main landing widgets, active focus session widgets
│   ├── devtrack/         # Contribution heatmaps, skill levels, session logs
│   ├── onboarding/       # Interactive user onboarding flows
│   ├── planner/          # Milestone tracking, subjects, focus blocks
│   ├── pomodoro/         # State machines for timers, alarm services, ring UI
│   ├── settings/         # Database backup, sounds, profile adjustments
│   └── tasks/            # Kanban boards, cards, category managers, detail screens
├── widgets/              # Shared navigation structures (AppBar, Drawer, BottomNav)
└── main.dart             # Application entry point
```

---

## 🚀 Getting Started

### 📋 Prerequisites

To run FlowSpace locally, ensure you have:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (`>= 3.9.2`)
*   An Android SDK (for mobile builds), Xcode (for macOS/iOS), or Visual Studio (for Windows build)
*   An editor like VS Code or Android Studio

### 🔧 Installation & Setup

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/yourusername/flowspace.git
    cd flowspace
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Code Generators**:
    FlowSpace uses Isar code generation. Generate the database adapters with:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the App**:
    *   For development run:
        ```bash
        flutter run
        ```
    *   To target a specific platform (e.g. Web):
        ```bash
        flutter run -d chrome
        ```

---

## 📦 Building for Production

### 🤖 Android (APK Build)

To generate a release build of the Android app (APK):

```bash
flutter build apk --release
```

The compiled APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

*Note: For testing, you can also build a debug/unsigned APK using `flutter build apk --debug`.*

### 🌐 Web Production Build

To compile a web-optimized production bundle:

```bash
flutter build web --release
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

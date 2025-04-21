# Mini-TaskHub (Flutter Task Tracker with Supabase)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A simple, personal task tracking application built with Flutter and Supabase. Features user authentication, task management (add, complete, edit, delete), and a dark/light theme toggle, styled loosely based on the DayTask design concept.

## Screenshots

*(**ACTION REQUIRED:** Replace the `...` in the `src` attribute below with the actual links or relative paths to your screenshots after uploading them to GitHub or another host)*

| Login Screen                                    | Sign Up Screen                                    | Dashboard (Dark)                                | Dashboard (Light)                               | Add/Edit Task Sheet                           |
| :----------------------------------------------: | :-----------------------------------------------: | :---------------------------------------------: | :---------------------------------------------: | :-----------------------------------------: |
| <img src="..." alt="Login Screen" width="200"/> | <img src="..." alt="Sign Up Screen" width="200"/> | <img src="..." alt="Dashboard Dark" width="200"/> | <img src="..." alt="Dashboard Light" width="200"/> | <img src="..." alt="Add/Edit Task" width="200"/> |

## Features

*   **User Authentication:** Secure email/password sign-up & login via Supabase Auth.
*   **Task Management:**
    *   View tasks list on the dashboard.
    *   Add new tasks via a modal bottom sheet.
    *   Mark tasks as completed/pending using a checkbox.
    *   Edit existing task titles via a modal bottom sheet.
    *   Delete tasks using swipe-to-delete or a menu option (with confirmation).
    *   Visual status indicator (Pending/Completed text and progress bar).
*   **Persistence:** Task data stored securely in Supabase PostgreSQL database.
*   **Row Level Security:** Ensures users can only access their own tasks.
*   **State Management:** Uses `provider` for managing task and theme state.
*   **Theming:** Switchable Dark/Light themes based on the DayTask design, preference saved locally using `shared_preferences`.
*   **UI:** Clean interface styled with Material 3 components and Google Fonts (Poppins).

## Tech Stack

*   **Frontend:** Flutter (Dart)
*   **Backend:** Supabase
    *   Authentication
    *   PostgreSQL Database
*   **State Management:** `provider`
*   **Local Storage:** `shared_preferences` (for theme preference)
*   **Date Formatting:** `intl`
*   **UI Fonts:** `google_fonts`

## Folder Structure

```plaintext
lib/
│
├── main.dart              # App entry point, Supabase init, Root Widget, Auth Gate
│
├── app/
│   ├── theme.dart         # App theme definitions (Dark/Light)
│   └── theme_provider.dart # State management for theme switching
│
├── auth/
│   ├── login_screen.dart    # UI for user login
│   ├── signup_screen.dart   # UI for user registration
│   └── auth_service.dart    # Handles Supabase auth logic & snackbars
│
├── dashboard/
│   ├── dashboard_screen.dart # Main screen showing tasks, FAB, app bar actions
│   ├── task_tile.dart      # Widget for a single task item (incl. actions, status)
│   ├── task_model.dart     # Data model for a Task
│   └── task_provider.dart  # State management for tasks (ChangeNotifier)
│
├── services/
│   └── supabase_service.dart # Handles Supabase database interactions (CRUD for tasks)
│
└── utils/
    └── validators.dart    # Form field validation functions

assets/
└── images/
    └── google_logo.png    # Google logo for auth screens (placeholder button)

## Setup Instructions

Follow these steps to get the project running locally:

1.  **Prerequisites:**
    *   Flutter SDK installed (check with `flutter --version`)
    *   Git installed (check with `git --version`)
    *   A code editor like VS Code or Android Studio.
    *   A Supabase account ([supabase.com](https://supabase.com)).

2.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Poorvigup/Mini-TaskHub-Personal-Task-Tracker.git
    cd Mini-TaskHub-Personal-Task-Tracker
    ```

3.  **Install Flutter Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Set up Supabase:** See the detailed Supabase setup steps below. **This is essential.**

5.  **Configure API Keys:**
    *   Open `lib/main.dart`.
    *   Replace the placeholder values for `supabaseUrl` and `supabaseAnonKey` with your actual Supabase Project URL and Anon Key (obtained in Step 3 below).
        ```dart
        // --- !!! REPLACE WITH YOUR SUPABASE CREDENTIALS !!! ---
        const supabaseUrl = 'YOUR_SUPABASE_URL'; // <-- Paste your URL here
        const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY'; // <-- Paste your Anon Key here
        // --- !!! ---
        ```
    *   Save the file.

6.  **Run the App:** Ensure you have a connected device (Android/iOS) or a running emulator/simulator.
    ```bash
    flutter run
    ```

## Supabase Setup Steps

This project requires a Supabase backend for authentication and data storage.

1.  **Create Supabase Project:**
    *   Go to [supabase.com](https://supabase.com) and sign up or log in.
    *   Click "**New project**".
    *   Choose an organization.
    *   Enter a **Name** for your project (e.g., `Mini-TaskHub`).
    *   Create a strong **Database Password** (save this securely, though not needed for the app itself).
    *   Choose a **Region**.
    *   Select the **Free** pricing plan.
    *   Click "**Create Project**" (this may take a couple of minutes).

2.  **Configure Authentication:**
    *   In your new project dashboard, go to **Authentication** (user icon in the left sidebar).
    *   Click on **Providers**.
    *   Find **Email** and ensure it is **Enabled**. Click Save if needed.
    *   Click on the **Settings** tab within Authentication.
    *   Scroll down and **DISABLE** the "**Confirm email**" toggle switch (turn it OFF/grey). This makes testing much easier as users won't need to verify their email to log in initially. Click **Save**.

3.  **Get API Credentials (URL & Anon Key):**
    *   Go to **Project Settings** (gear icon in the left sidebar).
    *   Click on **API**.
    *   Under **Project API Keys**, find and copy:
        *   The **URL**.
        *   The **anon (public)** key. **Do NOT use the `service_role` key in your Flutter app.**
    *   *(You will paste these into `lib/main.dart` as described in the main Setup Instructions)*.

4.  **Create `tasks` Table & RLS Policies:**
    *   Go to the **Table Editor** (database icon in the left sidebar).
    *   Click on **SQL Editor** in the submenu.
    *   Click "**+ New query**".
    *   Copy the **entire** SQL code block below and paste it into the query editor:
        ```sql
        -- Create the tasks table
        CREATE TABLE tasks (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
          title TEXT NOT NULL CHECK (char_length(title) > 0 AND char_length(title) <= 100), -- Added max length
          is_completed BOOLEAN DEFAULT FALSE NOT NULL,
          created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
        );

        -- Add comments to columns (Optional but helpful)
        COMMENT ON COLUMN tasks.id IS 'Unique identifier for each task';
        COMMENT ON COLUMN tasks.user_id IS 'Foreign key referencing the user who owns the task';
        COMMENT ON COLUMN tasks.title IS 'The description or name of the task (max 100 chars)';
        COMMENT ON COLUMN tasks.is_completed IS 'Flag indicating if the task is done';
        COMMENT ON COLUMN tasks.created_at IS 'Timestamp when the task was created';

        -- Enable Row Level Security (RLS) for the tasks table
        ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

        -- Policy: Allow users to view their own tasks
        CREATE POLICY "Allow users to view their own tasks"
        ON tasks FOR SELECT
        USING (auth.uid() = user_id);

        -- Policy: Allow users to insert their own tasks
        CREATE POLICY "Allow users to insert their own tasks"
        ON tasks FOR INSERT
        WITH CHECK (auth.uid() = user_id);

        -- Policy: Allow users to update their own tasks (title, is_completed)
        CREATE POLICY "Allow users to update their own tasks"
        ON tasks FOR UPDATE
        USING (auth.uid() = user_id)
        WITH CHECK (auth.uid() = user_id);

        -- Policy: Allow users to delete their own tasks
        CREATE POLICY "Allow users to delete their own tasks"
        ON tasks FOR DELETE
        USING (auth.uid() = user_id);

        -- Optional: Add an index for faster lookups by user_id
        CREATE INDEX idx_tasks_user_id ON tasks(user_id);

        -- Grant necessary permissions to the 'authenticated' role (logged-in users)
        -- Adjust 'public' if your table is in a different schema
        grant usage on schema public to authenticated;
        grant all on table public.tasks to authenticated; -- Grant all needed permissions

        ```
    *   Click the "**Run**" button (▶️ icon).
    *   You should see a "**Success. No rows returned**" message. This creates the table and security rules.

## Flutter Development: Hot Reload vs Hot Restart

Flutter offers powerful tools to speed up development. Understanding the difference is key:

### Hot Reload (⚡️ `Ctrl+S` or Lightning Bolt Icon in IDE)

*   **What it does:** Injects updated source code files into the already running Dart Virtual Machine (VM). The VM updates classes with the new versions of fields and functions. The Flutter framework then automatically rebuilds the widget tree, allowing you to quickly see the effects of your changes.
*   **State:** **Preserves** the current state of your application. This means your variables retain their values, and you stay on the same screen.
*   **Speed:** Very fast (typically sub-second).
*   **Use Cases:** Ideal for tweaking UI layouts, changing text, adjusting colors, fixing typos, modifying non-state-related logic within functions. Most of your development cycle will use Hot Reload.
*   **Limitations:**
    *   Does not re-run `initState()` methods or initializers for final fields.
    *   Does not update static fields or `main()`.
    *   Changes to global variables or compiled constants might not be reflected reliably.
    *   Sometimes complex state changes might require a restart.

### Hot Restart (🔄 `Ctrl+Shift+\` or Restart Icon in IDE)

*   **What it does:** Destroys the current Dart VM and creates a new one, recompiling your application code and restarting the Flutter app from scratch.
*   **State:** **Discards** the current application state. The app restarts as if it were freshly launched. Variables are reset to their initial values, `initState` runs again.
*   **Speed:** Slower than Hot Reload (a few seconds typically), but much faster than a full rebuild and reinstall (Cold Boot).
*   **Use Cases:**
    *   When changes aren't reflected by Hot Reload (e.g., after modifying `initState`, static fields, global variables, or `main()`).
    *   When you want to test the app's startup sequence or initial state logic.
    *   After adding new dependencies (`pub get` might require a restart).
    *   If the app's state becomes corrupted or behaves unexpectedly after multiple hot reloads.

**In Summary:** Use **Hot Reload** frequently for rapid iteration on UI and simple logic. Use **Hot Restart** when needed to apply deeper changes or reset the application state.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details (if one exists in the repo) or refer to the standard MIT License text: [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)

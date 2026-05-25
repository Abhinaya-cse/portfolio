# 🚀 Abhinaya B — Flutter Portfolio App

A production-grade Flutter portfolio app to showcase your skills in interviews.

---

## ✨ Features

- **Home / About** — Animated intro, education card, achievements, certifications
- **Projects** — Hero animated project cards with full detail pages (AHCRM, SALESCRM, Smart Serve, EVENTVISTAS)
- **Skills** — Circular + linear animated progress indicators with category filtering
- **Experience** — Beautiful vertical timeline of all internships & work
- **Contact** — Firebase-ready contact form + LinkedIn/GitHub/Email quick links
- **Dark/Light theme** — Toggle persisted via SharedPreferences

---

## 📁 Project Structure

```
lib/
├── main.dart                   # Entry point, theme provider
├── theme/
│   └── app_theme.dart          # Dark & light ThemeData
├── data/
│   └── portfolio_data.dart     # All your real content here
├── models/
│   └── models.dart             # Project, Experience, Skill models
├── screens/
│   ├── main_nav_screen.dart    # Bottom nav bar
│   ├── home_screen.dart        # About + Education + Achievements
│   ├── projects_screen.dart    # Project cards + hero detail
│   ├── skills_screen.dart      # Animated skill bars
│   ├── experience_screen.dart  # Timeline
│   └── contact_screen.dart     # Contact form
└── widgets/
    └── section_header.dart     # Shared widgets (SectionHeader, ChipTag)
```

---

## 🛠 Setup

### 1. Flutter Setup
```bash
flutter create --project-name abhinaya_portfolio .
# Replace the generated lib/ with this project's lib/
# Copy pubspec.yaml
flutter pub get
```

### 2. Run the app
```bash
flutter run
```

---

## 🔥 Firebase Integration (Optional but impressive!)

### Step 1 — Create Firebase project
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create project → Add Android/iOS app
3. Download `google-services.json` → place in `android/app/`

### Step 2 — Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Step 3 — Update main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ...rest of main
}
```

### Step 4 — Enable Contact Form (contact_screen.dart)
Uncomment the Firestore block in `_send()`:
```dart
await FirebaseFirestore.instance.collection('messages').add({
  'name': _nameCtrl.text,
  'email': _emailCtrl.text,
  'message': _msgCtrl.text,
  'timestamp': FieldValue.serverTimestamp(),
});
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `firebase_core` | Firebase initialization |
| `cloud_firestore` | Contact form messages |
| `shared_preferences` | Dark/light theme persistence |
| `url_launcher` | Open LinkedIn, GitHub, Email |
| `google_fonts` | DM Sans font |
| `animate_do` | Fade/slide entry animations |
| `percent_indicator` | Skill progress bars |
| `timeline_tile` | Experience timeline |

---

## 🎨 Customization

All content lives in **`lib/data/portfolio_data.dart`** — just edit your name, bio, projects, skills, etc. there. No need to touch the UI code.

---

## 💡 Interview Tips

1. Run on your phone (not just emulator) — more impressive
2. Open the Projects screen and tap a project → show the hero animation
3. Go to Skills and switch between categories — shows interactivity
4. Point out: *"The theme toggle is persisted via SharedPreferences"*
5. Show the Contact form: *"This sends to Firestore in production"*
6. Mention: *"I built the actual apps shown here — AHCRM and SALESCRM are in production"*

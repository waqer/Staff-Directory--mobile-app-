# 📱 Staff Directory — Flutter App

A clean, easy-to-use employee contact directory for 100 employees with search, filtering, emergency support, and real-time status tracking.

---

## ✨ Features

| Feature | Details |
|---|---|
| 👥 Employee List | 100 pre-loaded employees with full details |
| 🔍 Smart Search | Search by name, department, or designation |
| 🎛️ Filters | Filter by department, designation, and status |
| 📊 Status Tracking | On Duty / On Leave / Home with live indicator |
| 📞 Contact Info | Mobile, landline extension, email |
| 🩸 Blood Group | Shown on card & searchable in emergency screen |
| 🆘 Emergency Screen | Hotlines, leadership contacts, blood group directory |
| 📋 Copy to Clipboard | Tap any phone/email to copy instantly |
| 👔 Designations | 9 levels: Junior Executive → CEO |
| 🏢 Departments | Finance, HR, IT, Marketing, Sales, Admin, Operations |

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extension

### Steps

```bash
# 1. Create a new Flutter project (or use existing)
flutter create employee_contacts
cd employee_contacts

# 2. Replace the lib/ folder with the provided files

# 3. Replace pubspec.yaml with the provided file

# 4. Install dependencies
flutter pub get

# 5. Run on your device or emulator
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── theme/
│   └── app_theme.dart                 # Colors, theme, designation colors
├── models/
│   └── employee.dart                  # Employee model + enums
├── data/
│   └── sample_data.dart               # 100 sample employees + departments list
├── screens/
│   ├── employee_list_screen.dart      # Main list with search & filter
│   ├── employee_detail_screen.dart    # Full employee profile
│   └── emergency_screen.dart         # Emergency hotlines & support
└── widgets/
    └── employee_card.dart             # Reusable employee list card
```

---

## 🎨 UI Overview

### Home Screen
- Stats bar: Total / On Duty / On Leave / Home counts
- Search bar with clear button
- Filter button (department + designation + status)
- Active filter chips with individual remove buttons
- Card list with avatar, name, designation, department, ext, blood group, status dot

### Employee Detail
- Gradient hero header with initials avatar
- Status card with quick change button
- Info tiles: ID, blood group, department, extension
- Contact cards: mobile, landline, email (with copy)
- Emergency contact section (name, relation, phone)

### Emergency Screen
- Emergency hotlines (999, 199, 16430, 100, company)
- Leadership contacts (CEO, COO, Senior Managers)
- Blood group directory (expandable by blood type)
- Safety guidelines

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  url_launcher: ^6.2.4       # For future call/email launch
  shared_preferences: ^2.2.2 # For future persistent storage
```

---

## 📲 To Add Real Phone/Email Calling

Replace copy actions with `url_launcher` calls:

```dart
// Call
await launchUrl(Uri.parse('tel:${employee.phoneNumber}'));

// Email
await launchUrl(Uri.parse('mailto:${employee.email}'));
```

---

## 🔒 Android Permissions (android/app/src/main/AndroidManifest.xml)

Add before `<application>` tag if using url_launcher for calls:

```xml
<uses-permission android:name="android.permission.CALL_PHONE"/>
<queries>
  <intent>
    <action android:name="android.intent.action.DIAL" />
    <data android:scheme="tel" />
  </intent>
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="mailto" />
  </intent>
</queries>
```

---

## 🌟 Customization

- **Add real employees**: Edit `lib/data/sample_data.dart`
- **Add departments**: Add to `allDepartments` list in `sample_data.dart`
- **Change colors**: Edit `lib/theme/app_theme.dart`
- **Add more designations**: Add to `Designation` enum in `employee.dart`

---

*Built with Flutter 💙*

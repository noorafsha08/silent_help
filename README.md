# 🚨 Silent Help – Voice Activated Emergency SOS App

A modern Android safety app enabling **hands-free emergency alerts** using **voice trigger, shake detection, and back tap gestures** with offline SMS fallback for low network areas.

---

## 📋 Prerequisites

- Android Studio (latest stable)
- Java/Kotlin SDK
- Android SDK (API level 21+)
- PocketSphinx or Vosk (offline speech recognition)
- Physical or emulator device with microphone, SMS, and location permissions

---

## 🛠️ Installation

### ⚙️ Clone the repository:

```bash
git clone https://github.com/yourusername/silent-help.git
cd silent-help
````

---

### 🚀 Build & Run

* Open in **Android Studio**
* Build the project
* Run on **emulator or physical device**

---

## 📁 Project Structure

```
silent_help/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/yourusername/silenthelp/
│   │   │   │   ├── activities/       # Screens
│   │   │   │   ├── services/         # Background services
│   │   │   │   ├── utils/            # Utility classes
│   │   │   │   ├── database/         # Room DB for history
│   │   │   │   └── MainApplication.java
│   │   │   └── res/
│   │   │       ├── layout/           # XML layouts
│   │   │       └── drawable/         # Icons and images
│   │   └── AndroidManifest.xml
│   └── build.gradle
├── build.gradle
└── README.md
```

---

## 📋 App Screens

1. **Splash Screen** – App logo and branding
2. **User Registration** – User details and PIN setup
3. **Emergency Contacts Management** – Add/edit contacts
4. **Voice Trigger Setup** – Set secret keyword with speaker verification
5. **Main Dashboard** – App status, test trigger, settings

---

## 🔒 Key Features

* 🎙️ **Voice Activation**

  * Secret keyword detection with speaker verification

* ✋ **Shake Detection**

  * Shake phone thrice to trigger SOS silently

* 👆 **Back Tap Trigger**

  * Tap back of phone thrice rapidly for stealth activation

* 📍 **Emergency SMS with Location**

  * Sends distress message + live Google Maps link

* 📡 **Offline SMS Fallback**

  * Works in low network areas without internet

---

## 🎨 Theming

* **Material Design**
* Light/Dark mode compatibility
* Stealth UI (no popup or vibration on trigger)

---

## 📱 Permissions Required

* RECORD\_AUDIO
* SEND\_SMS
* ACCESS\_FINE\_LOCATION
* FOREGROUND\_SERVICE
* BIND\_ACCESSIBILITY\_SERVICE

---

## 🚀 Deployment

### ⚙️ Build for release:

```bash
./gradlew assembleRelease
```

---

### 🚀 Generate signed APK:

* In **Android Studio**, go to Build > Generate Signed APK

---

## 💡 Future Enhancements

* 📞 Fake call feature for tactical escape
* ⌚ Smart wearable integration
* 🧠 Tone stress analysis for auto detection
* 🚓 Police API integration (where available)

---

## 🙏 Acknowledgements

* **Android Studio** – IDE
* **PocketSphinx/Vosk** – Offline speech recognition
* **Material Design** – UI principles

---

## ❤️ Built With

Built with passion to ensure **safety and silent emergency support** for vulnerable users using modern Android and AI technologies.

---

## 👤 Author

**Noor Afsha**
Final Year B.Tech CSE | Software Engineering & Cybersecurity Enthusiast

[LinkedIn](https://www.linkedin.com/in/your-profile) | [Portfolio](https://your-portfolio-link.com)

---

## 📄 License

Licensed under the [MIT License](LICENSE).

---

## 🤝 Contributions

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add some AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## ⭐ Support

If you like this project, please ⭐ star it and share to support development.

---

```

---

### ✅ **Instructions**
- Replace:
  - `https://github.com/yourusername/silent-help.git` with your repo link  
  - LinkedIn and portfolio links with your URLs
- Add screenshots after UI implementation if needed.

---

Let me know if you need:

- **Commit message templates**  
- **Short GitHub description**  
- **STAR interview explanation** for Silent Help

I will prepare them systematically today for your portfolio and placements this week.
```

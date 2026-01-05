# 🌿 Plantastic – Your Smart Plant Buddy

Plantastic is an iOS app designed to help plant lovers care for their plants in a simple, reliable, and stress-free way.  
By combining intelligent watering reminders, location-based weather data, and comprehensive plant information, Plantastic turns everyday plant care into an intuitive experience. 🌱☀️

<p align="center">
  <img src="https://github.com/user-attachments/assets/6455931d-bb95-47a4-a188-0388416e110a" width="600"/>
</p>

---

## 🎯 Project Goal

The goal of Plantastic was to solve a common problem many plant owners face:  
keeping track of plant care consistently while considering environmental factors like weather and location.

The focus of this project was to design and build a modern iOS app that:
- feels intuitive and approachable  
- reduces cognitive load through automation  
- combines reliable data sources with a clean user experience  

---

## 📱 App Preview


<p align="center">
  <img src="https://github.com/user-attachments/assets/f899d5f9-a409-4280-a2b1-89d7b7119ffd" width="800"/>
</p>


<p align="center">
  <img src="https://github.com/user-attachments/assets/c1dcae12-dad7-4244-8be1-416a9fce226a" width="800"/>
</p>

---

## ✨ Core Features

- 🌱 **Plant Discovery**  
  Browse a large plant database with detailed care instructions, light requirements, and watering intervals.

- 💧 **Personalized Watering Plans**  
  Track watering history and receive recommendations tailored to each plant.

- 📍 **Weather-Aware Care**  
  Local weather conditions automatically influence watering suggestions.

- 🔔 **Smart Reminders & Calendar**  
  Stay on top of upcoming watering tasks with notifications and a clear calendar overview.

- ☁️ **Cloud-Based User Profiles**  
  Save plants, watering data, and preferences securely using Firebase.

---

## 🛠️ Tech Stack & Architecture

- **Swift & SwiftUI**  
  Modern, declarative UI development following Apple best practices.

- **MVVM Architecture**  
  Clear separation of concerns for maintainable and testable code.

- **WeatherAPI**  
  Location-based weather data (temperature, rainfall, humidity).

- **Perenual API**  
  Comprehensive plant data including care information and images.

- **Firebase**  
  Authentication, cloud storage, and real-time data synchronization.

- **@AppStorage**  
  Lightweight local persistence for UI-related states such as Dark Mode and onboarding flow.

---

## 🔗 API Integration

### 📍 WeatherAPI  
Used to fetch real-time, location-specific weather data in order to improve watering recommendations dynamically.

### 🌱 Perenual API  
Provides detailed plant information such as watering frequency, light requirements, flowering periods, and general care tips.

### 🔐 Firebase  
Handles:
- user authentication  
- persistent storage of favorites and watering data  
- real-time updates across sessions  

---

## 🚀 Future Improvements & Learnings

Plantastic was designed with extensibility in mind. Possible next steps include:

- 🌧 Weather-based watering reminders  
- 🔊 Sound feedback to enhance UX  
- 🌿 Smart care tips (fertilizing, repotting, pruning)  
- 💡 General gardening knowledge and tips  
- 📸 Plant recognition via camera  
- 🏆 Milestones and light gamification to support long-term engagement  
- 🔗 Curated product recommendations  
- 📴 Offline mode for improved flexibility  

---

## 👩‍💻 Author

Developed by **Alex Jäger Peña**

Plantastic was created in **2025** as part of my professional training in **Mobile App Development (iOS)**.  
The project demonstrates my focus on clean SwiftUI architecture, API integration, Firebase-based data handling, and user-centered app design.

© 2025 Alex Jäger Peña

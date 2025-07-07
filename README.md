## 🌿 Plantastic - Plant Buddy

**Plantastic** ist eine iOS-App, die dir dabei hilft, deine Pflanzen optimal zu pflegen – mit personalisierten Bewässerungshinweisen, Standortwetter und umfassenden Pflanzeninfos. 🌱☀️

---

### ✨ Features

- 🪴 Pflanzen entdecken: Durchsuche eine umfangreiche Datenbank mit tausenden von Pflanzenarten und finde detaillierte Informationen zu Pflege, Standort, Gießen und mehr.
- ✨ Favoriten verwalten: Speichere deine Lieblingspflanzen in deinem persönlichen "Garten", um schnellen Zugriff auf ihre spezifischen Pflegeanforderungen zu haben.
- 💧 Individuelle Bewässerungspläne: Protokolliere, wann du deine Pflanzen zuletzt gegossen hast, und erhalte Empfehlungen für die nächste Bewässerung.
- 📍 Wetterintegration: Passe dein Gießverhalten an das lokale Klima an
- 🔔 Automatische Benachrichtigungen: Erhalte eine Push-Nachricht wenn eine Pflanze gegossen werden muss
- 📆 Kalender-Integration: Überblick über deine kommenden Gießaufgaben
- 🔐 Benutzerprofile: Speicherung deiner Favoriten & Gießdaten via Firebase

---

### 🛠 Technologien

| Technologie     | Zweck                                                                           |
|----------------|----------------------------------------------------------------------------------|
| Swift & SwiftUI | App-Entwicklung mit moderner UI & States                                        |
| WeatherAPI      | Standortbasiertes Wetter zur Anpassung des Gießverhaltens                       |
| Perenual API    | Pflanzenspezifische Daten & Pflegeanleitungen                                   |
| @AppStorage	    | Persistente lokale Speicherung für UI-Zustände wie Dark Mode oder Intro-Screens |
---

### 📲 Voraussetzungen

- iOS 18 oder neuer
- Internetverbindung (für API-Zugriff & Firebase)
- Berechtigung für Push-Benachrichtigungen

---

### 🔗 API-Integration

#### 📍 [WeatherAPI](https://api.weatherapi.com/)
Die App nutzt Wetterdaten (Temperatur, Niederschlag, Luftfeuchtigkeit), damit du sehen kannst, ob deine Pflanzen heute gegossen werden sollten. Das macht die Gießentscheidungen smarter.

#### 🌱 [Perenual API](https://perenual.com/api/)
Diese API liefert Daten zu tausenden Pflanzenarten: Standortansprüche, Gießintervalle, Sonnenverträglichkeit, Blütezeit und vieles mehr – direkt in der App integriert.

#### 🔐 [Firebase](https://firebase.google.com/)
- Speicherung der Nutzerdaten & Favoriten in der Firestore-Datenbank
- Authentifizierung von Nutzer:innen
- Realtime-Updates bei Änderungen am Pflanzenbestand
- Speicherung von Gießverlauf und nächsten Terminen

---

### 📱 Screenshots

![screenshotsGit](https://github.com/user-attachments/assets/7d2e3e97-b4b6-48c2-b501-263470085c3c)

---

### 🔧 Weiterentwicklungsideen

- 🌤 Anpassung der Bewässerungsempfehlungen an die aktuellen Wetterbedingungen (Regen, Temperatur, Luftfeuchtigkeit)
- ⛅️ Wettervorhersage für die nächsten 3 Tage
- 🎶 Sound für verbesserte UX - z.B. bei Klick auf den Bewässern-Button
- 🎍 Intelligente Pflegeempfehlungen und automatische Benachrichtigungen zu Düngen, Umtopfen oder Schnitt
- 💡 Nützliche Tipps und Tricks zum Thema Gardening allgemein
- 📷 Nutzer:innen können eigene Fotos ihrer Pflanzen hinzufügen
- 📸 Pflanzenerkennung per Kamera-Integration
- 🏁 Erweiterte Meilensteine für interaktive Nutzererfahrung und Langzeitmotivation
- 🎯 Nutzer:innen können durch das Erreichen von Meilensteinen Credits sammeln, um z.B. einen Baum zu pflanzen
- 🔗 Links zu Produktempfehlungen

---

Viel Spaß beim Pflegen deiner Pflanzen mit Plantastic! 💚

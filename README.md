# 🌿 Plantastic - Plant Buddy

**Plantastic** ist eine iOS-App, die dir dabei hilft, deine Pflanzen optimal zu pflegen – mit personalisierten Bewässerungshinweisen, Standortwetter und umfassenden Pflanzeninfos. 🌱☀️

---

## ✨ Features

- 🪴 Pflanzen entdecken: Durchsuche eine umfangreiche Datenbank mit tausenden von Pflanzenarten und finde detaillierte Informationen zu Pflege, Standort, Gießen und mehr.
- ✨ Favoriten verwalten: Speichere deine Lieblingspflanzen in deinem persönlichen "Garten", um schnellen Zugriff auf ihre spezifischen Pflegeanforderungen zu haben.
- 💧 Individuelle Bewässerungspläne: Protokolliere, wann du deine Pflanzen zuletzt gegossen hast, und erhalte Empfehlungen für die nächste Bewässerung.
- 📍 Wetterintegration: Passe dein Gießverhalten an das lokale Klima an
- 🔔 Automatische Benachrichtigungen: erhalte eine Push-Nachricht wenn eine Pflanze gegossen werden muss
- 📆 Kalender-Integration: Überblick über deine kommenden Gießaufgaben
- 🔐 Benutzerprofile: Speicherung deiner Favoriten & Gießdaten via Firebase

---

## 🛠 Technologien

| Technologie     | Zweck                                              |
|----------------|----------------------------------------------------|
| Swift & SwiftUI | App-Entwicklung mit moderner UI & States          |
| WeatherAPI      | Standortbasiertes Wetter zur Gießempfehlung       |
| Perenual API    | Pflanzenspezifische Daten & Pflegeanleitungen     |
| Firebase        | Nutzerverwaltung, Cloudspeicher, Realtime-Updates |

---

## 📲 Voraussetzungen

- iOS 18 oder neuer
- Internetverbindung (für API-Zugriff & Firebase)
- Berechtigung für Push-Benachrichtigungen

---

## 🔗 API-Integration

### 📍 [WeatherAPI](https://api.weatherapi.com/)
Die App nutzt Wetterdaten (Temperatur, Niederschlag, Luftfeuchtigkeit), damit du sehen kannst, ob deine Pflanzen heute gegossen werden sollten. Das macht die Gießentscheidungen smarter.

### 🌱 [Perenual API](https://perenual.com/api/)
Diese API liefert Daten zu tausenden Pflanzenarten: Standortansprüche, Gießintervalle, Sonnenverträglichkeit, Blütezeit und vieles mehr – direkt in der App integriert.

### 🔐 [Firebase](https://firebase.google.com/)
- Speicherung der Nutzerdaten & Favoriten in der Firestore-Datenbank
- Authentifizierung von Nutzer:innen
- Realtime-Updates bei Änderungen am Pflanzenbestand
- Speicherung von Gießverlauf und nächsten Terminen

---

## 🔧 Weiterentwicklungsideen

- 🌤 Anpassung der Bewässerungsempfehlungen an die aktuellen Wetterbedingungen (Regen, Temperatur, Luftfeuchtigkeit)
- 🎍 Intelligente Pflegeempfehlungen und automatische Benachrichtigungen zu Düngen, Umtopfen oder Schn
- 💡 Nützliche Tipps und Tricks zum Thema Gardening
- 📷 Nutzer:innen können eigene Fotos ihrer Pflanzen hinzufügen
- 📸 Pflanzenerkennung per Kamera-Integration
- 🎯 Nutzer:innen können durch das Erreichen von Meilensteinen Credits sammeln, um z.B. einen Baum zu pflanzen

---

Viel Spaß beim Pflegen deiner Pflanzen mit Plantastic! 💚

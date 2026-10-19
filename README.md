# eFizio

**Mobile therapy & patient management for iOS**

![Swift](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-0A84FF)
![iOS](https://img.shields.io/badge/iOS-16.0%2B-000000?logo=apple&logoColor=white)
![Firebase](https://img.shields.io/badge/Backend-Firebase%20Firestore-FFCA28?logo=firebase&logoColor=black)

**eFizio** je nativna iOS aplikacija napisana u **SwiftUI**-u, namijenjena vođenju fizioterapeutske prakse, zakazivanju termina i vođenju kartona pacijenata za tretmane hidžame (cupping terapija). Podaci se sinhronizuju sa **Firebase Firestore** bazom u realnom vremenu, a za svaki termin aplikacija automatski zakazuje lokalne podsjetnike.

---

## Sadržaj

- [Funkcionalnosti](#funkcionalnosti)
- [Tehnologije](#tehnologije)
- [Struktura projekta](#struktura-projekta)
- [Pokretanje](#pokretanje)
- [Napomene](#napomene)
- [Autor](#autor)

---

## Funkcionalnosti

| Funkcionalnost | Opis |
|---|---|
| **Upravljanje terminima** | Pregled, pretraga i brisanje zakazanih termina uz ažuriranje u realnom vremenu |
| **Trajna historija pacijenata** | Zdravstveni kartoni i historija tretmana čuvaju se nezavisno od rasporeda u kalendaru |
| **Lokalni podsjetnici** | Automatske notifikacije 30, 15, 10, 5 i 1 minut prije termina |
| **Svijetla / tamna tema** | Prilagođeni `ThemeToggleButton`, izbor se pamti preko `@AppStorage` |
| **Brza pretraga** | Pretraga termina po imenu pacijenta direktno u sučelju |
| **Firebase sinhronizacija** | Cloud Firestore sa real-time slušaocima (`addSnapshotListener`) |

<!--
## Screenshotovi

Dodaj slike u folder `docs/screenshots/` i otkomentariraj:

<p align="center">
  <img src="docs/screenshots/home.png" width="240" alt="Pregled termina">
  <img src="docs/screenshots/booking.png" width="240" alt="Zakazivanje termina">
</p>
-->

---

## Tehnologije

| Dio | Tehnologija |
|---|---|
| Jezik | Swift 5.9 |
| UI | SwiftUI |
| Baza | Firebase Firestore |
| Notifikacije | `UserNotifications` (`UNUserNotificationCenter`) |
| Arhitektura | MVVM, Repository pattern |
| Minimalni OS | iOS 16.0 |
| Zavisnosti | Swift Package Manager (FirebaseCore, FirebaseFirestore) |

---

## Struktura projekta

```text
eFizio/
├── Models/
│   └── Appointment.swift               # Model podataka za termin
├── Notifications/
│   └── LocalNotificationManager.swift  # Upravljanje lokalnim podsjetnicima
├── Repository/
│   └── FizioRepository.swift           # Firestore sinhronizacija i CRUD operacije
├── Views/
│   ├── HomeView.swift                  # Pregled termina i pretraga
│   ├── BookingView.swift               # Zakazivanje novog termina
│   └── ThemeToggleButton.swift         # Prebacivanje teme
└── eFizioApp.swift                     # Ulazna tačka aplikacije i Firebase konfiguracija
```

---

## Pokretanje

### Zahtjevi

- Xcode 15.0 ili novija verzija
- macOS Sonoma ili novija verzija
- Firebase projekat sa uključenim Firestore-om

### Instalacija

**1. Kloniraj repozitorij**

```bash
git clone https://github.com/TVOJ-USERNAME/eFizio-iOS.git
cd eFizio-iOS
```

**2. Podesi Firebase**

1. Kreiraj projekat u [Firebase Console](https://console.firebase.google.com/).
2. Dodaj iOS aplikaciju sa svojim *Bundle Identifier*-om.
3. Preuzmi `GoogleService-Info.plist` i dodaj ga u Xcode projekat (uz čekiranu opciju *Copy items if needed*).

**3. Pokreni aplikaciju**

1. Otvori `eFizio.xcodeproj` u Xcodeu.
2. Sačekaj da Xcode preuzme zavisnosti (FirebaseCore, FirebaseFirestore).
3. Odaberi simulator ili povezani iPhone i pokreni sa `Cmd + R`.

---

## Napomene

- **Privatnost podataka:** aplikacija radi sa podacima pacijenata. Prije stvarne upotrebe podesi **Firebase Security Rules** tako da pristup bazi imaju samo ovlašteni korisnici.
- **Konfiguracija:** `GoogleService-Info.plist` sadrži podatke tvog Firebase projekta. Ako je repozitorij javan, razmisli da ga ne objavljuješ.
- **Ograničenje notifikacija:** iOS dozvoljava najviše 64 istovremeno zakazane lokalne notifikacije. Sa pet podsjetnika po terminu to pokriva otprilike 12 nadolazećih termina.

---

## Autor

**Kemal Beganović**

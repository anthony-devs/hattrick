# Hattrick ⚽💰
### Sports Quiz-to-Earn Mobile App

A high-stakes football trivia app that rewards deep sports knowledge with real cash prizes. Built under contract for TIJE COMMS TECH as a sole contractor — owned end-to-end from architecture to release.

![Flutter](https://img.shields.io/badge/Flutter-Expert-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white)

---

## What It Does

Hattrick transforms football knowledge into real financial rewards through a structured quiz-to-earn model. Players answer 10 timed questions (15 seconds each) across multiple prize tiers — all built around a deliberately difficult 70/30 hard/easy question ratio to ensure genuine winners.

### Prize Structure
| Mode | Requirement | Prize |
|---|---|---|
| Instant Cash | 10/10 correct in one session | ₦10,000 |
| Hattrick Jackpot | Win ₦10,000 three consecutive times | ₦1,000,000 |
| Monthly Marathon | Top 10 scorers over 30 days | ₦100,000 each |
| Grand Prize | 800+ Marathon points | ₦10,000,000 |

---

## Technical Architecture

### Quiz Engine
- **1,000+ questions** at launch, designed to scale to 5,000+
- **Difficulty ratio** engineered at 70% Hard / 30% Easy via backend probability logic
- **Two-table database** structure separating Easy and Hard question pools
- **15-second countdown timer** per question with automatic submission on timeout

### Key Features
- Real-time score display after each session
- Virtual wallet system for tracking and withdrawing winnings
- Paystack payment gateway integration for Nigerian market
- NIN (National Identification Number) verification at signup
- Referral system — 2 free coins per successful referral subscription
- Subscription tiers for Practice Quiz access (Daily / Weekly / Monthly)
- Coin purchase system for extended play

### Auth & Security
- Google, Facebook, and Email/Password sign-up
- NIN verification layer to prevent fraud
- Built with security-first mindset against hacking and session hijacking

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter, Dart |
| State Management | BLoC |
| Local Storage | Hive (offline-first) |
| Backend | Python / Flask |
| Database | Firebase Firestore |
| Auth | Firebase Authentication |
| Payments | Paystack |
| Real-time | Firebase real-time listeners |

---

## Performance Highlights

- **35% reduction** in app load times through BLoC state management, Hive caching, and asset optimization
- **900ms → 180ms** average API response time after backend query optimization
- **99.9% crash-free sessions** in production
- Reliable offline-first experience for users in low-connectivity environments

---

## My Role

Sole developer and contractor. Responsibilities included:
- Full system architecture design (Clean Architecture + MVVM)
- Flutter UI development from Figma designs
- Flask backend API development and optimization
- Firebase Firestore schema design and real-time integration
- Paystack payment gateway integration
- BLoC state management implementation
- Offline-first data strategy using Hive
- App release and deployment

---

## Getting Started

```bash
git clone https://github.com/anthony-devs/hattrick
cd hattrick
flutter pub get
flutter run
```

> Note: You'll need your own Firebase project and Paystack credentials configured in the environment.

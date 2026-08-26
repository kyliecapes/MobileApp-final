Original App Design Project - README
===

# Bloom

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Bloom is a personal self-care and habit-tracking mobile application designed to help users stay consistent with daily wellness routines. Users can track self-care habits like hydration, sleep, journaling, mindfulness, and workouts. Bloom visualizes progress through streaks, charts, and aesthetic icons that make improvement feel rewarding.
The app also includes an AI-powered suggestions feature, where users enter their goals, and the system generates personalized habit-building tips using an LLM (OpenAI).

Bloom’s purpose is to make everyday self-care more engaging, motivating, and meaningful — turning consistent habits into a personal growth journey.

### App Evaluation
- **Category:** Health and Wellness
- **Mobile:** Designed as a mobile-first experience with quick daily logging, push reminders (optional), on-device tracking, camera support for progress photos (optional), and visual dashboards optimized for handheld use.
- **Story:**  Bloom tells the story of personal growth through small, consistent actions. It supports mental, physical, and academic wellness through easy daily routines and aesthetic feedback. It turns wellness into a rewarding ritual.
- **Market:** Targeted toward students, young adults, and anyone seeking structure in their self-care routine. The wellness market is large and growing, with strong demand for habit-building tools.
- **Habit:** Designed for daily use, sometimes multiple times per day. Users actively create data (entries, notes) and review streaks and insights.
- **Scope:** V1 can include 3–5 daily habits, a minimal dashboard, mood logging, and simple visuals—very achievable within the course timeline. V2 could add AI habit recommendations, editable habits, and enhanced graphics. V3 could incorporate rewards, more customization, or long-term insights. Even a stripped-down prototype communicates the full vision effectively.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register for an account
* User can log in / log out
* User can select 3-5 daily self-care habits
* User can track dailt habit completion
* User can add optional notes to dailt entries
* User can viw a Progress dashboard showing streaks, completion %, and trends
* User can recieve AI-generated habit suggestions based on goals
* User can view historical logs for past days/weeks
* User can edit, add, or delte habits
* User can manage basic profile settings


### 2. Screen Archetypes

- [ X ] [**Register Screen**]
* User can create an account with email, password, display/username
- [ X ] [**Login Screen**]
* User can log into their existing account
- [ X ] [**Habit selection Screen**]
* User selects 3-5 habits to track
* User can add custom habits
- [ X ] [**Home/Daily Tracker Screen**]
* User can mark habits as completed
* User can enter notes
- [ X ] [**Progress Dashboard**]
* User views streaks, completion %, and weekly/monthly trends
- [ X ] [**Ai Suggestions Screen**]
* User enters goals
* App returns personalized tips via LLM
- [ X ] [**Profile/Settings Screen**]
* User updates profile and preferences
* Toggle reminders, theme, privacy options


### 3. Navigation

**Tab Navigation** (Tab to Screen)
- [ X ] Home / Daily Tracker
- [ X ] Dashboard
- [ X ] Ai Suggestions
- [ X ] Profile

**Flow Navigation** (Screen to Screen)

- [ X ] [**Register Screen**]
  * Leads to [**Login Screen -> Habit Selection**]
- [ X ] [**Home Screen**]
  * Leads to [**Habit Detail -> Dashboard**] 
- [ X ] [**Dashboard**]
  * Leads to [**History View**]
- [ X ] [**Profile**]
  * Leads to [**Edit profile / Reminders**]
- [ X ] [**Ai Suggestions**]
  * Leads to [**Optional notes save**]


## Wireframes

![IMG_5826 (1)](https://github.com/user-attachments/assets/b97c3e47-e4cc-4d1d-ac14-a8be2c360b7f)


### Digital Wireframes & Mockups
<img width="206" height="458" alt="image" src="https://github.com/user-attachments/assets/e067b002-3700-4d0f-bb85-50b588b249e1" />
<img width="213" height="454" alt="image" src="https://github.com/user-attachments/assets/6ce90eb6-67ee-42ae-84d1-d88d5c730d64" />
<img width="206" height="450" alt="image" src="https://github.com/user-attachments/assets/a0360917-0a23-40b0-acdc-ec2e818754f4" />
<img width="201" height="446" alt="image" src="https://github.com/user-attachments/assets/8da36839-af49-4816-857f-98fed0d15c74" />
<img width="204" height="454" alt="image" src="https://github.com/user-attachments/assets/662f9a35-08b0-4663-a2bd-9ac5c5b18dea" />
<img width="207" height="450" alt="image" src="https://github.com/user-attachments/assets/f435668c-71ed-4169-8eba-029b13a80431" />
<img width="208" height="451" alt="image" src="https://github.com/user-attachments/assets/b931164d-bb75-4b96-9c9f-e14c552cc906" />



## Progress after Sprint 1:

![Simulator Screen Recording - iPhone 16 Pro - 2025-11-30 at 16 04 34](https://github.com/user-attachments/assets/ff7e293d-b471-4f4a-bf76-56be4e405fa5)


## Login/Signup integration with backend
Image of Login/Signup UI in Bloom app, where users enter their email and password.

<img width="287" height="603" alt="image" src="https://github.com/user-attachments/assets/5adf8f11-df31-429f-89b0-18b7798f3a44" />
<img width="290" height="588" alt="image" src="https://github.com/user-attachments/assets/0ddd42ff-8786-4bc6-8e4f-8fa33c116bac" />

Image shows the Users tab in FireBase Auth, where each registered account is stored securely in the backend.

<img width="1219" height="582" alt="image" src="https://github.com/user-attachments/assets/799505ba-af4b-456a-8a5c-7937ec1c91a6" />

## Working use of External API
In the create entry tab, user enters one or more wellness golas and submits them.

<img width="301" height="588" alt="image" src="https://github.com/user-attachments/assets/881de4e2-46c4-464f-b8a2-f6ab03642310" />

This is the Ai Tips tab where the app shows Ai-generated suggestions related to those goals. The app is structured to call an external api (OpenAi). If integration is fully implemented in the AiTipsService swift file.

<img width="278" height="597" alt="image" src="https://github.com/user-attachments/assets/513af9af-196c-4203-9521-d55975c6390f" />

## Backend Usage for Data / Images (Firebase/Parse)
These images show how the app lets users manage their habits and log daily progress.

<img width="290" height="595" alt="image" src="https://github.com/user-attachments/assets/0054983e-26ad-4cdf-a997-577eb76ed15f" />
<img width="289" height="590" alt="image" src="https://github.com/user-attachments/assets/9f38ebbc-c433-41d9-9f67-156f73a4cf28" />

Bloom uses Firebase Firestore to store all user-specific data. This ensures that data persists across app launches and is scoped per authentication user.

<img width="1264" height="613" alt="image" src="https://github.com/user-attachments/assets/c11bebb5-9ecd-41f2-9792-dd046eb038e4" />
Habits (name, completion state, etc.), under user/{uid}/habits.

<img width="1238" height="349" alt="image" src="https://github.com/user-attachments/assets/ba432a15-9476-43c4-8f75-63f5b7132c67" />
Daily Entries (value + notes for each habit) under users/{uid}/dailyEntries.

<img width="1232" height="499" alt="image" src="https://github.com/user-attachments/assets/6de7596f-8a74-4f85-94ff-e19f710fff06" />
Ai tips under users/{uid}/aiTips.

<img width="1270" height="383" alt="image" src="https://github.com/user-attachments/assets/069a7264-acd6-4d3a-a1d7-7fb6168c6b2f" />



## Full app demo:
https://www.youtube.com/watch?v=1k2eP05v_90

## Schema 

### Models

[User]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| username/id | String | unique identifier |
| email | String | Login email   |
| DisplayName      | String    | Visible name |
| PreferredHabits | Array | User-selected habits |
| Goals | String | Stored goals for Ai suggestions |
| CreatedAt | Date | Creation timestamp |

[Habit]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id | String | Habit ID |
| userid | String | Owner of habit   |
| name      | String    | Habit name |
| targetType | String | ex. "minutes", "hours" |
| archived | Boolean | Whether habit is archived |
| CreatedAt | Date |  timestamp |

[HabitEntry]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id | String | Entry ID |
| habitid | String | Linked habit   |
| date     | String    | "YYYY-MM-DD" |
| value | String | Numeric completion value |
| note | String | Optional notes |
| CreatedAt | Date |  timestamp |

[SreakSummary]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| currentStreak| Int | Ongoing streak |
| longestStreak | Int | Record streak   |
| completionRate      | Float    | Percentage completed |
| weeklyTrend | Map | Trend counts by day |

    
### Networking
**Auth**
- `[POST] /register` - create acount
- `[POST] /login` - authenticate user
- `[POST] /logout` - end session

Habits
- `[GET] /habits` - fetch user's habits
- `[POST] /habits` - create new habit
- `[PUT] /habits/{id}` - edit habit
- `[DELETE] /habits/{id}` - delete habit

Entries
- `[POST] /entries` - add daily habit entry
- `[GET] /entries?date=` - fetch entries for a day
- `[GET] /entries/history` - view past logs

Dashboard / Analytics
- `[GET] /analytics/streaks` - compute streaks
- `[GET] /analytics/completion` - get completion %
- `[GET] /analytics/trends` - weekly/monthly chart data

Ai Suggestions
- `[POST] /ai/suggestions`
- `Body: {goals, recentEntries}`
- `Return: [tips]` from LLM


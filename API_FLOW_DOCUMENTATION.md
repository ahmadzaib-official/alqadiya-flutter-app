# Game Flow API Documentation

This document explains how the user-facing APIs work together to support the complete game experience based on the Figma screenshots.

## Overview

The game flow follows this sequence:
1. **Game Discovery & Session Creation**
2. **Cutscenes & Introduction**
3. **Gameplay - Suspects & Evidence**
4. **Questions & Answers**
5. **Scoreboard (During Game)**
6. **Game Result (After Completion)**

---

## 1. Game Discovery & Session Creation

### Flow:
```
User browses games → Selects a game → Creates/Joins session → Game starts
```

### APIs Used:

#### 1.1 Get All Games
```
GET /games
```
- **Purpose**: Browse available games
- **Response**: List of games with titles, descriptions, cover images
- **Use Case**: Home screen, game selection screen

#### 1.2 Get Game by ID
```
GET /games/:gameId?language=en
```
- **Purpose**: Get detailed game information
- **Response**: Game details including description, duration, difficulty
- **Use Case**: Game detail screen before starting

#### 1.3 Create Game Session
```
POST /game-sessions
Body: { gameId, mode, timeLimitMinutes, maxPlayers }
```
- **Purpose**: Host creates a new game session
- **Response**: Session with sessionCode
- **Use Case**: Host starts a new game

#### 1.4 Join Session
```
POST /game-sessions/join-player
Body: { sessionCode }
```
- **Purpose**: Player joins an existing session
- **Response**: Player details
- **Use Case**: Players enter session code to join

#### 1.5 Get Session Details
```
GET /game-sessions/:sessionId/details
```
- **Purpose**: Get session info with players and teams
- **Response**: Session, players list, teams (if team mode)
- **Use Case**: Waiting room, session overview

---

## 2. Cutscenes & Introduction

### Flow:
```
Game starts → Intro cutscene → Clue reveal cutscenes → Gameplay begins
```

### APIs Used:

#### 2.1 Get Cutscenes by Game ID
```
GET /cutscenes/game/:gameId?language=en
```
- **Purpose**: Get all cutscenes for the game in order
- **Response**: Array of cutscenes sorted by `order` field
- **Use Case**: 
  - Show intro cutscene when game starts
  - Show clue reveal cutscenes when new clues are discovered
  - Show transition cutscenes between game phases

**Response Example:**
```json
[
  {
    "id": "cutscene-1",
    "title": "The Crime Scene",
    "content": "A mysterious crime has occurred...",
    "type": "intro",
    "mediaType": "video",
    "mediaUrl": "https://...",
    "isSkippable": true,
    "order": 1
  },
  {
    "id": "cutscene-2",
    "title": "New Clue Revealed",
    "type": "clue_reveal",
    "order": 2
  }
]
```

#### 2.2 Get Cutscene by ID
```
GET /cutscenes/:cutsceneId?language=en
```
- **Purpose**: Get specific cutscene details
- **Response**: Single cutscene with media URLs
- **Use Case**: Replay a specific cutscene, show cutscene viewer

**Frontend Flow:**
1. Call `/cutscenes/game/:gameId` when game starts
2. Display cutscenes in order (order: 1, 2, 3...)
3. Show "Skip" button if `isSkippable: true`
4. Auto-play if `autoPlay: true`
5. When clue is revealed, show cutscene with `type: "clue_reveal"`

---

## 3. Gameplay - Suspects & Evidence

### Flow:
```
View suspects list → Select suspect → View suspect details → View evidence → Answer questions
```

### 3.1 Suspects APIs

#### Get Suspects by Game ID
```
GET /suspects/game/:gameId?page=1&limit=10
```
- **Purpose**: Get list of all suspects in the game
- **Response**: Paginated list of suspects with basic info
- **Use Case**: "List of suspects" screen showing all suspects

**Response Example:**
```json
{
  "data": [
    {
      "id": "suspect-1",
      "nameEn": "Farhan",
      "nameAr": "فرحان",
      "jobEn": "Detective",
      "age": 35,
      "profileImageURL": "https://..."
    },
    {
      "id": "suspect-2",
      "nameEn": "Farida",
      "nameAr": "فريدة",
      "jobEn": "Witness",
      "age": 28,
      "profileImageURL": "https://..."
    }
  ],
  "total": 4,
  "page": 1,
  "limit": 10
}
```

#### Get Suspect by ID
```
GET /suspects/:suspectId
```
- **Purpose**: Get detailed suspect information with all attachments
- **Response**: Full suspect details including:
  - Personal information (bio, age, job)
  - Attachments (videos, images, documents, audio)
  - Investigation reports
- **Use Case**: "Suspect View detail" screens:
  - Personal information tab
  - Attachments tab (videos, images, documents, audio)
  - Investigation report tab

**Response Example:**
```json
{
  "id": "suspect-1",
  "nameEn": "Aomi Rame",
  "nameAr": "أومي رام",
  "age": 54,
  "jobEn": "Unemployed for 10 years",
  "biographyEn": "Overindulgence in financial problems...",
  "profileImageURL": "https://...",
  "attachments": [
    {
      "id": "att-1",
      "attachmentNameEn": "Video 1",
      "attachmentType": "video",
      "mediaUrl": "https://...",
      "thumbnailUrl": "https://..."
    },
    {
      "id": "att-2",
      "attachmentNameEn": "Image 1",
      "attachmentType": "image",
      "mediaUrl": "https://..."
    }
  ],
  "investigationReports": [
    {
      "id": "report-1",
      "attachmentNameEn": "Investigation Report",
      "attachmentType": "investigation_report",
      "mediaUrl": "https://..."
    }
  ]
}
```

**Frontend Flow:**
1. User clicks "View List" → Call `GET /suspects/game/:gameId`
2. Display suspect cards with profile images
3. User clicks a suspect → Call `GET /suspects/:suspectId`
4. Show suspect detail screen with tabs:
   - **Personal information**: Show bio, age, job
   - **Attachments**: Show media by type (videos, images, documents, audio)
   - **Investigation report**: Show investigation documents

---

### 3.2 Evidence/Clues APIs

#### Get Evidences by Game ID
```
GET /evidences/game/:gameId?page=1&limit=10
```
- **Purpose**: Get list of all evidence/clues in the game
- **Response**: Paginated list of evidence
- **Use Case**: "Evidence" list screen

#### Get Evidence by ID
```
GET /evidences/:evidenceId
```
- **Purpose**: Get detailed evidence information with attachments
- **Response**: Full evidence details including:
  - Evidence name and description
  - Profile image
  - Attachments (videos, images, documents, audio)
- **Use Case**: "Clue Detail" screens:
  - Clue Information tab
  - Attachments tab

**Response Example:**
```json
{
  "id": "evidence-1",
  "evidenceName": "Private information about the victim",
  "evidenceNameAr": "معلومات خاصة عن الضحية",
  "description": "The victim had a history of...",
  "profileImageURL": "https://...",
  "attachments": [
    {
      "id": "att-1",
      "attachmentNameEn": "Video",
      "attachmentType": "video",
      "mediaUrl": "https://..."
    },
    {
      "id": "att-2",
      "attachmentNameEn": "Image",
      "attachmentType": "image",
      "mediaUrl": "https://..."
    }
  ]
}
```

**Frontend Flow:**
1. User clicks "Show Evidence" → Call `GET /evidences/game/:gameId`
2. Display evidence list
3. New clue revealed → Show cutscene (`GET /cutscenes/:cutsceneId` with `type: "clue_reveal"`)
4. User clicks evidence → Call `GET /evidences/:evidenceId`
5. Show clue detail screen with:
   - **Clue Information**: Description, discovery date
   - **Attachments**: Media files

---

## 4. Questions & Answers

### Flow:
```
Question appears → User views hint (optional) → User selects answer → Answer submitted → Next question
```

### APIs Used:

#### 4.1 Get Questions by Game ID
```
GET /questions/game/:gameId?language=en&page=1&limit=10
```
- **Purpose**: Get all questions for the game
- **Response**: List of questions with answers and hints
- **Use Case**: Load questions for the game session

#### 4.2 Get Question by ID
```
GET /questions/:questionId?language=en
```
- **Purpose**: Get specific question details
- **Response**: Question with all answer options and hints
- **Use Case**: Display current question

#### 4.3 Submit Answer
```
POST /user-answers
Body: {
  sessionId,
  questionId,
  selectedOptionId,
  timeSpentSeconds,
  hintUsed
}
```
- **Purpose**: Submit user's answer to a question
- **Response**: Answer result (correct/incorrect, points earned)
- **Use Case**: User selects an answer option

**Frontend Flow:**
1. Game session starts → Load questions (`GET /questions/game/:gameId`)
2. Display question with answer options
3. User clicks "Hint" → Hint is shown, `hintUsed: true` when submitting
4. User selects answer → Call `POST /user-answers`
5. Show result (correct/wrong) based on response
6. Update score and move to next question

---

## 5. Scoreboard (During Gameplay)

### Flow:
```
Game in progress → Scoreboard button clicked → Scoreboard displayed → Continue playing
```

### API Used:

#### Get Scoreboard
```
GET /game-sessions/:sessionId/scoreboard
```
- **Purpose**: Get current scores for teams/players
- **Response**: 
  - **Team Mode**: Teams with individual player scores and team totals
  - **Solo Mode**: Individual player scores
  - Remaining time (if time-limited)
- **Use Case**: Scoreboard screen during gameplay

**Response Example (Team Mode):**
```json
{
  "sessionId": "session-1",
  "caseName": "Who did it?",
  "remainingTime": "21:34",
  "teams": [
    {
      "teamId": "team-1",
      "teamName": "Team Da717",
      "teamNumber": 1,
      "teamScore": 14,
      "players": [
        {
          "userId": "user-1",
          "userName": "Me",
          "individualScore": 19
        },
        {
          "userId": "user-2",
          "userName": "Fahd",
          "individualScore": 20
        }
      ]
    },
    {
      "teamId": "team-2",
      "teamName": "Team Moktashif",
      "teamNumber": 2,
      "teamScore": 16,
      "players": [
        {
          "userId": "user-3",
          "userName": "Imam",
          "individualScore": 20
        }
      ]
    }
  ]
}
```

**Response Example (Solo Mode):**
```json
{
  "sessionId": "session-1",
  "caseName": "Who did it?",
  "remainingTime": "21:34",
  "players": [
    {
      "userId": "user-1",
      "userName": "Player 1",
      "individualScore": 45
    },
    {
      "userId": "user-2",
      "userName": "Player 2",
      "individualScore": 38
    }
  ]
}
```

**Frontend Flow:**
1. User clicks "Scoreboard" button during game
2. Call `GET /game-sessions/:sessionId/scoreboard`
3. Display scoreboard:
   - **Team Mode**: Show teams side-by-side with player scores
   - **Solo Mode**: Show ranked player list
   - Show remaining time if applicable
4. User clicks "Continue playing" → Return to game

---

## 6. Game Result (After Completion)

### Flow:
```
Game ends → Final results displayed → Winner announced → Share/Back to main
```

### API Used:

#### Get Game Result
```
GET /game-sessions/:sessionId/result
```
- **Purpose**: Get final game results and winner
- **Response**: 
  - Team/player results with:
    - Total score
    - Time taken
    - Accuracy percentage
    - Hints used
    - Questions answered
    - Suspect chosen (if applicable)
  - Winner information
- **Use Case**: Game result summary screen

**Response Example (Team Mode):**
```json
{
  "sessionId": "session-1",
  "caseName": "Who did it?",
  "gameDisplayId": "GAME-001",
  "teams": [
    {
      "teamId": "team-1",
      "teamName": "Team Da717",
      "leaderName": "Player 1",
      "suspectChosenName": "Farida",
      "totalScore": 22,
      "timeTaken": "01:22:38",
      "accuracy": 89,
      "hintsUsed": 4,
      "questionsAnswered": 8,
      "totalQuestions": 12
    },
    {
      "teamId": "team-2",
      "teamName": "Team Moktashif",
      "leaderName": "Player 2",
      "suspectChosenName": "Aami",
      "totalScore": 18,
      "timeTaken": "01:25:10",
      "accuracy": 75,
      "hintsUsed": 6,
      "questionsAnswered": 7,
      "totalQuestions": 12
    }
  ],
  "winnerTeamId": "team-1",
  "winnerTeamName": "Team Da717",
  "completedAt": "2025-01-15T12:00:00Z"
}
```

**Frontend Flow:**
1. Game session ends (all questions answered or time up)
2. Call `GET /game-sessions/:sessionId/result`
3. Display result screen:
   - Show each team/player's results
   - Highlight winner
   - Show statistics (score, time, accuracy, hints)
   - Show suspect chosen (if applicable)
4. User can:
   - Click "Share result" → Share game results
   - Click "Back to Main Page" → Return to home

---

## Complete Game Flow Sequence

### Example: Complete Game Session

```
1. USER BROWSES GAMES
   GET /games
   → Display game list

2. USER SELECTS GAME
   GET /games/:gameId
   → Show game details

3. HOST CREATES SESSION
   POST /game-sessions
   → Create session, get sessionCode

4. PLAYERS JOIN
   POST /game-sessions/join-player
   → Players join with sessionCode

5. GAME STARTS - INTRO CUTSCENE
   GET /cutscenes/game/:gameId
   → Show intro cutscene (order: 1)

6. GAMEPLAY BEGINS
   GET /suspects/game/:gameId
   → Show suspects list
   
   GET /evidences/game/:gameId
   → Show evidence list
   
   GET /questions/game/:gameId
   → Load questions

7. USER VIEWS SUSPECT
   GET /suspects/:suspectId
   → Show suspect details (bio, attachments, reports)

8. USER VIEWS EVIDENCE
   GET /evidences/:evidenceId
   → Show clue details

9. NEW CLUE REVEALED
   GET /cutscenes/:cutsceneId (type: clue_reveal)
   → Show clue reveal cutscene

10. USER ANSWERS QUESTION
    POST /user-answers
    → Submit answer, get result

11. USER CHECKS SCOREBOARD
    GET /game-sessions/:sessionId/scoreboard
    → Show current scores

12. GAME ENDS
    GET /game-sessions/:sessionId/result
    → Show final results and winner
```

---

## Key Design Patterns

### 1. **Language Support**
- Most endpoints support `?language=en` or `?language=ar`
- Returns content in the requested language
- Examples: `/games/:gameId?language=ar`, `/cutscenes/game/:gameId?language=en`

### 2. **Pagination**
- List endpoints support pagination: `?page=1&limit=10`
- Examples: `/suspects/game/:gameId?page=1&limit=10`

### 3. **Public Endpoints**
- All user-facing endpoints are public (no admin auth required)
- User authentication handled via bearer token in headers

### 4. **Real-time Updates**
- Scoreboard can be polled periodically during gameplay
- Frontend should refresh scoreboard every few seconds

### 5. **Error Handling**
- All endpoints return standard HTTP status codes
- 404 for not found, 400 for bad request, etc.

---

## Frontend Integration Tips

1. **Cache Game Data**: Load suspects, evidence, and questions at game start
2. **Poll Scoreboard**: Refresh scoreboard every 5-10 seconds during gameplay
3. **Handle Cutscenes**: Queue cutscenes based on `order` field
4. **Media Loading**: Preload cutscene videos for smooth playback
5. **Offline Support**: Cache suspect/evidence details for offline viewing

---

## Testing the Flow

### Test Scenario: Complete Game Session

1. **Setup**:
   ```bash
   # Get games
   GET /games
   
   # Create session
   POST /game-sessions
   { "gameId": "...", "mode": "team" }
   ```

2. **Game Start**:
   ```bash
   # Get cutscenes
   GET /cutscenes/game/:gameId
   
   # Get suspects
   GET /suspects/game/:gameId
   
   # Get evidence
   GET /evidences/game/:gameId
   ```

3. **During Gameplay**:
   ```bash
   # View suspect
   GET /suspects/:suspectId
   
   # View evidence
   GET /evidences/:evidenceId
   
   # Submit answer
   POST /user-answers
   
   # Check scoreboard
   GET /game-sessions/:sessionId/scoreboard
   ```

4. **Game End**:
   ```bash
   # Get results
   GET /game-sessions/:sessionId/result
   ```

---

This flow ensures a smooth, engaging game experience from start to finish!




-- Create the database
CREATE DATABASE EPL;
GO

-- Use the EPL database
USE EPL;
GO

CREATE TABLE Matches (
  MatchNumber INT,
  RoundNumber INT,
  DateUtc DATETIME,
  Location VARCHAR(255),
  HomeTeam VARCHAR(255),
  AwayTeam VARCHAR(255),
  [Group] VARCHAR(255),
  HomeTeamScore INT,
  AwayTeamScore INT
);
CREATE TABLE News (
  NewsTitle VARCHAR(255),
  NewsContent TEXT,
  Time DATETIME,
  Author VARCHAR(255)
);
CREATE TABLE ClubLeaderboard (
  RankNumber INT,
  TeamName VARCHAR(255),
  TotalMatches INT,
  Wins INT,
  Draws INT,
  Losses INT,
  GoalsScored INT,
  GoalsConceded INT,
  GoalDifference INT,
  TotalPoints INT
);
CREATE TABLE TopGoalsByPlayer (
  FootballerName VARCHAR(255),
  TotalGoals INT,
  Club VARCHAR(255)
);
CREATE TABLE TopAssistsByPlayer (
  FootballerName VARCHAR(255),
  TotalAssists INT,
  Club VARCHAR(255)
);
CREATE TABLE TopPlayerByRedCards (
  FootballerName VARCHAR(255),
  TotalRedCards INT,
  Club VARCHAR(255)
);
CREATE TABLE TopPlayerByYellowCards (
  FootballerName VARCHAR(255),
  TotalYellowCards INT,
  Club VARCHAR(255)
);
CREATE TABLE FootballerName (
  FootballerName VARCHAR(255),
  Position VARCHAR(255),
  Club VARCHAR(255)
);
CREATE TABLE HistoricalAchievement (
  RankNumber INT,
  Club VARCHAR(255),
  TotalEPLTrophy INT
);

DECLARE @matchesJson NVARCHAR(MAX);

SELECT @matchesJson = BulkColumn
FROM OPENROWSET(BULK 'D:\Downloads going here\SQL project\message.txt', SINGLE_CLOB) AS j;

INSERT INTO Matches (MatchNumber, RoundNumber, DateUtc, Location, HomeTeam, AwayTeam, [Group], HomeTeamScore, AwayTeamScore)
SELECT MatchNumber, RoundNumber, CONVERT(DATETIME, REPLACE(DateUtc, 'Z', ''), 120), Location, HomeTeam, AwayTeam, [Group], HomeTeamScore, AwayTeamScore
FROM OPENJSON(@matchesJson)
WITH (
  MatchNumber INT '$.MatchNumber',
  RoundNumber INT '$.RoundNumber',
  DateUtc VARCHAR(50) '$.DateUtc',
  Location VARCHAR(255) '$.Location',
  HomeTeam VARCHAR(255) '$.HomeTeam',
  AwayTeam VARCHAR(255) '$.AwayTeam',
  [Group] VARCHAR(255) '$.Group',
  HomeTeamScore INT '$.HomeTeamScore',
  AwayTeamScore INT '$.AwayTeamScore'
);

DECLARE @newsJson NVARCHAR(MAX) = N'[{"NewsTitle":"Title1","NewsContent":"Content1","Time":"2022-07-31T10:00:00Z","Author":"Author1"},{"NewsTitle":"Title2","NewsContent":"Content2","Time":"2022-08-06T15:30:00Z","Author":"Author2"}]';

INSERT INTO News (NewsTitle, NewsContent, Time, Author)
SELECT NewsTitle, NewsContent, CONVERT(DATETIME, REPLACE(Time, 'Z', ''), 126), Author
FROM OPENJSON(@newsJson)
WITH (
  NewsTitle VARCHAR(255) '$.NewsTitle',
  NewsContent VARCHAR(MAX) '$.NewsContent',
  Time VARCHAR(50) '$.Time',
  Author VARCHAR(255) '$.Author'
);

DECLARE @clubLeaderboardJson NVARCHAR(MAX) = N'[{"RankNumber":1,"TeamName":"Team1","TotalMatches":10,"Wins":5,"Draws":3,"Losses":2,"GoalsScored":20,"GoalsConceded":10,"GoalDifference":10,"TotalPoints":18},{"RankNumber":2,"TeamName":"Team2","TotalMatches":9,"Wins":4,"Draws":3,"Losses":2,"GoalsScored":15,"GoalsConceded":12,"GoalDifference":3,"TotalPoints":15}]';

INSERT INTO ClubLeaderboard (RankNumber, TeamName, TotalMatches, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, TotalPoints)
SELECT RankNumber, TeamName, TotalMatches, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, TotalPoints
FROM OPENJSON(@clubLeaderboardJson)
WITH (
  RankNumber INT '$.RankNumber',
  TeamName VARCHAR(255) '$.TeamName',
  TotalMatches INT '$.TotalMatches',
  Wins INT '$.Wins',
  Draws INT '$.Draws',
  Losses INT '$.Losses',
  GoalsScored INT '$.GoalsScored',
  GoalsConceded INT '$.GoalsConceded',
  GoalDifference INT '$.GoalDifference',
  TotalPoints INT '$.TotalPoints'
);

DECLARE @topGoalsByPlayerJson NVARCHAR(MAX) = N'[{"FootballerName":"Player1","TotalGoals":10,"Club":"Club1"},{"FootballerName":"Player2","TotalGoals":8,"Club":"Club2"}]';

INSERT INTO TopGoalsByPlayer (FootballerName, TotalGoals, Club)
SELECT FootballerName, TotalGoals, Club
FROM OPENJSON(@topGoalsByPlayerJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalGoals INT '$.TotalGoals',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topAssistsByPlayerJson NVARCHAR(MAX) = N'[{"FootballerName":"Player1","TotalAssists":5,"Club":"Club1"},{"FootballerName":"Player2","TotalAssists":3,"Club":"Club2"}]';

INSERT INTO TopAssistsByPlayer (FootballerName, TotalAssists, Club)
SELECT FootballerName, TotalAssists, Club
FROM OPENJSON(@topAssistsByPlayerJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalAssists INT '$.TotalAssists',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByRedCardsJson NVARCHAR(MAX) = N'[{"FootballerName":"Player1","TotalRedCards":2,"Club":"Club1"},{"FootballerName":"Player2","TotalRedCards":1,"Club":"Club2"}]';

INSERT INTO TopPlayerByRedCards (FootballerName, TotalRedCards, Club)
SELECT FootballerName, TotalRedCards, Club
FROM OPENJSON(@topPlayerByRedCardsJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalRedCards INT '$.TotalRedCards',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByYellowCardsJson NVARCHAR(MAX) = N'[{"FootballerName":"Player1","TotalYellowCards":3,"Club":"Club1"},{"FootballerName":"Player2","TotalYellowCards":2,"Club":"Club2"}]';

INSERT INTO TopPlayerByYellowCards (FootballerName, TotalYellowCards, Club)
SELECT FootballerName, TotalYellowCards, Club
FROM OPENJSON(@topPlayerByYellowCardsJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalYellowCards INT '$.TotalYellowCards',
  Club VARCHAR(255) '$.Club'
);

DECLARE @footballerNameJson NVARCHAR(MAX) = N'[{"FootballerName":"Player1","Position":"Forward","Club":"Club1"},{"FootballerName":"Player2","Position":"Midfielder","Club":"Club2"}]';

INSERT INTO FootballerName (FootballerName, Position, Club)
SELECT FootballerName, Position, Club
FROM OPENJSON(@footballerNameJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  Position VARCHAR(255) '$.Position',
  Club VARCHAR(255) '$.Club'
);

DECLARE @historicalAchievementJson NVARCHAR(MAX) = N'[{"RankNumber":1,"Club":"Club1","TotalEPLTrophy":5},{"RankNumber":2,"Club":"Club2","TotalEPLTrophy":3}]';

INSERT INTO HistoricalAchievement (RankNumber, Club, TotalEPLTrophy)
SELECT RankNumber, Club, TotalEPLTrophy
FROM OPENJSON(@historicalAchievementJson)
WITH (
  RankNumber INT '$.RankNumber',
  Club VARCHAR(255) '$.Club',
  TotalEPLTrophy INT '$.TotalEPLTrophy'
);



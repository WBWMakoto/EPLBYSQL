

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
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\matches.txt', SINGLE_CLOB) AS j;

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
)
ORDER BY MatchNumber ASC;






DECLARE @newsJson NVARCHAR(MAX);

SELECT @newsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\news.txt', SINGLE_CLOB) AS j;

INSERT INTO News (NewsTitle, NewsContent, Time, Author)
SELECT NewsTitle, NewsContent, CONVERT(DATETIME, REPLACE(Time, 'Z', ''), 126), Author
FROM OPENJSON(@newsJson)
WITH (
  NewsTitle VARCHAR(255) '$.NewsTitle',
  NewsContent VARCHAR(MAX) '$.NewsContent',
  Time VARCHAR(50) '$.Time',
  Author VARCHAR(255) '$.Author'
);

DECLARE @clubLeaderboardJson NVARCHAR(MAX);

SELECT @clubLeaderboardJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\clubleaderboard.txt', SINGLE_CLOB) AS j;

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

DECLARE @topGoalsByPlayerJson NVARCHAR(MAX);

SELECT @topGoalsByPlayerJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topgoalsbyplayer.txt', SINGLE_CLOB) AS j;

INSERT INTO TopGoalsByPlayer (FootballerName, TotalGoals, Club)
SELECT FootballerName, TotalGoals, Club
FROM OPENJSON(@topGoalsByPlayerJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalGoals INT '$.TotalGoals',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topAssistsByPlayerJson NVARCHAR(MAX);

SELECT @topAssistsByPlayerJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topassistsbyplayer.txt', SINGLE_CLOB) AS j;

INSERT INTO TopAssistsByPlayer (FootballerName, TotalAssists, Club)
SELECT FootballerName, TotalAssists, Club
FROM OPENJSON(@topAssistsByPlayerJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalAssists INT '$.TotalAssists',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByRedCardsJson NVARCHAR(MAX);

SELECT @topPlayerByRedCardsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topplayerbyredcards.txt', SINGLE_CLOB) AS j;

INSERT INTO TopPlayerByRedCards (FootballerName, TotalRedCards, Club)
SELECT FootballerName, TotalRedCards, Club
FROM OPENJSON(@topPlayerByRedCardsJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalRedCards INT '$.TotalRedCards',
  Club VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByYellowCardsJson NVARCHAR(MAX);

SELECT @topPlayerByYellowCardsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topplayerbyyellowcards.txt', SINGLE_CLOB) AS j;

INSERT INTO TopPlayerByYellowCards (FootballerName, TotalYellowCards, Club)
SELECT FootballerName, TotalYellowCards, Club
FROM OPENJSON(@topPlayerByYellowCardsJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalYellowCards INT '$.TotalYellowCards',
  Club VARCHAR(255) '$.Club'
);

DECLARE @footballerNameJson NVARCHAR(MAX);

SELECT @footballerNameJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\footballername.txt', SINGLE_CLOB) AS j;

INSERT INTO FootballerName (FootballerName, Position, Club)
SELECT FootballerName, Position, Club
FROM OPENJSON(@footballerNameJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  Position VARCHAR(255) '$.Position',
  Club VARCHAR(255) '$.Club'
);

DECLARE @historicalAchievementJson NVARCHAR(MAX);

SELECT @historicalAchievementJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\historialachievement.txt', SINGLE_CLOB) AS j;

INSERT INTO HistoricalAchievement (RankNumber, Club, TotalEPLTrophy)
SELECT RankNumber, Club, TotalEPLTrophy
FROM OPENJSON(@historicalAchievementJson)
WITH (
  RankNumber INT '$.RankNumber',
  Club VARCHAR(255) '$.Club',
  TotalEPLTrophy INT '$.TotalEPLTrophy'
);

-- Query from data

SELECT *
FROM Matches
WHERE HomeTeamScore > 3;


SELECT TOP 5 *
FROM News
ORDER BY [Time] DESC;

SELECT TeamName, GoalDifference
FROM ClubLeaderboard
ORDER BY GoalDifference DESC;

SELECT TOP 3 FootballerName, TotalGoals
FROM TopGoalsByPlayer
ORDER BY TotalGoals DESC;

SELECT Club, SUM(TotalYellowCards) AS TotalYellowCards
FROM TopPlayerByYellowCards
GROUP BY Club;

SELECT FootballerName, Position
FROM FootballerName
WHERE Club = 'Club1';

SELECT Club, TotalEPLTrophy
FROM HistoricalAchievement
WHERE TotalEPLTrophy > 3;

SELECT *
FROM Matches
WHERE HomeTeamScore = AwayTeamScore;

SELECT TOP 5 FootballerName, TotalAssists
FROM TopAssistsByPlayer
ORDER BY TotalAssists DESC;



-- Create the database
CREATE DATABASE EPL;
GO

-- Use the EPL database
USE EPL;
GO



CREATE TABLE Matches (
  MatchNumber INT PRIMARY KEY,
  DateUtc DATETIME,
  RoundNumber INT,
  Location VARCHAR(255),
  HomeTeam VARCHAR(255),
  AwayTeam VARCHAR(255),
  [Group] VARCHAR(255),
  HomeTeamScore INT,
  AwayTeamScore INT
);

CREATE TABLE News (
  NewsID INT PRIMARY KEY IDENTITY(1,1),
  NewsTitle VARCHAR(255),
  NewsContent TEXT,
  TimePublished DATETIME,
  Author VARCHAR(255)
);

CREATE TABLE ClubLeaderboard (
  ClubID INT PRIMARY KEY,
  RankNumber INT,
  ClubName VARCHAR(255),
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
  PlayerID INT PRIMARY KEY IDENTITY(1,1),
  FootballerName VARCHAR(255),
  TotalGoals INT,
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_TopGoalsByPlayer_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE TopAssistsByPlayer (
  PlayerID INT PRIMARY KEY IDENTITY(1,1),
  FootballerName VARCHAR(255),
  TotalAssists INT,
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_TopAssistsByPlayer_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE TopPlayerByRedCards (
  RedCardID INT PRIMARY KEY IDENTITY(1,1),
  FootballerName VARCHAR(255),
  TotalRedCards INT,
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_TopPlayerByRedCards_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE TopPlayerByYellowCards (
  YellowCardID INT PRIMARY KEY IDENTITY(1,1),
  FootballerName VARCHAR(255),
  TotalYellowCards INT,
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_TopPlayerByYellowCards_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE Footballer (
  PlayerID INT PRIMARY KEY IDENTITY(1,1),
  FootballerName VARCHAR(255),
  Position VARCHAR(255),
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_Footballer_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE HistoricalAchievement (
  ClubID INT PRIMARY KEY,
  RankNumber INT ,
  
  ClubName VARCHAR(255),
  TotalEPLTrophy INT,
  
);



CREATE TABLE Stadiums (
  StadiumID INT PRIMARY KEY IDENTITY(1,1),
  StadiumName VARCHAR(255),
  Capacity INT,
  ClubName VARCHAR(255),
  ClubID INT REFERENCES ClubLeaderboard(ClubID),
  City VARCHAR(255)
  CONSTRAINT FK_Stadiums_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE Coaches (
  CoachID INT PRIMARY KEY IDENTITY(1,1),
  CoachName VARCHAR(255),
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_Coaches_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE Referees (
  RefereeID INT PRIMARY KEY IDENTITY(1,1),
  RefereeName VARCHAR(255),
  Age INT
);

CREATE TABLE Sponsors (
  SponsorID INT PRIMARY KEY IDENTITY(1,1),
  SponsorName VARCHAR(255),
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_Sponsors_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE ClubChairmen (
  ChairmanID INT PRIMARY KEY IDENTITY(1,1),
  ChairmanName VARCHAR(255),
  ClubName VARCHAR(255),
  ClubID INT,
  CONSTRAINT FK_ClubChairmen_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);

CREATE TABLE Revenue (
  
  ClubID INT PRIMARY KEY,
  ClubName VARCHAR(255) ,
  RevenueAmount DECIMAL(10, 2),
  CONSTRAINT FK_Revenue_ClubLeaderboard FOREIGN KEY (ClubID) REFERENCES ClubLeaderboard(ClubID)
);


CREATE PROCEDURE InsertMatchesFromJson
AS
BEGIN
    DECLARE @matchesJson NVARCHAR(MAX);

    -- Read the JSON file into a variable
    SELECT @matchesJson = BulkColumn
    FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\matches.json', SINGLE_CLOB) AS j;

    -- Insert the JSON data into the Matches table
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
END
EXEC InsertMatchesFromJson;




DECLARE @matchesJson NVARCHAR(MAX);
SELECT @matchesJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\matches.json', SINGLE_CLOB) AS j;

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
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\news.json', SINGLE_CLOB) AS j;

INSERT INTO News (NewsTitle, NewsContent, TimePublished, Author)
SELECT NewsTitle, NewsContent, CONVERT(DATETIME, REPLACE(TimePublished, 'Z', ''), 126), Author
FROM OPENJSON(@newsJson)
WITH (
  NewsTitle VARCHAR(255) '$.NewsTitle',
  NewsContent VARCHAR(MAX) '$.NewsContent',
  TimePublished VARCHAR(50) '$.Time',
  Author VARCHAR(255) '$.Author'
);




DECLARE @clubLeaderboardJson NVARCHAR(MAX);

SELECT @clubLeaderboardJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\clubleaderboard.json', SINGLE_CLOB) AS j;


INSERT INTO ClubLeaderboard (ClubID, RankNumber, ClubName, TotalMatches, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, TotalPoints)
SELECT ClubID, RankNumber, ClubName, TotalMatches, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, TotalPoints
FROM OPENJSON(@clubLeaderboardJson)
WITH (
  ClubID INT '$.ClubID',
  RankNumber INT '$.RankNumber',
  ClubName VARCHAR(255) '$.TeamName',
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
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topgoalsbyplayer.json', SINGLE_CLOB) AS j;

INSERT INTO TopGoalsByPlayer (FootballerName, TotalGoals, ClubName, ClubID)
SELECT FootballerName, TotalGoals, ClubName, ClubID
FROM OPENJSON(@topGoalsByPlayerJson)
WITH (

  FootballerName VARCHAR(255) '$.FootballerName',
  TotalGoals INT '$.TotalGoals',
  ClubName VARCHAR(255) '$.Club',
  ClubID INT '$.ClubID'
);

DECLARE @topAssistsByPlayerJson NVARCHAR(MAX);

SELECT @topAssistsByPlayerJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topassistsbyplayer.json', SINGLE_CLOB) AS j;

INSERT INTO TopAssistsByPlayer (FootballerName, TotalAssists, ClubName, ClubID)
SELECT FootballerName, TotalAssists, ClubName, ClubID
FROM OPENJSON(@topAssistsByPlayerJson)
WITH (
  ClubID INT '$.ClubID',
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalAssists INT '$.TotalAssists',
  ClubName VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByRedCardsJson NVARCHAR(MAX);

SELECT @topPlayerByRedCardsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topplayerbyredcards.json', SINGLE_CLOB) AS j;

INSERT INTO TopPlayerByRedCards (FootballerName, TotalRedCards, ClubName, ClubID)
SELECT FootballerName, TotalRedCards, ClubName, ClubID
FROM OPENJSON(@topPlayerByRedCardsJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  ClubID INT '$.ClubID',
  TotalRedCards INT '$.TotalRedCards',
  ClubName VARCHAR(255) '$.Club'
);

DECLARE @topPlayerByYellowCardsJson NVARCHAR(MAX);

SELECT @topPlayerByYellowCardsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\topplayerbyyellowcards.json', SINGLE_CLOB) AS j;

INSERT INTO TopPlayerByYellowCards (FootballerName, TotalYellowCards, ClubName, ClubID)
SELECT FootballerName, TotalYellowCards, ClubName, ClubID
FROM OPENJSON(@topPlayerByYellowCardsJson)
WITH (
  ClubID INT '$.ClubID',
  FootballerName VARCHAR(255) '$.FootballerName',
  TotalYellowCards INT '$.TotalYellowCards',
  Clubname VARCHAR(255) '$.Club'
);

DECLARE @footballerNameJson NVARCHAR(MAX);

SELECT @footballerNameJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\footballername.json', SINGLE_CLOB) AS j;

INSERT INTO Footballer (FootballerName, Position, ClubName, ClubID)
SELECT FootballerName, Position, ClubName, ClubID
FROM OPENJSON(@footballerNameJson)
WITH (
  FootballerName VARCHAR(255) '$.FootballerName',
  Position VARCHAR(255) '$.Position',
  ClubName VARCHAR(255) '$.Club',
  ClubID INT '$.ClubID'
);

DECLARE @historicalAchievementJson NVARCHAR(MAX);

SELECT @historicalAchievementJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\historialachievement.json', SINGLE_CLOB) AS j;

INSERT INTO HistoricalAchievement (RankNumber, ClubName, ClubID, TotalEPLTrophy)
SELECT  RankNumber, ClubName, ClubID, TotalEPLTrophy
FROM OPENJSON(@historicalAchievementJson)
WITH (
  
  RankNumber INT '$.RankNumber',
  ClubName VARCHAR(255) '$.ClubName',
  ClubID INT '$.ClubID',
  TotalEPLTrophy INT '$.TotalEPLTrophy'
);




DECLARE @stadiumsJson NVARCHAR(MAX);

SELECT @stadiumsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\stadiums.json', SINGLE_CLOB) AS j;

INSERT INTO Stadiums (StadiumName, Capacity, ClubName, ClubID, City)
SELECT StadiumName, Capacity, ClubName, ClubID, City
FROM OPENJSON(@stadiumsJson)
WITH (
  StadiumName VARCHAR(255) '$.StadiumName',
  Capacity INT '$.Capacity',
  ClubName VARCHAR(255) '$.ClubName',
  ClubID INT '$.ClubID',
  City VARCHAR(255) '$.City'
);



DECLARE @coachesJson NVARCHAR(MAX);

SELECT @coachesJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\coaches.json', SINGLE_CLOB) AS j;

INSERT INTO Coaches (CoachName, ClubName, ClubID)
SELECT CoachName, ClubName, ClubID
FROM OPENJSON(@coachesJson)
WITH (
  CoachName VARCHAR(255) '$.CoachName',
  ClubName VARCHAR(255) '$.ClubName',
  ClubID INT '$.ClubID'
);


DECLARE @refereesJson NVARCHAR(MAX);

SELECT @refereesJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\referees.json', SINGLE_CLOB) AS j;

INSERT INTO Referees (RefereeName, Age)
SELECT RefereeName, Age
FROM OPENJSON(@refereesJson)
WITH (
  
  RefereeName VARCHAR(255) '$.RefereeName',
  Age INT '$.Age'
);

DECLARE @sponsorsJson NVARCHAR(MAX);

SELECT @sponsorsJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\sponsors.json', SINGLE_CLOB) AS j;

INSERT INTO Sponsors (SponsorName, ClubName, ClubID)
SELECT  SponsorName, ClubName, ClubID
FROM OPENJSON(@sponsorsJson)
WITH (
  
  SponsorName VARCHAR(255) '$.SponsorName',
  ClubName VARCHAR(255) '$.ClubName',
  ClubID INT '$.ClubID'
);

DECLARE @clubChairmenJson NVARCHAR(MAX);

SELECT @clubChairmenJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\clubchairmen.json', SINGLE_CLOB) AS j;

INSERT INTO ClubChairmen (ChairmanName, ClubName, ClubID)
SELECT  ChairmanName, ClubName, ClubID
FROM OPENJSON(@clubChairmenJson)
WITH (
  
  ChairmanName VARCHAR(255) '$.ChairmanName',
  ClubName VARCHAR(255) '$.ClubName',
  ClubID INT '$.ClubID'
);

DECLARE @revenueJson NVARCHAR(MAX);

SELECT @revenueJson = BulkColumn
FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\revenue.json', SINGLE_CLOB) AS j;

INSERT INTO Revenue (ClubID, ClubName, RevenueAmount)
SELECT ClubID, ClubName, RevenueAmount
FROM OPENJSON(@revenueJson)
WITH (
  ClubID INT '$.ClubID',
  ClubName VARCHAR(255) '$.ClubName',
  RevenueAmount DECIMAL(10, 2) '$.RevenueAmount'
);

-- Query from data



SELECT * FROM ClubLeaderboard ORDER BY TotalPoints DESC;

SELECT CoachName, ClubName FROM Coaches;

SELECT RefereeName, Age FROM Referees;

SELECT SponsorName FROM Sponsors WHERE ClubName = 'Club Name';

SELECT ChairmanName FROM ClubChairmen WHERE ClubName = 'Club Name';

SELECT ClubName, RevenueAmount FROM Revenue;

SELECT * FROM News WHERE Author = 'Author Name';

SELECT FootballerName, Position FROM Footballer WHERE ClubName = 'Club Name';



SELECT * FROM Matches WHERE HomeTeamScore > AwayTeamScore;

SELECT ClubName FROM Stadiums WHERE City = 'City Name';

SELECT * FROM Matches WHERE [Group] = 'Group Name';

SELECT ClubName, TotalMatches FROM ClubLeaderboard;

SELECT FootballerName, TotalGoals FROM TopGoalsByPlayer WHERE TotalGoals > 10;

SELECT ClubName FROM ClubLeaderboard WHERE Losses = 0;

SELECT CoachName FROM Coaches GROUP BY CoachName HAVING COUNT(DISTINCT ClubName) > 1;

SELECT RefereeName, Age FROM Referees WHERE Age < 40;


SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount > 1000000;

SELECT * FROM Matches WHERE Location = 'Stadium Name';

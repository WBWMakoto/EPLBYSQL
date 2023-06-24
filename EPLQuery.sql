-- Create the database
CREATE DATABASE EPL;
GO

-- Use the EPL database
USE EPL;
GO

--Create 15 tables
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
  RankNumber INT,
  ClubName VARCHAR(255),
  TotalEPLTrophy INT
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

--Declare + insert data into the database
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

-- Trigger to update the TimePublished column with the current datetime when a new row is inserted

CREATE TRIGGER UpdateTimePublished
ON News
AFTER INSERT
AS
BEGIN
    UPDATE News
    SET TimePublished = GETDATE()
    FROM inserted
    WHERE News.NewsID = inserted.NewsID;
END;



/*CREATE PROCEDURE InsertHistoricalAchievementFromJson
AS
BEGIN
    DECLARE @historicalAchievementJson NVARCHAR(MAX);

    -- Read the JSON file into a variable
    SELECT @historicalAchievementJson = BulkColumn
    FROM OPENROWSET(BULK 'D:\HUFLIT\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\Cơ sở dữ liệu nâng cao\Đồ án\Json\historialachievement.json', SINGLE_CLOB) AS j;

    -- Insert the JSON data into the HistoricalAchievement table, sorted by RankNumber
    INSERT INTO HistoricalAchievement (RankNumber, ClubName, ClubID, TotalEPLTrophy)
    SELECT RankNumber, ClubName, ClubID, TotalEPLTrophy
    FROM OPENJSON(@historicalAchievementJson)
    WITH (
      RankNumber INT '$.RankNumber',
      ClubName VARCHAR(255) '$.ClubName',
      ClubID INT '$.ClubID',
      TotalEPLTrophy INT '$.TotalEPLTrophy'
    )
    ORDER BY RankNumber ASC;
END;
EXEC InsertHistoricalAchievementFromJson;*/


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
) 
ORDER BY RankNumber ASC;


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

-- 1. Select all columns from the ClubLeaderboard table, sorted by TotalPoints in descending order.
SELECT * FROM ClubLeaderboard ORDER BY TotalPoints DESC;

-- 2. Select the CoachName and ClubName columns from the Coaches table.
SELECT CoachName, ClubName FROM Coaches;

-- 3. Select the RefereeName and Age columns from the Referees table.
SELECT RefereeName, Age FROM Referees;

-- 4. Select the SponsorName from the Sponsors table where the ClubName is equal to 'Club Name'.
SELECT SponsorName FROM Sponsors WHERE ClubName = 'Club Name';

-- 5. Select the ChairmanName from the ClubChairmen table where the ClubName is equal to 'Club Name'.
SELECT ChairmanName FROM ClubChairmen WHERE ClubName = 'Club Name';

-- 6. Select the ClubName and RevenueAmount columns from the Revenue table.
SELECT ClubName, RevenueAmount FROM Revenue;

-- 7. Select all columns from the News table where the Author is equal to 'Author Name'.
SELECT * FROM News WHERE Author = 'Author Name';

-- 8. Select the FootballerName and Position columns from the Footballer table where the ClubName is equal to 'Club Name'.
SELECT FootballerName, Position FROM Footballer WHERE ClubName = 'Club Name';

-- 9. Select all columns from the Matches table where the HomeTeamScore is greater than the AwayTeamScore.
SELECT * FROM Matches WHERE HomeTeamScore > AwayTeamScore;

-- 10. Select the ClubName from the Stadiums table where the City is equal to 'City Name'.
SELECT ClubName FROM Stadiums WHERE City = 'City Name';

-- 11. Select all columns from the Matches table where the [Group] is equal to 'Group Name'.
SELECT * FROM Matches WHERE [Group] = 'Group Name';

-- 12. Select the ClubName and TotalMatches columns from the ClubLeaderboard table.
SELECT ClubName, TotalMatches FROM ClubLeaderboard;

-- 13. Select the FootballerName and TotalGoals columns from the TopGoalsByPlayer table where the TotalGoals is greater than 10.
SELECT FootballerName, TotalGoals FROM TopGoalsByPlayer WHERE TotalGoals > 10;

-- 14. Select the ClubName from the ClubLeaderboard table where the Losses is equal to 0.
SELECT ClubName FROM ClubLeaderboard WHERE Losses = 0;

-- 15. Select the CoachName from the Coaches table, grouped by CoachName, having the COUNT(DISTINCT ClubName) greater than 1.
SELECT CoachName FROM Coaches GROUP BY CoachName HAVING COUNT(DISTINCT ClubName) > 1;

-- 16. Select the RefereeName and Age from the Referees table where the Age is less than 40.
SELECT RefereeName, Age FROM Referees WHERE Age < 40;

-- 17. Select the ClubName and RevenueAmount columns from the Revenue table where the RevenueAmount is greater than 1000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount > 1000000;

-- 18. Select all columns from the Matches table where the Location is equal to 'Stadium Name'.
SELECT * FROM Matches WHERE Location = 'Stadium Name';

-- 19. Select the MatchNumber, DateUtc, HomeTeam, AwayTeam, and HomeTeamScore from the Matches table where the HomeTeamScore is greater than the AwayTeamScore.
SELECT MatchNumber, DateUtc, HomeTeam, AwayTeam, HomeTeamScore
FROM Matches
WHERE HomeTeamScore > AwayTeamScore;

-- 20. Select the ClubName, RankNumber, and TotalPoints from the ClubLeaderboard table where the TotalPoints is equal to the highest number of points.
SELECT ClubName, RankNumber, TotalPoints
FROM ClubLeaderboard
WHERE TotalPoints = (SELECT MAX(TotalPoints) FROM ClubLeaderboard);

-- 21. Select the FootballerName and TotalAssists columns from the TopAssistsByPlayer table where the TotalAssists is greater than 5.
SELECT FootballerName, TotalAssists FROM TopAssistsByPlayer WHERE TotalAssists > 5;

-- 22. Select the FootballerName and TotalRedCards columns from the TopPlayerByRedCards table where the TotalRedCards is greater than 0.
SELECT FootballerName, TotalRedCards FROM TopPlayerByRedCards WHERE TotalRedCards > 0;

-- 23. Select the FootballerName and TotalYellowCards columns from the TopPlayerByYellowCards table where the TotalYellowCards is greater than 0.
SELECT FootballerName, TotalYellowCards FROM TopPlayerByYellowCards WHERE TotalYellowCards > 0;

-- 24. Select the FootballerName and Position columns from the Footballer table where the Position is equal to 'Forward'.
SELECT FootballerName, Position FROM Footballer WHERE Position = 'Forward';

-- 25. Select the ClubName and TotalEPLTrophy columns from the HistoricalAchievement table where the TotalEPLTrophy is greater than 0.
SELECT ClubName, TotalEPLTrophy FROM HistoricalAchievement WHERE TotalEPLTrophy > 0;

-- 26. Select the StadiumName and Capacity columns from the Stadiums table where the Capacity is greater than 50000.
SELECT StadiumName, Capacity FROM Stadiums WHERE Capacity > 50000;

-- 27. Select the CoachName, ClubName, and RankNumber columns from the Coaches table, joined with the ClubLeaderboard table on ClubID, sorted by RankNumber in ascending order.
SELECT C.CoachName, C.ClubName, L.RankNumber
FROM Coaches C
JOIN ClubLeaderboard L ON C.ClubID = L.ClubID
ORDER BY L.RankNumber ASC;

-- 28. Select the RefereeName and Age columns from the Referees table where the Age is between 30 and 50.
SELECT RefereeName, Age FROM Referees WHERE Age BETWEEN 30 AND 50;

-- 29. Select the SponsorName and ClubName columns from the Sponsors table where the SponsorName contains the word 'Insurance'.
SELECT SponsorName, ClubName FROM Sponsors WHERE SponsorName LIKE '%Insurance%';

-- 30. Select the ChairmanName and ClubName columns from the ClubChairmen table where the ChairmanName starts with 'John'.
SELECT ChairmanName, ClubName FROM ClubChairmen WHERE ChairmanName LIKE 'John%';

-- 31. Select the ClubName and RevenueAmount columns from the Revenue table where the RevenueAmount is between 1000000 and 5000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount BETWEEN 1000000 AND 5000000;

-- 32. Select the NewsTitle and TimePublished columns from the News table, sorted by TimePublished in descending order.
SELECT NewsTitle, TimePublished FROM News ORDER BY TimePublished DESC;

-- 33. Select the MatchNumber, DateUtc, RoundNumber, and Location columns from the Matches table where the RoundNumber is greater than or equal to 10.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches WHERE RoundNumber >= 10;

-- 34. Select the ClubName and TotalPoints columns from the ClubLeaderboard table, sorted by TotalPoints in descending order, and limit the result to 10 rows.

-- 35. Select the FootballerName and Position from the Footballer table.
SELECT FootballerName, Position FROM Footballer;

-- 36. Select the ClubName and Capacity from the Stadiums table.
SELECT ClubName, Capacity FROM Stadiums;

-- 37. Select the CoachName and ClubName from the Coaches table.
SELECT CoachName, ClubName FROM Coaches;

-- 38. Select the RefereeName and Age from the Referees table.
SELECT RefereeName, Age FROM Referees;

-- 39. Select the SponsorName and ClubName from the Sponsors table.
SELECT SponsorName, ClubName FROM Sponsors;

-- 40. Select the ChairmanName and ClubName from the ClubChairmen table.
SELECT ChairmanName, ClubName FROM ClubChairmen;

-- 41. Select the ClubID, RankNumber, and ClubName from the ClubLeaderboard table.
SELECT ClubID, RankNumber, ClubName FROM ClubLeaderboard;

-- 42. Select the NewsTitle, NewsContent, and TimePublished from the News table.
SELECT NewsTitle, NewsContent, TimePublished FROM News;

-- 43. Select the MatchNumber, DateUtc, and RoundNumber from the Matches table.
SELECT MatchNumber, DateUtc, RoundNumber FROM Matches;

-- 44. Select the FootballerName, TotalGoals, and ClubName from the TopGoalsByPlayer table.
SELECT FootballerName, TotalGoals, ClubName FROM TopGoalsByPlayer;

-- 45. Select the FootballerName, TotalAssists, and ClubName from the TopAssistsByPlayer table.
SELECT FootballerName, TotalAssists, ClubName FROM TopAssistsByPlayer;

-- 46. Select the FootballerName, TotalRedCards, and ClubName from the TopPlayerByRedCards table.
SELECT FootballerName, TotalRedCards, ClubName FROM TopPlayerByRedCards;

-- 47. Select the FootballerName, TotalYellowCards, and ClubName from the TopPlayerByYellowCards table.
SELECT FootballerName, TotalYellowCards, ClubName FROM TopPlayerByYellowCards;

-- 48. Select the ClubID, RankNumber, ClubName, and TotalEPLTrophy from the HistoricalAchievement table.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 49. Select the ClubID, ClubName, and RevenueAmount from the Revenue table.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 50. Select the StadiumName, Capacity, ClubName, and City from the Stadiums table.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 51. Select the CoachID, CoachName, ClubName, and ClubID from the Coaches table.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 52. Select the RefereeID, RefereeName, and Age from the Referees table.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 53. Select the SponsorID, SponsorName, ClubName, and ClubID from the Sponsors table.
SELECT SponsorID, SponsorName, ClubName, ClubID FROM Sponsors;

-- 54. Select the ChairmanID, ChairmanName, ClubName, and ClubID from the ClubChairmen table.
SELECT ChairmanID, ChairmanName, ClubName, ClubID FROM ClubChairmen;

-- 55. Select the ClubID, RankNumber, ClubName, and TotalMatches from the ClubLeaderboard table.
SELECT ClubID, RankNumber, ClubName, TotalMatches FROM ClubLeaderboard;

-- 56. Select the NewsID, NewsTitle, NewsContent, and TimePublished from the News table.
SELECT NewsID, NewsTitle, NewsContent, TimePublished FROM News;

-- 57. Select the MatchNumber, DateUtc, RoundNumber, and Location from the Matches table.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches;

-- 58. Select the FootballerName, TotalGoals, ClubName, and ClubID from the TopGoalsByPlayer table.
SELECT FootballerName, TotalGoals, ClubName, ClubID FROM TopGoalsByPlayer;

-- 59. Select the FootballerName, TotalAssists, ClubName, and ClubID from the TopAssistsByPlayer table.
SELECT FootballerName, TotalAssists, ClubName, ClubID FROM TopAssistsByPlayer;

-- 60. Select the FootballerName, TotalRedCards, ClubName, and ClubID from the TopPlayerByRedCards table.
SELECT FootballerName, TotalRedCards, ClubName, ClubID FROM TopPlayerByRedCards;

-- 61. Select the FootballerName, TotalYellowCards, ClubName, and ClubID from the TopPlayerByYellowCards table.
SELECT FootballerName, TotalYellowCards, ClubName, ClubID FROM TopPlayerByYellowCards;

-- 62. Select the ClubID, RankNumber, ClubName, and TotalEPLTrophy from the HistoricalAchievement table.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 63. Select the ClubID, ClubName, RevenueAmount from the Revenue table.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 64. Select the StadiumName, Capacity, ClubName, City from the Stadiums table.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 65. Select the CoachID, CoachName, ClubName, ClubID from the Coaches table.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 66. Select the RefereeID, RefereeName, Age from the Referees table.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 67. Select the SponsorID, SponsorName, ClubName, ClubID from the Sponsors table.
SELECT SponsorID, SponsorName, ClubName, ClubID FROM Sponsors;

-- 68. Select the ChairmanID, ChairmanName, ClubName, ClubID from the ClubChairmen table.
SELECT ChairmanID, ChairmanName, ClubName, ClubID FROM ClubChairmen;

-- 69. Select the ClubID, RankNumber, ClubName, TotalMatches from the ClubLeaderboard table.
SELECT ClubID, RankNumber, ClubName, TotalMatches FROM ClubLeaderboard;

-- 70. Select the NewsID, NewsTitle, NewsContent, TimePublished from the News table.
SELECT NewsID, NewsTitle, NewsContent, TimePublished FROM News;

-- 71. Select the MatchNumber, DateUtc, RoundNumber, Location from the Matches table.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches;

-- 72. Select the FootballerName, TotalGoals, ClubName, ClubID from the TopGoalsByPlayer table.
SELECT FootballerName, TotalGoals, ClubName, ClubID FROM TopGoalsByPlayer;

-- 73. Select the FootballerName, TotalAssists, ClubName, ClubID from the TopAssistsByPlayer table.
SELECT FootballerName, TotalAssists, ClubName, ClubID FROM TopAssistsByPlayer;

-- 74. Select the FootballerName, TotalRedCards, ClubName, ClubID from the TopPlayerByRedCards table.
SELECT FootballerName, TotalRedCards, ClubName, ClubID FROM TopPlayerByRedCards;

-- 75. Select the FootballerName, TotalYellowCards, ClubName, ClubID from the TopPlayerByYellowCards table.
SELECT FootballerName, TotalYellowCards, ClubName, ClubID FROM TopPlayerByYellowCards;

-- 76. Select the ClubID, RankNumber, ClubName, TotalEPLTrophy from the HistoricalAchievement table.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 77. Select the ClubID, ClubName, RevenueAmount from the Revenue table.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 78. Select the StadiumName, Capacity, ClubName, City from the Stadiums table.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 79. Select the CoachID, CoachName, ClubName, ClubID from the Coaches table.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 80. Select the RefereeID, RefereeName, Age from the Referees table.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 81. Select all columns from the ClubLeaderboard table, sorted by TotalPoints in descending order.
SELECT * FROM ClubLeaderboard ORDER BY TotalPoints DESC;

-- 82. Select the CoachName and ClubName columns from the Coaches table.
SELECT CoachName, ClubName FROM Coaches;

-- 83. Select the RefereeName and Age columns from the Referees table.
SELECT RefereeName, Age FROM Referees;

-- 84. Select the SponsorName from the Sponsors table where the ClubName is equal to 'Club Name'.
SELECT SponsorName FROM Sponsors WHERE ClubName = 'Club Name';

-- 85. Select the ChairmanName from the ClubChairmen table where the ClubName is equal to 'Club Name'.
SELECT ChairmanName FROM ClubChairmen WHERE ClubName = 'Club Name';

-- 86. Select the ClubName and RevenueAmount columns from the Revenue table.
SELECT ClubName, RevenueAmount FROM Revenue;

-- 87. Select all columns from the News table where the Author is equal to 'Author Name'.
SELECT * FROM News WHERE Author = 'Author Name';

-- 88. Select the FootballerName and Position columns from the Footballer table where the ClubName is equal to 'Club Name'.
SELECT FootballerName, Position FROM Footballer WHERE ClubName = 'Club Name';

-- 89. Select all columns from the Matches table where the HomeTeamScore is greater than the AwayTeamScore.
SELECT * FROM Matches WHERE HomeTeamScore > AwayTeamScore;

-- 90. Select the ClubName from the Stadiums table where the City is equal to 'City Name'.
SELECT ClubName FROM Stadiums WHERE City = 'City Name';

-- 91. Select all columns from the Matches table where the [Group] is equal to 'Group Name'.
SELECT * FROM Matches WHERE [Group] = 'Group Name';

-- 92. Select the ClubName and TotalMatches columns from the ClubLeaderboard table.
SELECT ClubName, TotalMatches FROM ClubLeaderboard;

-- 93. Select the FootballerName and TotalGoals columns from the TopGoalsByPlayer table where the TotalGoals is greater than 10.
SELECT FootballerName, TotalGoals FROM TopGoalsByPlayer WHERE TotalGoals > 10;

-- 94. Select the ClubName from the ClubLeaderboard table where the Losses is equal to 0.
SELECT ClubName FROM ClubLeaderboard WHERE Losses = 0;

-- 95. Select the CoachName from the Coaches table, grouped by CoachName, having the COUNT(DISTINCT ClubName) greater than 1.
SELECT CoachName FROM Coaches GROUP BY CoachName HAVING COUNT(DISTINCT ClubName) > 1;

-- 96. Select the RefereeName and Age from the Referees table where the Age is less than 40.
SELECT RefereeName, Age FROM Referees WHERE Age < 40;

-- 97. Select the ClubName and RevenueAmount columns from the Revenue table where the RevenueAmount is greater than 1000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount > 1000000;

-- 98. Select all columns from the Matches table where the Location is equal to 'Stadium Name'.
SELECT * FROM Matches WHERE Location = 'Stadium Name';

-- 99. Select the MatchNumber, DateUtc, HomeTeam, AwayTeam, and HomeTeamScore from the Matches table where the HomeTeamScore is greater than the AwayTeamScore.
SELECT MatchNumber, DateUtc, HomeTeam, AwayTeam, HomeTeamScore
FROM Matches
WHERE HomeTeamScore > AwayTeamScore;

-- 100. Select the ClubName, RankNumber, and TotalPoints from the ClubLeaderboard table where the TotalPoints is equal to the highest number of points.
SELECT ClubName, RankNumber, TotalPoints
FROM ClubLeaderboard
WHERE TotalPoints = (SELECT MAX(TotalPoints) FROM ClubLeaderboard);

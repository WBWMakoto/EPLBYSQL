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
  RevenueAmount FLOAT,
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
FROM OPENROWSET(BULK 'D:\\HUFLIT\\HUFLIT học kỳ 3 năm 2022 - 2023 (năm 2)\\Cơ sở dữ liệu nâng cao\\Đồ án\\Json\\revenue.json', SINGLE_CLOB) AS j;

INSERT INTO Revenue (ClubID, ClubName, RevenueAmount)
SELECT ClubID, ClubName, ROUND(RevenueAmount, 2) AS RevenueAmount
FROM OPENJSON(@revenueJson)
WITH (
  ClubID INT '$.ClubID',
  ClubName VARCHAR(255) '$.ClubName',
  RevenueAmount FLOAT '$.RevenueAmount'
);


-- Query from data



-- 1. Chọn tất cả cột từ bảng ClubLeaderboard, sắp xếp theo TotalPoints giảm dần.
SELECT * FROM ClubLeaderboard ORDER BY TotalPoints DESC;

-- 2. Chọn cột CoachName và ClubName từ bảng Coaches.
SELECT CoachName, ClubName FROM Coaches;

-- 3. Chọn cột RefereeName và Age từ bảng Referees.
SELECT RefereeName, Age FROM Referees;

-- 4. Chọn cột SponsorName từ bảng Sponsors khi ClubName bằng 'Club Name'.
SELECT SponsorName FROM Sponsors WHERE ClubName = 'Club Name';

-- 5. Chọn cột ChairmanName từ bảng ClubChairmen khi ClubName bằng 'Club Name'.
SELECT ChairmanName FROM ClubChairmen WHERE ClubName = 'Club Name';

-- 6. Chọn cột ClubName và RevenueAmount từ bảng Revenue.
SELECT ClubName, RevenueAmount FROM Revenue;

-- 7. Chọn tất cả cột từ bảng News khi Author bằng 'Author Name'.
SELECT * FROM News WHERE Author = 'Author Name';

-- 8. Chọn cột FootballerName và Position từ bảng Footballer khi ClubName bằng 'Club Name'.
SELECT FootballerName, Position FROM Footballer WHERE ClubName = 'Club Name';

-- 9. Chọn tất cả cột từ bảng Matches khi HomeTeamScore lớn hơn AwayTeamScore.
SELECT * FROM Matches WHERE HomeTeamScore > AwayTeamScore;

-- 10. Chọn cột ClubName từ bảng Stadiums khi City bằng 'City Name'.
SELECT ClubName FROM Stadiums WHERE City = 'City Name';

-- 11. Chọn tất cả cột từ bảng Matches khi [Group] bằng 'Group Name'.
SELECT * FROM Matches WHERE [Group] = 'Group Name';

-- 12. Chọn cột ClubName và TotalMatches từ bảng ClubLeaderboard.
SELECT ClubName, TotalMatches FROM ClubLeaderboard;

-- 13. Chọn cột FootballerName và TotalGoals từ bảng TopGoalsByPlayer khi TotalGoals lớn hơn 10.
SELECT FootballerName, TotalGoals FROM TopGoalsByPlayer WHERE TotalGoals > 10;

-- 14. Chọn cột ClubName từ bảng ClubLeaderboard khi Losses bằng 0.
SELECT ClubName FROM ClubLeaderboard WHERE Losses = 0;

-- 15. Chọn cột CoachName từ bảng Coaches, nhóm theo CoachName, có COUNT(DISTINCT ClubName) lớn hơn 1.
SELECT CoachName FROM Coaches GROUP BY CoachName HAVING COUNT(DISTINCT ClubName) > 1;

-- 16. Chọn cột RefereeName và Age từ bảng Referees khi Age nhỏ hơn 40.
SELECT RefereeName, Age FROM Referees WHERE Age < 40;

-- 17. Chọn cột ClubName và RevenueAmount từ bảng Revenue khi RevenueAmount lớn hơn 1000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount > 1000000;

-- 18. Chọn tất cả cột từ bảng Matches khi Location bằng 'Stadium Name'.
SELECT * FROM Matches WHERE Location = 'Stadium Name';

-- 19. Chọn cột MatchNumber, DateUtc, HomeTeam, AwayTeam và HomeTeamScore từ bảng Matches khi HomeTeamScore lớn hơn AwayTeamScore.
SELECT MatchNumber, DateUtc, HomeTeam, AwayTeam, HomeTeamScore
FROM Matches
WHERE HomeTeamScore > AwayTeamScore;

-- 20. Chọn cột ClubName, RankNumber và TotalPoints từ bảng ClubLeaderboard khi TotalPoints bằng số điểm cao nhất.
SELECT ClubName, RankNumber, TotalPoints
FROM ClubLeaderboard
WHERE TotalPoints = (SELECT MAX(TotalPoints) FROM ClubLeaderboard);

-- 21. Chọn cột FootballerName và TotalAssists từ bảng TopAssistsByPlayer khi TotalAssists lớn hơn 5.
SELECT FootballerName, TotalAssists FROM TopAssistsByPlayer WHERE TotalAssists > 5;

-- 22. Chọn cột FootballerName và TotalRedCards từ bảng TopPlayerByRedCards khi TotalRedCards lớn hơn 0.
SELECT FootballerName, TotalRedCards FROM TopPlayerByRedCards WHERE TotalRedCards > 0;

-- 23. Chọn cột FootballerName và TotalYellowCards từ bảng TopPlayerByYellowCards khi TotalYellowCards lớn hơn 0.
SELECT FootballerName, TotalYellowCards FROM TopPlayerByYellowCards WHERE TotalYellowCards > 0;

-- 24. Chọn cột FootballerName và Position từ bảng Footballer khi Position bằng 'Forward'.
SELECT FootballerName, Position FROM Footballer WHERE Position = 'Forward';

-- 25. Chọn cột ClubName và TotalEPLTrophy từ bảng HistoricalAchievement khi TotalEPLTrophy lớn hơn 0.
SELECT ClubName, TotalEPLTrophy FROM HistoricalAchievement WHERE TotalEPLTrophy > 0;

-- 26. Chọn cột StadiumName và Capacity từ bảng Stadiums khi Capacity lớn hơn 50000.
SELECT StadiumName, Capacity FROM Stadiums WHERE Capacity > 50000;

-- 27. Chọn cột CoachName, ClubName và RankNumber từ bảng Coaches, kết hợp với bảng ClubLeaderboard theo ClubID, sắp xếp theo RankNumber tăng dần.
SELECT C.CoachName, C.ClubName, L.RankNumber
FROM Coaches C
JOIN ClubLeaderboard L ON C.ClubID = L.ClubID
ORDER BY L.RankNumber ASC;

-- 28. Chọn cột RefereeName và Age từ bảng Referees khi Age nằm trong khoảng từ 30 đến 50.
SELECT RefereeName, Age FROM Referees WHERE Age BETWEEN 30 AND 50;

-- 29. Chọn cột SponsorName và ClubName từ bảng Sponsors khi SponsorName chứa từ 'Insurance'.
SELECT SponsorName, ClubName FROM Sponsors WHERE SponsorName LIKE '%Insurance%';

-- 30. Chọn cột ChairmanName và ClubName từ bảng ClubChairmen khi ChairmanName bắt đầu bằng 'John'.
SELECT ChairmanName, ClubName FROM ClubChairmen WHERE ChairmanName LIKE 'John%';

-- 31. Chọn cột ClubName và RevenueAmount từ bảng Revenue khi RevenueAmount nằm trong khoảng từ 1000000 đến 5000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount BETWEEN 1000000 AND 5000000;

-- 32. Chọn cột NewsTitle và TimePublished từ bảng News, sắp xếp theo TimePublished giảm dần.
SELECT NewsTitle, TimePublished FROM News ORDER BY TimePublished DESC;

-- 33. Chọn cột MatchNumber, DateUtc, RoundNumber và Location từ bảng Matches khi RoundNumber lớn hơn hoặc bằng 10.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches WHERE RoundNumber >= 10;

-- 34. Chọn cột ClubName và TotalPoints từ bảng ClubLeaderboard, sắp xếp theo TotalPoints giảm dần, và giới hạn kết quả cho 10 dòng.
SELECT TOP 10 ClubName, TotalPoints
FROM ClubLeaderboard
ORDER BY TotalPoints DESC;

-- 35. Chọn cột FootballerName và Position từ bảng Footballer.
SELECT FootballerName, Position FROM Footballer;

-- 36. Chọn cột ClubName và Capacity từ bảng Stadiums.
SELECT ClubName, Capacity FROM Stadiums;

-- 37. Chọn cột CoachName và ClubName từ bảng Coaches.
SELECT CoachName, ClubName FROM Coaches;

-- 38. Chọn cột RefereeName và Age từ bảng Referees.
SELECT RefereeName, Age FROM Referees;

-- 39. Chọn cột SponsorName và ClubName từ bảng Sponsors.
SELECT SponsorName, ClubName FROM Sponsors;

-- 40. Chọn cột ChairmanName và ClubName từ bảng ClubChairmen.
SELECT ChairmanName, ClubName FROM ClubChairmen;

-- 41. Chọn cột ClubID, RankNumber và ClubName từ bảng ClubLeaderboard.
SELECT ClubID, RankNumber, ClubName FROM ClubLeaderboard;

-- 42. Chọn cột NewsTitle, NewsContent và TimePublished từ bảng News.
SELECT NewsTitle, NewsContent, TimePublished FROM News;

-- 43. Chọn cột MatchNumber, DateUtc và RoundNumber từ bảng Matches.
SELECT MatchNumber, DateUtc, RoundNumber FROM Matches;

-- 44. Chọn cột FootballerName, TotalGoals và ClubName từ bảng TopGoalsByPlayer.
SELECT FootballerName, TotalGoals, ClubName FROM TopGoalsByPlayer;

-- 45. Chọn cột FootballerName, TotalAssists và ClubName từ bảng TopAssistsByPlayer.
SELECT FootballerName, TotalAssists, ClubName FROM TopAssistsByPlayer;

-- 46. Chọn cột FootballerName, TotalRedCards và ClubName từ bảng TopPlayerByRedCards.
SELECT FootballerName, TotalRedCards, ClubName FROM TopPlayerByRedCards;

-- 47. Chọn cột FootballerName, TotalYellowCards và ClubName từ bảng TopPlayerByYellowCards.
SELECT FootballerName, TotalYellowCards, ClubName FROM TopPlayerByYellowCards;

-- 48. Chọn cột ClubID, RankNumber, ClubName và TotalEPLTrophy từ bảng HistoricalAchievement.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 49. Chọn cột ClubID, ClubName và RevenueAmount từ bảng Revenue.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 50. Chọn cột StadiumName, Capacity, ClubName và City từ bảng Stadiums.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 51. Chọn cột CoachID, CoachName, ClubName và ClubID từ bảng Coaches.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 52. Chọn cột RefereeID, RefereeName và Age từ bảng Referees.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 53. Chọn cột SponsorID, SponsorName, ClubName và ClubID từ bảng Sponsors.
SELECT SponsorID, SponsorName, ClubName, ClubID FROM Sponsors;

-- 54. Chọn cột ChairmanID, ChairmanName, ClubName và ClubID từ bảng ClubChairmen.
SELECT ChairmanID, ChairmanName, ClubName, ClubID FROM ClubChairmen;

-- 55. Chọn cột ClubID, RankNumber, ClubName và TotalMatches từ bảng ClubLeaderboard.
SELECT ClubID, RankNumber, ClubName, TotalMatches FROM ClubLeaderboard;

-- 56. Chọn cột NewsID, NewsTitle, NewsContent và TimePublished từ bảng News.
SELECT NewsID, NewsTitle, NewsContent, TimePublished FROM News;

-- 57. Chọn cột MatchNumber, DateUtc, RoundNumber và Location từ bảng Matches.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches;

-- 58. Chọn cột FootballerName, TotalGoals, ClubName và ClubID từ bảng TopGoalsByPlayer.
SELECT FootballerName, TotalGoals, ClubName, ClubID FROM TopGoalsByPlayer;

-- 59. Chọn cột FootballerName, TotalAssists, ClubName và ClubID từ bảng TopAssistsByPlayer.
SELECT FootballerName, TotalAssists, ClubName, ClubID FROM TopAssistsByPlayer;

-- 60. Chọn cột FootballerName, TotalRedCards, ClubName và ClubID từ bảng TopPlayerByRedCards.
SELECT FootballerName, TotalRedCards, ClubName, ClubID FROM TopPlayerByRedCards;

-- 61. Chọn cột FootballerName, TotalYellowCards, ClubName và ClubID từ bảng TopPlayerByYellowCards.
SELECT FootballerName, TotalYellowCards, ClubName, ClubID FROM TopPlayerByYellowCards;

-- 62. Chọn cột ClubID, RankNumber, ClubName và TotalEPLTrophy từ bảng HistoricalAchievement.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 63. Chọn cột ClubID, ClubName và RevenueAmount từ bảng Revenue.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 64. Chọn cột StadiumName, Capacity, ClubName và City từ bảng Stadiums.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 65. Chọn cột CoachID, CoachName, ClubName và ClubID từ bảng Coaches.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 66. Chọn cột RefereeID, RefereeName và Age từ bảng Referees.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 67. Chọn cột SponsorID, SponsorName, ClubName và ClubID từ bảng Sponsors.
SELECT SponsorID, SponsorName, ClubName, ClubID FROM Sponsors;

-- 68. Chọn cột ChairmanID, ChairmanName, ClubName và ClubID từ bảng ClubChairmen.
SELECT ChairmanID, ChairmanName, ClubName, ClubID FROM ClubChairmen;

-- 69. Chọn cột ClubID, RankNumber, ClubName và TotalMatches từ bảng ClubLeaderboard.
SELECT ClubID, RankNumber, ClubName, TotalMatches FROM ClubLeaderboard;

-- 70. Chọn cột NewsID, NewsTitle, NewsContent và TimePublished từ bảng News.
SELECT NewsID, NewsTitle, NewsContent, TimePublished FROM News;

-- 71. Chọn cột MatchNumber, DateUtc, RoundNumber và Location từ bảng Matches.
SELECT MatchNumber, DateUtc, RoundNumber, Location FROM Matches;

-- 72. Chọn cột FootballerName, TotalGoals, ClubName và ClubID từ bảng TopGoalsByPlayer.
SELECT FootballerName, TotalGoals, ClubName, ClubID FROM TopGoalsByPlayer;

-- 73. Chọn cột FootballerName, TotalAssists, ClubName và ClubID từ bảng TopAssistsByPlayer.
SELECT FootballerName, TotalAssists, ClubName, ClubID FROM TopAssistsByPlayer;

-- 74. Chọn cột FootballerName, TotalRedCards, ClubName và ClubID từ bảng TopPlayerByRedCards.
SELECT FootballerName, TotalRedCards, ClubName, ClubID FROM TopPlayerByRedCards;

-- 75. Chọn cột FootballerName, TotalYellowCards, ClubName và ClubID từ bảng TopPlayerByYellowCards.
SELECT FootballerName, TotalYellowCards, ClubName, ClubID FROM TopPlayerByYellowCards;

-- 76. Chọn cột ClubID, RankNumber, ClubName và TotalEPLTrophy từ bảng HistoricalAchievement.
SELECT ClubID, RankNumber, ClubName, TotalEPLTrophy FROM HistoricalAchievement;

-- 77. Chọn cột ClubID, ClubName và RevenueAmount từ bảng Revenue.
SELECT ClubID, ClubName, RevenueAmount FROM Revenue;

-- 78. Chọn cột StadiumName, Capacity, ClubName và City từ bảng Stadiums.
SELECT StadiumName, Capacity, ClubName, City FROM Stadiums;

-- 79. Chọn cột CoachID, CoachName, ClubName và ClubID từ bảng Coaches.
SELECT CoachID, CoachName, ClubName, ClubID FROM Coaches;

-- 80. Chọn cột RefereeID, RefereeName, Age từ bảng Referees.
SELECT RefereeID, RefereeName, Age FROM Referees;

-- 81. Chọn tất cả cột từ bảng ClubLeaderboard, sắp xếp theo TotalPoints giảm dần.
SELECT * FROM ClubLeaderboard ORDER BY TotalPoints DESC;

-- 82. Chọn cột CoachName và ClubName từ bảng Coaches.
SELECT CoachName, ClubName FROM Coaches;

-- 83. Chọn cột RefereeName và Age từ bảng Referees.
SELECT RefereeName, Age FROM Referees;

-- 84. Chọn cột SponsorName từ bảng Sponsors khi ClubName bằng 'Club Name'.
SELECT SponsorName FROM Sponsors WHERE ClubName = 'Club Name';

-- 85. Chọn cột ChairmanName từ bảng ClubChairmen khi ClubName bằng 'Club Name'.
SELECT ChairmanName FROM ClubChairmen WHERE ClubName = 'Club Name';

-- 86. Chọn cột ClubName và RevenueAmount từ bảng Revenue.
SELECT ClubName, RevenueAmount FROM Revenue;

-- 87. Chọn tất cả cột từ bảng News khi Author bằng 'Author Name'.
SELECT * FROM News WHERE Author = 'Author Name';

-- 88. Chọn cột FootballerName và Position từ bảng Footballer khi ClubName bằng 'Club Name'.
SELECT FootballerName, Position FROM Footballer WHERE ClubName = 'Club Name';

-- 89. Chọn tất cả cột từ bảng Matches khi HomeTeamScore lớn hơn AwayTeamScore.
SELECT * FROM Matches WHERE HomeTeamScore > AwayTeamScore;

-- 90. Chọn cột ClubName từ bảng Stadiums khi City bằng 'City Name'.
SELECT ClubName FROM Stadiums WHERE City = 'City Name';

-- 91. Chọn tất cả cột từ bảng Matches khi [Group] bằng 'Group Name'.
SELECT * FROM Matches WHERE [Group] = 'Group Name';

-- 92. Chọn cột ClubName và TotalMatches từ bảng ClubLeaderboard.
SELECT ClubName, TotalMatches FROM ClubLeaderboard;

-- 93. Chọn cột FootballerName và TotalGoals từ bảng TopGoalsByPlayer khi TotalGoals lớn hơn 10.
SELECT FootballerName, TotalGoals FROM TopGoalsByPlayer WHERE TotalGoals > 10;

-- 94. Chọn cột ClubName từ bảng ClubLeaderboard khi Losses bằng 0.
SELECT ClubName FROM ClubLeaderboard WHERE Losses = 0;

-- 95. Chọn cột CoachName từ bảng Coaches, nhóm theo CoachName, có số lượng DISTINCT ClubName lớn hơn 1.
SELECT CoachName FROM Coaches GROUP BY CoachName HAVING COUNT(DISTINCT ClubName) > 1;

-- 96. Chọn cột RefereeName và Age từ bảng Referees khi Age nhỏ hơn 40.
SELECT RefereeName, Age FROM Referees WHERE Age < 40;

-- 97. Chọn cột ClubName và RevenueAmount từ bảng Revenue khi RevenueAmount lớn hơn 1000000.
SELECT ClubName, RevenueAmount FROM Revenue WHERE RevenueAmount > 1000000;

-- 98. Chọn tất cả cột từ bảng Matches khi Location bằng 'Stadium Name'.
SELECT * FROM Matches WHERE Location = 'Stadium Name';

-- 99. Chọn cột MatchNumber, DateUtc, HomeTeam, AwayTeam và HomeTeamScore từ bảng Matches khi HomeTeamScore lớn hơn AwayTeamScore.
SELECT MatchNumber, DateUtc, HomeTeam, AwayTeam, HomeTeamScore
FROM Matches
WHERE HomeTeamScore > AwayTeamScore;

-- 100. Chọn cột ClubName, RankNumber và TotalPoints từ bảng ClubLeaderboard khi TotalPoints bằng số điểm cao nhất.
SELECT ClubName, RankNumber, TotalPoints
FROM ClubLeaderboard
WHERE TotalPoints = (SELECT MAX(TotalPoints) FROM ClubLeaderboard);
CREATE DATABASE FootballAnalytics;
USE FootballAnalytics;

SELECT COUNT(*) FROM Dim_Player;
SELECT COUNT(*) FROM Dim_Club;
SELECT COUNT(*) FROM Dim_League;
SELECT COUNT(*) FROM Dim_Season;
SELECT COUNT(*) FROM Dim_Position;
SELECT COUNT(*) FROM Fact_Player_Performance;

SELECT * FROM Dim_Player Limit 5;

## Execute Data Normalization
## Trim Whitespace from Names

SET SQL_SAFE_UPDATES = 0;
UPDATE Dim_Player
SET PlayerName = TRIM(PlayerName);

UPDATE Dim_Club
SET ClubName = TRIM(ClubName);

UPDATE Dim_League
SET LeagueName = TRIM(LeagueName);

## Standardize Position Codes
DESCRIBE Dim_Position;

SELECT * FROM Dim_Position Limit 5;

SELECT *
FROM Dim_Player
WHERE PlayerName <> TRIM(PlayerName);

SELECT *
FROM Dim_Club
WHERE ClubName <> TRIM(ClubName);

SELECT *
FROM Dim_League
WHERE LeagueName <> TRIM(LeagueName);

SELECT *
FROM Dim_Position
WHERE PositionName <> TRIM(PositionName)
   OR PositionGroup <> TRIM(PositionGroup);
   
# Day 5
# Calculate 'Goal-to-Market-Value Ratio'
CREATE OR REPLACE VIEW vw_GoalMarketValueRatio AS
SELECT
    PerformanceID,
    PlayerID,
    ClubID,
    LeagueID,
    SeasonID,
    Goals,
    MarketValueEUR,
    ROUND(Goals * 1000000/ NULLIF(MarketValueEUR, 0), 4) AS GoalToMarketValueRatio
FROM Fact_Player_Performance;

SELECT *
FROM vw_GoalMarketValueRatio
LIMIT 10;

# Query Top Performers by League
# Filter players in the top 10% for Goals + Assists.

CREATE OR REPLACE VIEW vw_TopPerformers AS
SELECT
    PerformanceID,
    PlayerID,
    ClubID,
    LeagueID,
    SeasonID,
    Goals,
    Assists,
    (Goals + Assists) AS GoalContributions
FROM Fact_Player_Performance;

SELECT *
FROM (
    SELECT
        PlayerID,
        LeagueID,
        Goals,
        Assists,
        (Goals + Assists) AS GoalContributions,
        NTILE(10) OVER (
            PARTITION BY LeagueID
            ORDER BY (Goals + Assists) DESC
        ) AS Decile
    FROM Fact_Player_Performance
) AS RankedPlayers
WHERE Decile = 1;


SELECT *
FROM (
    SELECT
        p.PlayerName,
        l.LeagueName,
        f.Goals,
        f.Assists,
        (f.Goals + f.Assists) AS GoalContributions,
        NTILE(10) OVER (
            PARTITION BY f.LeagueID
            ORDER BY (f.Goals + f.Assists) DESC
        ) AS Decile
    FROM Fact_Player_Performance f
    JOIN Dim_Player p
        ON f.PlayerID = p.PlayerID
    JOIN Dim_League l
        ON f.LeagueID = l.LeagueID
) RankedPlayers
WHERE Decile = 1
ORDER BY LeagueName, GoalContributions DESC;


SELECT * FROM vw_GoalMarketValueRatio;
SELECT * FROM vw_TopPerformers;

# Day 6
# Budget Filter Query
SELECT
    f.PerformanceID,
    p.PlayerName,
    l.LeagueName,
    c.ClubName,
    f.MarketValueEUR,
    f.PassAccuracy,
    f.Goals,
    f.Assists
FROM Fact_Player_Performance f
JOIN Dim_Player p
    ON f.PlayerID = p.PlayerID
JOIN Dim_League l
    ON f.LeagueID = l.LeagueID
JOIN Dim_Club c
    ON f.ClubID = c.ClubID
WHERE f.MarketValueEUR < 15000000
  AND f.PassAccuracy > 80
ORDER BY f.PassAccuracy DESC, f.MarketValueEUR ASC;

CREATE OR REPLACE VIEW vw_BudgetPlayers AS
SELECT
    f.PerformanceID,
    p.PlayerName,
    c.ClubName,
    l.LeagueName,
    f.MarketValueEUR,
    f.PassAccuracy,
    f.Goals,
    f.Assists
FROM Fact_Player_Performance f
JOIN Dim_Player p
    ON f.PlayerID = p.PlayerID
JOIN Dim_Club c
    ON f.ClubID = c.ClubID
JOIN Dim_League l
    ON f.LeagueID = l.LeagueID
WHERE f.MarketValueEUR < 15000000
  AND f.PassAccuracy > 80;

SELECT * FROM vw_BudgetPlayers;

# Aggregate Average Goals & Assists by Position

SELECT
    dp.PositionName,
    dp.PositionGroup,
    ROUND(AVG(f.Goals),2) AS AvgGoals,
    ROUND(AVG(f.Assists),2) AS AvgAssists
FROM Fact_Player_Performance f
JOIN Dim_Position dp
    ON f.PositionID = dp.PositionID
GROUP BY
    dp.PositionName,
    dp.PositionGroup
ORDER BY AvgGoals DESC;

CREATE OR REPLACE VIEW vw_PositionBenchmark AS
SELECT
    dp.PositionName,
    dp.PositionGroup,
    ROUND(AVG(f.Goals),2) AS AvgGoals,
    ROUND(AVG(f.Assists),2) AS AvgAssists
FROM Fact_Player_Performance f
JOIN Dim_Position dp
    ON f.PositionID = dp.PositionID
GROUP BY
    dp.PositionName,
    dp.PositionGroup;
    
SELECT *
FROM vw_PositionBenchmark;

#Calculate Defensive Duels Won Rate per league
# Write SQL scripts for Expected Goals (xG) vs Actual Goals variance

SELECT
    f.*,
    l.LeagueName,

    ROUND(
        SUM(f.DefensiveDuelsWon) OVER(PARTITION BY f.LeagueID) /
        NULLIF(SUM(f.Matches) OVER(PARTITION BY f.LeagueID), 0),
        2
    ) AS DefensiveDuelsWonRate

FROM Fact_Player_Performance f
JOIN Dim_League l
ON f.LeagueID = l.LeagueID

ORDER BY l.LeagueName;

SELECT
    f.*,
    p.PlayerName,
    l.LeagueName,

    ROUND(f.Goals - f.xG,2) AS GoalVariance

FROM Fact_Player_Performance f

JOIN Dim_Player p
ON f.PlayerID = p.PlayerID

JOIN Dim_League l
ON f.LeagueID = l.LeagueID

ORDER BY GoalVariance DESC;

# Join Wage Data with Performance Metrics to Find Efficiency Scores
SELECT
    f.*,
    p.PlayerName,
    c.ClubName,
    l.LeagueName,
    pos.PositionName,
    pos.PositionGroup,
    s.Season,

    ROUND(f.GoalContribution / NULLIF(f.WageEUR, 0), 8) AS EfficiencyScore

FROM Fact_Player_Performance f

JOIN Dim_Player p
    ON f.PlayerID = p.PlayerID

JOIN Dim_Club c
    ON f.ClubID = c.ClubID

JOIN Dim_League l
    ON f.LeagueID = l.LeagueID

JOIN Dim_Position pos
    ON f.PositionID = pos.PositionID

JOIN Dim_Season s
    ON f.SeasonID = s.SeasonID

ORDER BY EfficiencyScore DESC;

# Optimize SQL Indexes for Faster Power BI Query Performance

CREATE INDEX idx_playerid
ON Fact_Player_Performance(PlayerID);

CREATE INDEX idx_clubid
ON Fact_Player_Performance(ClubID);

CREATE INDEX idx_leagueid
ON Fact_Player_Performance(LeagueID);

CREATE INDEX idx_positionid
ON Fact_Player_Performance(PositionID);

CREATE INDEX idx_seasonid
ON Fact_Player_Performance(SeasonID);

CREATE INDEX idx_marketvalue
ON Fact_Player_Performance(MarketValueEUR);

CREATE INDEX idx_goals
ON Fact_Player_Performance(Goals);

CREATE INDEX idx_goalcontribution
ON Fact_Player_Performance(GoalContribution);

SHOW INDEX FROM Fact_Player_Performance;


# Audit SQL Deliverables Against Evaluation Criteria
SELECT COUNT(*) AS TotalPlayers
FROM Dim_Player;
SELECT COUNT(*) AS TotalClubs
FROM Dim_Club;
SELECT COUNT(*) AS TotalLeagues
FROM Dim_League;
SELECT COUNT(*) AS TotalPositions
FROM Dim_Position;
SELECT COUNT(*) AS TotalSeasons
FROM Dim_Season;
SELECT COUNT(*) AS TotalPerformanceRecords
FROM Fact_Player_Performance;

SELECT *
FROM Fact_Player_Performance
WHERE
PlayerID IS NULL
OR ClubID IS NULL
OR LeagueID IS NULL
OR PositionID IS NULL
OR SeasonID IS NULL;

SELECT
COUNT(*) AS MatchingPlayers
FROM Fact_Player_Performance f
JOIN Dim_Player p
ON f.PlayerID=p.PlayerID;

SELECT
PerformanceID,
COUNT(*)
FROM Fact_Player_Performance
GROUP BY PerformanceID
HAVING COUNT(*)>1;

SELECT *
FROM vw_GoalMarketValueRatio
LIMIT 10;

SELECT *
FROM vw_TopPerformers
LIMIT 10;

# Export Final SQL-derived Dataset for Python

SELECT
    f.*,

    p.PlayerName,
    p.Age,
    p.Height,
    p.Weight,
    p.PreferredFoot,
    p.Nationality,

    c.ClubName,

    l.LeagueName,
    l.Country,
    l.UEFACoefficient,

    pos.PositionName,
    pos.PositionGroup,

    s.Season,
    s.StartYear,
    s.EndYear

FROM Fact_Player_Performance f

JOIN Dim_Player p
ON f.PlayerID=p.PlayerID

JOIN Dim_Club c
ON f.ClubID=c.ClubID

JOIN Dim_League l
ON f.LeagueID=l.LeagueID

JOIN Dim_Position pos
ON f.PositionID=pos.PositionID

JOIN Dim_Season s
ON f.SeasonID=s.SeasonID;

CREATE OR REPLACE VIEW vw_PlayerAnalytics AS
SELECT
    f.*,

    p.PlayerName,
    p.Age,
    p.Height,
    p.Weight,
    p.PreferredFoot,
    p.Nationality,

    c.ClubName,

    l.LeagueName,
    l.Country,
    l.UEFACoefficient,

    pos.PositionName,
    pos.PositionGroup,

    s.Season,
    s.StartYear,
    s.EndYear

FROM Fact_Player_Performance f

JOIN Dim_Player p
ON f.PlayerID = p.PlayerID

JOIN Dim_Club c
ON f.ClubID = c.ClubID

JOIN Dim_League l
ON f.LeagueID = l.LeagueID

JOIN Dim_Position pos
ON f.PositionID = pos.PositionID

JOIN Dim_Season s
ON f.SeasonID = s.SeasonID;

SELECT * FROM vw_PlayerAnalytics;

SELECT
    PlayerName,
    COUNT(*) AS TotalRows
FROM vw_PlayerAnalytics
GROUP BY PlayerName
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM vw_PlayerAnalytics;

SELECT COUNT(DISTINCT PlayerID) FROM vw_PlayerAnalytics;

CREATE OR REPLACE VIEW vw_PlayerDashboard AS
SELECT
    PlayerID,
    PlayerName,
    ClubName,
    LeagueName,
    PositionName,
    PositionGroup,

    AVG(MarketValueEUR) AS MarketValueEUR,
    AVG(WageEUR) AS WageEUR,
    SUM(Goals) AS Goals,
    SUM(Assists) AS Assists,
    SUM(GoalContribution) AS GoalContribution,
    AVG(PerformanceScore) AS PerformanceScore

FROM vw_PlayerAnalytics
GROUP BY
    PlayerID,
    PlayerName,
    ClubName,
    LeagueName,
    PositionName,
    PositionGroup;
    
    CREATE OR REPLACE VIEW vw_PlayerDashboard AS
SELECT
    f.PlayerID,
    p.PlayerName,
    p.Age,
    p.Height,
    p.Weight,
    p.PreferredFoot,
    p.Nationality,

    c.ClubName,

    l.LeagueName,
    l.Country,
    l.UEFACoefficient,

    pos.PositionName,
    pos.PositionGroup,

    AVG(f.MarketValueEUR) AS MarketValueEUR,
    AVG(f.WageEUR) AS WageEUR,

    SUM(f.Matches) AS Matches,
    SUM(f.MinutesPlayed) AS MinutesPlayed,

    SUM(f.Goals) AS Goals,
    SUM(f.Assists) AS Assists,
    SUM(f.GoalContribution) AS GoalContribution,

    SUM(f.xG) AS xG,
    SUM(f.xA) AS xA,

    AVG(f.PassAccuracy) AS PassAccuracy,

    SUM(f.KeyPasses) AS KeyPasses,
    SUM(f.TacklesWon) AS TacklesWon,
    SUM(f.Interceptions) AS Interceptions,
    SUM(f.DefensiveDuelsWon) AS DefensiveDuelsWon,

    SUM(f.Shots) AS Shots,
    SUM(f.ShotsOnTarget) AS ShotsOnTarget,
    SUM(f.DribblesCompleted) AS DribblesCompleted,
    SUM(f.ProgressivePasses) AS ProgressivePasses,
    SUM(f.ProgressiveCarries) AS ProgressiveCarries,

    AVG(f.GoalValueRatio) AS GoalValueRatio,
    AVG(f.PerformanceScore) AS PerformanceScore

FROM Fact_Player_Performance f

JOIN Dim_Player p
ON f.PlayerID = p.PlayerID

JOIN Dim_Club c
ON f.ClubID = c.ClubID

JOIN Dim_League l
ON f.LeagueID = l.LeagueID

JOIN Dim_Position pos
ON f.PositionID = pos.PositionID

GROUP BY
    f.PlayerID,
    p.PlayerName,
    p.Age,
    p.Height,
    p.Weight,
    p.PreferredFoot,
    p.Nationality,
    c.ClubName,
    l.LeagueName,
    l.Country,
    l.UEFACoefficient,
    pos.PositionName,
    pos.PositionGroup;
    
    SELECT COUNT(*) FROM vw_PlayerDashboard;
    
    SELECT COUNT(DISTINCT PlayerID) FROM vw_PlayerDashboard;
    
    SELECT COUNT(*) FROM vw_PlayerDashboard;
    
    SELECT
    PlayerID,
    PlayerName,
    COUNT(*) AS Records
FROM vw_PlayerDashboard
GROUP BY PlayerID, PlayerName
HAVING COUNT(*) > 1;

CREATE OR REPLACE VIEW vw_PlayerDashboard AS
SELECT
    f.PlayerID,
    MAX(p.PlayerName) AS PlayerName,
    MAX(p.Age) AS Age,
    MAX(p.Height) AS Height,
    MAX(p.Weight) AS Weight,
    MAX(p.PreferredFoot) AS PreferredFoot,
    MAX(p.Nationality) AS Nationality,

    MAX(c.ClubName) AS ClubName,
    MAX(l.LeagueName) AS LeagueName,
    MAX(l.Country) AS LeagueCountry,
    MAX(l.UEFACoefficient) AS UEFACoefficient,

    MAX(pos.PositionName) AS PositionName,
    MAX(pos.PositionGroup) AS PositionGroup,

    AVG(f.MarketValueEUR) AS MarketValueEUR,
    AVG(f.WageEUR) AS WageEUR,

    SUM(f.Matches) AS Matches,
    SUM(f.MinutesPlayed) AS MinutesPlayed,
    SUM(f.Goals) AS Goals,
    SUM(f.Assists) AS Assists,
    SUM(f.GoalContribution) AS GoalContribution,
    SUM(f.xG) AS xG,
    SUM(f.xA) AS xA,

    AVG(f.PassAccuracy) AS PassAccuracy,

    SUM(f.KeyPasses) AS KeyPasses,
    SUM(f.TacklesWon) AS TacklesWon,
    SUM(f.Interceptions) AS Interceptions,
    SUM(f.DefensiveDuelsWon) AS DefensiveDuelsWon,
    SUM(f.Shots) AS Shots,
    SUM(f.ShotsOnTarget) AS ShotsOnTarget,
    SUM(f.DribblesCompleted) AS DribblesCompleted,
    SUM(f.ProgressivePasses) AS ProgressivePasses,
    SUM(f.ProgressiveCarries) AS ProgressiveCarries,

    AVG(f.GoalValueRatio) AS GoalValueRatio,
    AVG(f.PerformanceScore) AS PerformanceScore

FROM Fact_Player_Performance f
JOIN Dim_Player p
    ON f.PlayerID = p.PlayerID
JOIN Dim_Club c
    ON f.ClubID = c.ClubID
JOIN Dim_League l
    ON f.LeagueID = l.LeagueID
JOIN Dim_Position pos
    ON f.PositionID = pos.PositionID

GROUP BY
    f.PlayerID;
    
SELECT COUNT(*) FROM vw_PlayerDashboard;

SELECT PlayerID, COUNT(*)
FROM vw_PlayerDashboard
GROUP BY PlayerID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS Players,
    SUM(MarketValueEUR) AS TotalMarketValue,
    AVG(MarketValueEUR) AS AverageMarketValue,
    MIN(MarketValueEUR) AS MinMarketValue,
    MAX(MarketValueEUR) AS MaxMarketValue
FROM vw_PlayerDashboard;

SELECT PlayerName, MarketValueEUR
FROM vw_PlayerDashboard
ORDER BY MarketValueEUR DESC
LIMIT 10;

SELECT * FROM vw_PlayerDashboard;

DESCRIBE vw_PlayerDashboard;

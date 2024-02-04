USE YouTube_Spotify;
-- SEE THE TABLE STRUCTURE
SELECT TOP 10 * FROM Audios;

-- Most viewed song track on youtube?

SELECT top 1 A.Album, A.Artist, A.Title, A.Views
FROM Audios A
WHERE A.most_playedon = 'YouTube'
ORDER BY A.Views DESC

-- Most streamed song track on Spotify?

SELECT TOP 1 A.Album, A.Artist, A.Title, A.Stream
FROM Audios A
WHERE A.most_playedon = 'Spotify'
ORDER BY A.Stream DESC

-- Top 5 songs that have the highest energyliveness ratio

SELECT TOP 5 A.Album, A.Artist, A.Title, (ROUND(A.EnergyLiveness,2)) AS EnergyLiveness_Ratio
FROM Audios A
ORDER BY A.EnergyLiveness DESC

-- To know which platform is capable of keeping an Artist's song track more engaged. 
-- Check where his/her song tracks are more played on. Compare the platforms.
-- Example Black Eyed Peas

SELECT A.Artist, A.most_playedon, COUNT(A.most_playedon) AS Count_Platform
FROM Audios A
GROUP BY A.Artist, A.most_playedon
HAVING A.Artist = 'Black Eyed Peas'
ORDER BY Count_Platform DESC

-- To know the most liked song along with the Energy and Tempo of the song.
-- Example Gorillaz

SELECT TOP 1 A.Album, A.Title, A.Likes, ROUND(A.Energy,2) AS Energy, ROUND(A.Tempo,2) AS Tempo
FROM Audios A
WHERE A.Album = 'Gorillaz'
ORDER BY A.Likes DESC

-- Prominent album types on both platforms

SELECT TOP 1 A.most_playedon, A.Album_type, COUNT(A.Album_Type) AS Count_Album_type
FROM Audios A
GROUP BY A.Album_type, A.most_playedon
HAVING A.most_playedon = 'YouTube'
ORDER BY Count_Album_type DESC
SELECT TOP 1 A.most_playedon, A.Album_type, COUNT(A.Album_type) AS Count_Album_type
FROM Audios A
GROUP BY A.Album_type, A.most_playedon
HAVING A.most_playedon = 'Spotify'
ORDER BY Count_Album_type DESC

-- Spotify's most loved song tracks are to be declared soon. Help Spotify choose the top 5 most streamed+youtube viewed song track.

WITH RankedAlbums AS (
    SELECT TOP 7
        Album, 
        Title, 
        Artist, 
        ROW_NUMBER() OVER (PARTITION BY Album, Title ORDER BY Stream + Views DESC) AS RowNum
    FROM Audios
	ORDER BY (Stream +Views) DESC
)
SELECT TOP 7 Album, Title, Artist
FROM RankedAlbums
WHERE RowNum = 1

-- Top 5 official songs that can be danced the most to

SELECT TOP 5 A.Title, A.Artist, ROUND(A.Danceability,2) AS Danceability
FROM Audios A
WHERE A.official_video = 1
ORDER BY A.Danceability DESC

-- Top 5 Songs on Youtube with least comments and least Likes, but most views

SELECT TOP 5 A.Title, A.Likes, A.Comments, A.Views
FROM Audios A
WHERE A.most_playedon = 'YouTube'
ORDER BY A.Likes ASC, A.Comments ASC, A.Views DESC

-- It is surprising to see top 4 of them being Nursery Rhymes

-- Artist with  Average Valance Values greater than 0.6
SELECT A.Artist, ROUND(AVG(A.Valence),2) AS AVG_Valence
FROM Audios A
GROUP BY A.Artist
HAVING ROUND(AVG(A.Valence),2) > 0.6
ORDER BY AVG_Valence DESC

--
SELECT TOP 1* FROM Audios

--Top 5 Albums with maximum likes

SELECT TOP 5 A.Album, SUM(A.Likes) AS Total_Likes
FROM Audios A
GROUP BY A.Album
ORDER BY Total_Likes DESC

-- Top 5 Artists with maximum Likes

SELECT TOP 5 A.Artist, SUM(A.Likes) AS Total_Likes
FROM Audios A
GROUP BY A.Artist
ORDER BY Total_Likes DESC

-- Top 5 Artists with maximum singles 

SELECT TOP 5 A.Artist, COUNT(A.Artist) AS Total_Singles
FROM Audios A
WHERE A.Album_type = 'single'
GROUP BY A.Artist
ORDER BY Total_Singles DESC


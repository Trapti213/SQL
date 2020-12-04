****************************************
---Example of Rank, Dense Rank, Row Number
****************************************

---We had a table which used to capture logs of all the events played.

--Sample Query:
CREATE TABLE sample1 (player_name varchar(10),status char(15), time TIMESTAMP, score int )

INSERT INTO sample1 values ('Gaurav' ,'completed', '12-4-2020 08:04:01', 10)
INSERT INTO sample1 values ('Kirti','completed','2020-12-04 8:04:10',8 );
INSERT INTO sample1 values ('Atul' ,'completed','2020-12-04 8:05:01' ,10 )                            
INSERT INTO sample1 values ('Mitali' ,'completed','2020-12-04 8:06:01' ,7 );
INSERT INTO sample1 values ( 'Trapti','completed','2020-12-04 8:07:12',10);
INSERT INTO sample1 values ('Omkar' ,'incompleted','2020-12-04 8:15:07',7);


INSERT INTO sample1 values ('Supriya' ,'completed', '12/4/2020 8:15:11', 9)
INSERT INTO sample1 values ('Vikrant' ,'completed', '12/4/2020 8:16:01', 5)
INSERT INTO sample1 values ('Ronaldo' ,'completed', '12/4/2020 8:16:02', 4)
INSERT INTO sample1 values ('Neema' ,'completed', '12/4/2020 8:17:01', 8)
INSERT INTO sample1 values ( 'Aditya','completed', '12-4-2020 08:10:01', 8);
INSERT INTO sample1 values ('Nitin','completed', '12-4-2020 08:14:02', 5);
INSERT INTO sample1 values ( 'Archit','completed', '12-4-2020 08:14:04', 9);
INSERT INTO sample1 values ( 'Aditi','completed', '12-4-2020 08:15:01', 7);
INSERT INTO sample1 values ('leena','incompleted', '12-4-2020 08:15:01', 9);

############
---ROW_NUMBER()
############

---Q. Find the top 5 earliest game players, who completed the game.

WITH base as (
        SELECT 
	        player_name,
          ROW_NUMBER() OVER (order by time::TIMESTAMP) as row
        FROM table1
        WHERE status= ‘completed’
)
SELECT 
    * 
FROM base 
WHERE row <= 5


###########
---RANK()
###########

---Q.We have only 3 prized to be awarded, to the top 3 winners based on the game_score

WITH base as (
        SELECT 
	        player_name,
          RANK() OVER (ORDER BY score desc) as ranku
        FROM table1
)
SELECT 
    * 
FROM base 
WHERE ranku <= 5


#################
---DENSE_RANK()
#################


--Q.Top 5 earliest game completions.

WITH base as (
      SELECT 
	      player_name,
        DENSE_RANK() OVER (ORDER BY score desc) as rank
      FROM table1
      WHERE status = ‘completed’
)
SELECT 
    * 
FROM base 
WHERE rank <= 5

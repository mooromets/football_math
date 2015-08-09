
--data for building home table
drop view HomeTableData;
create view HomeTableData as
	--count winnings
select HomeTeam as Team, null as played, count (*) as won, null as drawn, null as lost, 
		null as GS, null as GC, count(*) * 3 as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG > FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by HomeTeam
union --count draws
select HomeTeam as Team, null as played, null as won, count(*) drawn, null as lost, 
		null as GS, null as GC, count(*) as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG = FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by HomeTeam
union --count loses
select HomeTeam as Team, null as played, null as won, null as drawn, count (*) as lost, 
		null as GS, null as GC, 0 as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG < FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by HomeTeam
union --count goals
select HomeTeam as Team, count(*) as played, null as won, null as drawn, null as lost, 
		sum(FTHG) as GS, sum(FTAG) as GC, null as PTS, min(Date) as FirstGame, max(Date) as LastGame
	from e0
	where Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by HomeTeam;

--HomeTable
drop view HomeTable;
create view HomeTable as 
select Team, sum(played) as GP, sum(won) as W, sum (drawn) as D, sum(lost) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GS) - sum(GC) as GD, sum(PTS) as Pts, 
		min(FirstGame) as FirstGame, max(LastGame) as LastGame
	from HomeTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;

-- data for building away table
drop view AwayTableData;
create view AwayTableData as
	--count winnings
select AwayTeam as Team, null as played, count (*) as won, null as drawn, null as lost, 
		null as GS, null as GC, count(*) * 3 as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG < FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by AwayTeam
union --count draws
select AwayTeam as Team, null as played, null as won, count(*) drawn, null as lost, 
		null as GS, null as GC, count(*) as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG = FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by AwayTeam
union --count loses
select AwayTeam as Team, null as played, null as won, null as drawn, count (*) as lost, 
		null as GS, null as GC, 0 as PTS, null as FirstGame, null as LastGame
	from e0
	where FTHG > FTAG and Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by AwayTeam
union --count goals
select AwayTeam as Team, count(*) as played, null as won, null as drawn, null as lost, 
		sum(FTAG) as GS, sum(FTHG) as GC, null as PTS, min(Date) as FirstGame, max(Date) as LastGame
	from e0
	where Div = 'E0' and Date > '2014-08-01' and Date < '2015-05-31'
	group by AwayTeam;

--AwayTable
drop view AwayTable;
create view AwayTable as 
select Team, sum(played) as GP, sum(won) as W, sum (drawn) as D, sum(lost) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GS) - sum(GC) as GD, sum(PTS) as Pts, 
		min(FirstGame) as FirstGame, max(LastGame) as LastGame
	from AwayTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;

--LeagueTableData
drop view LeagueTableData;
create view LeagueTableData as 
select *
	from AwayTable
union
select *
	from HomeTable;

--League table
drop view LeagueTable;
create view LeagueTable as 
select Team, sum(GP) as GP, sum(W) as W, sum (D) as D, sum(L) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GD) as GD, sum(Pts) as Pts, 
		min(FirstGame) as FirstGame, max(LastGame) as LastGame
	from LeagueTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;	
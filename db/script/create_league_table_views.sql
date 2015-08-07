
--data for building home table
create view HomeTableData as
	--count winnings
select HomeTeam as Team, null as played, count (*) as won, null as drawn, null as lost, 
		null as GS, null as GC, count(*) * 3 as PTS
	from e0
	where FTHG > FTAG
	group by HomeTeam
union --count draws
select HomeTeam as Team, null as played, null as won, count(*) drawn, null as lost, 
		null as GS, null as GC, count(*) as PTS
	from e0
	where FTHG = FTAG
	group by HomeTeam
union --count loses
select HomeTeam as Team, null as played, null as won, null as drawn, count (*) as lost, 
		null as GS, null as GC, 0 as PTS
	from e0
	where FTHG < FTAG
	group by HomeTeam
union --count goals
select HomeTeam as Team, count(*) as played, null as won, null as drawn, null as lost, 
		sum(FTHG) as GS, sum(FTAG) as GC, null as PTS
	from e0
	group by HomeTeam;

--HomeTable
create view HomeTable as 
select Team, sum(played) as GP, sum(won) as W, sum (drawn) as D, sum(lost) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GS) - sum(GC) as GD, sum(PTS) as Pts
	from HomeTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;


-- data for building away table
create view AwayTableData as
	--count winnings
select AwayTeam as Team, null as played, count (*) as won, null as drawn, null as lost, 
		null as GS, null as GC, count(*) * 3 as PTS
	from e0
	where FTHG < FTAG
	group by AwayTeam
union --count draws
select AwayTeam as Team, null as played, null as won, count(*) drawn, null as lost, 
		null as GS, null as GC, count(*) as PTS
	from e0
	where FTHG = FTAG
	group by AwayTeam
union --count loses
select AwayTeam as Team, null as played, null as won, null as drawn, count (*) as lost, 
		null as GS, null as GC, 0 as PTS
	from e0
	where FTHG > FTAG
	group by AwayTeam
union --count goals
select AwayTeam as Team, count(*) as played, null as won, null as drawn, null as lost, 
		sum(FTAG) as GS, sum(FTHG) as GC, null as PTS
	from e0
	group by AwayTeam;

--AwayTable
create view AwayTable as 
select Team, sum(played) as GP, sum(won) as W, sum (drawn) as D, sum(lost) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GS) - sum(GC) as GD, sum(PTS) as Pts
	from AwayTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;

--LeagueTableData
create view LeagueTableData as 
select *
	from AwayTable
union
select *
	from HomeTable;

--League table
--create view LeagueTable as 
select Team, sum(GP) as GP, sum(W) as W, sum (D) as D, sum(L) as L,
		sum(GS) as GS, sum(GC) as GC, sum(GD) as GD, sum(Pts) as Pts
	from LeagueTableData
	group by Team
	order by Pts DESC, GD DESC, GS DESC, Team DESC;	
CREATE DATABASE Milestone2horizon
USE Milestone2horizon
GO

create PROCEDURE createAllTables
	AS

create Table SystemUser(
username VARCHAR(20),
password VARCHAR(20),
PRIMARY KEY(username)
)

create Table Fan(
national_ID VARCHAR(20) ,
name VARCHAR(20),
birth_date Date,
address VARCHAR(20),
phone_no int,--phone_no VARCHAR(11) to int ahmed
status BIT,
username VARCHAR(20),
PRIMARY KEY(national_ID),
FOREIGN Key(username) references SystemUser on delete cascade on update CASCADE
)

create Table Stadium(
ID Int IDENTITY PRIMARY Key,
name VARCHAR(20),
location VARCHAR(20),
capacity INT,
status BIT
)

CREATE table StadiumManager (
ID INT IDENTITY PRIMARY Key,
name VARCHAR(20),
Stadium_ID INT ,  --Multiple identity columns specified for table 'StadiumManager'. Only one identity column per table is allowed. I remove identity from student-id Ahmed
username VARCHAR(20),
FOREIGN Key(username) references SystemUser on delete cascade on update CASCADE
)

create Table Club(
club_ID INT IDENTITY PRIMARY KEY,
name VARCHAR(20),
location VARCHAR(20),
) 

create Table ClubRepresentative(
ID INT IDENTITY PRIMARY Key,
name VARCHAR(20),
club_ID INT ,--Multiple identity columns specified for table 'ClubRepresentative'. Only one identity column per table is allowed. I remove identity from club-id Ahmed
username VARCHAR(20),
FOREIGN Key(username) references SystemUser on delete cascade on update CASCADE
)

create Table AssociationManager(
ID INT IDENTITY PRIMARY Key,
name VARCHAR(20),
username VARCHAR(20),
FOREIGN Key(username) references SystemUser on delete cascade on update CASCADE
)

create Table SystemAdmin(
ID INT IDENTITY PRIMARY Key,
name VARCHAR(20),
username VARCHAR(20),
FOREIGN Key(username) references SystemUser on delete cascade on update CASCADE
)

create Table Match(
match_ID  INT IDENTITY PRIMARY KEY ,
start_time datetime,
end_time datetime,
host_club_ID INT,
guest_club_ID INT,
stadium_ID INT,
FOREIGN KEY(host_club_ID) references Club on delete CASCADE on update CASCADE,
FOREIGN KEY(guest_club_ID ) references Club , --Introducing FOREIGN KEY constraint 'FK__Match__guest_clu__4BAC3F29' on table 'Match' may cause cycles or multiple cascade paths. Specify ON DELETE NO ACTION or ON UPDATE NO ACTION, or modify other FOREIGN KEY constraints. delete on on cascade Ahmed 
FOREIGN KEY(stadium_ID) references StadiumManager on delete CASCADE on update CASCADE
)


CREATE Table Ticket(
ID INT IDENTITY PRIMARY KEY, 
status BIT,
match_ID  INT ,
FOREIGN Key(match_ID) references Match on delete CASCADE on update CASCADE 
)

CREATE Table TicketBuyingTransaction(
fan_nationalID  varchar(20) ,-- in some procedure they wiil pass it as varchar so we can change type to varchar and it stated in milestone it is varchar ahmed 
ticket_ID  INT ,
PRIMARY Key(fan_nationalID,ticket_ID),
FOREIGN Key(ticket_ID) references Ticket ,-- I deleted 
FOREIGN Key(fan_nationalID) references Fan on delete cascade on update CASCADE
	/* deleteMatchesOnStadium doesn't work
	The DELETE statement conflicted with the REFERENCE constraint "FK__TicketBuy__ticke__656C112C". 
	The conflict occurred in database "Milestone", table "dbo.TicketBuyingTransaction", column 'ticket_ID'. */
)

create Table HostRequest (
ID INT IDENTITY PRIMARY KEY,
repersentative_ID INT,
manager_ID INT,
match_ID INT,
status VARCHAR(20) --status is varchar as status can either be unhandled, accepted or rejected.
FOREIGN KEY(repersentative_ID) references ClubRepresentative ,-- Introducing FOREIGN KEY constraint 'FK_TicketBuyticke_5441852A' on table 'TicketBuyingTransaction' may cause cycles or multiple cascade paths. Specify ON DELETE NO ACTION or ON UPDATE NO ACTION, or modify other FOREIGN KEY constraints. delete the cascade ahmed
FOREIGN KEY(match_ID) references Match on delete CASCADE on update CASCADE,
FOREIGN KEY(manager_ID) references StadiumManager ,-- delete the cascade ahmed
)
GO


create procedure dropAllTables 
AS
drop Table SystemUser
drop Table Fan
drop Table StadiumManager
drop Table ClubRepresentative
drop Table AssociationManager
drop Table SystemAdmin
drop Table TicketBuyingTransaction
drop Table Ticket
drop Table Club
drop Table Stadium
drop Table HostRequest
drop Table Match
GO

create procedure dropAllProceduresFunctionsViews
AS

drop procedure createAllTables
drop procedure dropAllTables
drop procedure clearAllTables
drop procedure addAssociationManager
drop procedure addNewMatch
drop procedure deleteMatch
drop procedure deleteMatchesOnStadium
drop procedure addClub
drop procedure addTicket
drop procedure deleteClub
drop procedure addStadium
drop procedure deleteStadium
drop procedure blockFan
drop procedure unblockFan
drop procedure addRepresentative
drop procedure addHostRequest
drop procedure addStadiumManager
drop procedure acceptRequest
drop procedure rejectRequest
drop procedure addFan
drop procedure purchaseTicket
drop procedure updateMatchTiming
drop procedure deleteMatchesOn
drop procedure clubWithTheMostSoldTickets
 
drop view allAssocManagers
drop view allClubRepresentatives
drop view allStadiumManagers
drop view allFans
drop view allMatches
drop view allTickets
drop view allCLubs
drop view allStadiums
drop view allRequests
drop view clubsWithNoMatches
drop view matchesPerTeam
drop view matchWithMostSoldTickets
drop view matchesRankedBySoldTickets
drop view clubsRankedBySoldTickets

drop function viewAvailableStadiumsOn
drop function allUnassignedMatches
drop function allPendingRequests
drop function upcomingMatchesOfClub
drop function availableMatchesToAttend
drop function stadiumsNeverPlayedOn
GO

create procedure clearAllTables 
AS
TRUNCATE Table SystemUser
TRUNCATE Table Fan
TRUNCATE Table StadiumManager
TRUNCATE Table ClubRepresentative
TRUNCATE Table AssociationManager
TRUNCATE Table SystemAdmin
TRUNCATE Table TicketBuyingTransaction
TRUNCATE Table Ticket
TRUNCATE Table Club
TRUNCATE Table Stadium
TRUNCATE Table HostRequest
TRUNCATE Table Match
GO

---------------------------PART 2.2-------------------------------------PART 2.2

create view allAssocManagers
as
select S.username,password,name from AssociationManager A Inner Join SystemUser S on A.username=S.username 
GO

create  view allClubRepresentatives
as
select S.username,password,C.name as RepresentativeName,cl.name as ClubName 
from ClubRepresentative C Inner Join SystemUser S on C.username=S.username  Inner join Club cl on cl.club_ID=C.club_ID
GO

create  view allStadiumManagers
as
select sm.username,password,sm.name as ManagerName,st.name as StadiumName
from StadiumManager sm Inner Join SystemUser s on sm.username=s.username Inner join Stadium st on st.ID =sm.Stadium_ID
GO

create view allFans
as
select S.username,password,name, national_ID , birth_date , status 
from Fan F Inner Join SystemUser S on F.username=S.username
GO

create view allMatches
as 
select C1.name as Host_Club, C2.name as Guest_Club, M.start_time AS StartTime
from Match M inner join Club C1 on M.host_club_ID = C1.club_ID inner join Club C2 on M.guest_club_ID = C2.club_ID 
GO

create view allTickets
as 
select C1.name as Host_Club, C2.name as Guest_Club,S.name as StadiumName, M.start_time AS StartTime
from Match M inner join Club C1 on M.host_club_ID = C1.club_ID
inner join Club C2 on M.guest_club_ID = C2.club_ID Inner JOIN Stadium S on M.stadium_ID=S.ID
GO

create view allCLubs
as
select name,location from Club
GO

create view allStadiums
as
select name ,location, capacity, status from Stadium
GO

create view allRequests 
as
select S.username as ManagerName ,C.username as RepresentativeName ,H.status from 
StadiumManager S Inner Join HostRequest H on S.ID =H.manager_ID Inner Join  ClubRepresentative C on C.ID =H.repersentative_ID
GO


---------------------------PART 2.3-------------------------------------PART 2.3

create procedure addAssociationManager
@name varchar(20),
@username varchar(20),
@password varchar(20)
AS 
BEGIN 

insert  into SystemUser values (@username,@password)
insert into AssociationManager (name ,username)
values(@name,@username)

END
GO

create procedure addNewMatch
  @host_club varchar(20),
  @guest_club varchar(20),
  @start_time DATETIME,
  @end_time DATETIME
AS 
BEGIN 
declare @x INT ,@y INT

select @x=c1.club_ID from  club c1 where  c1.name= @host_club
select @y=c2.club_ID from club c2 where  c2.name= @guest_club
insert into Match(start_time,end_time,host_club_ID,guest_club_ID) 
					values(@start_time,@end_time,@x,@y)
END 
GO

create view clubsWithNoMatches
AS
Select  C.name from Club C
where not exists (select * from Match M where M.host_club_ID= C.club_ID OR M.guest_club_ID= C.club_ID)
GO

create procedure deleteMatch
  @host_club varchar(20),
  @guest_club varchar(20)

  AS
  BEGIN 
declare @x INT ,@y INT

SELECT @x=c1.club_ID from club c1 where c1.name=@host_club
select @y=c2.club_ID from club c2 where c2.name=@guest_club

DELETE From Match
where host_club_ID=@x and guest_club_ID=@y

  END
GO

create procedure deleteMatchesOnStadium
@sname Varchar(20)
AS
BEGIN 
declare @sid INT
select @sid=s.ID from Stadium s where s.name=@sname

DELETE from Ticket 
where exists (select Match.match_ID from Match where Match.match_ID=Ticket.match_ID 
			and Match.stadium_ID=@sid and Match.start_time>CURRENT_TIMESTAMP)

DELETE from Match where stadium_ID=@sid AND start_time>=CURRENT_TIMESTAMP

END
GO

create procedure addClub
@clubname Varchar(20),
@clublocation Varchar(20)
AS
BEGIN
Insert INTO Club(name,location) values (@clubname,@clublocation)
END
GO

create procedure addTicket
@host_clubName Varchar(20),
@guest_clubName Varchar(20),
@startTime DATETIME
AS
BEGIN

declare @x INT,@y INT,@z INT
SELECT @x=c1.club_ID from  club c1 where  c1.name= @host_clubName
select @y=c2.club_ID from club c2 where  c2.name= @guest_clubNAme
select @z=m.match_ID from Match m  WHERE m.host_club_ID=@x and m.guest_club_ID=@y and m.start_time=@startTime
INSERT INTO Ticket values(1,@z)
END
GO

create procedure deleteClub
@clubname Varchar(20)
AS
BEGIN
DELETE from Club where name=@clubname
END
GO

create procedure addStadium
@StadiumName Varchar(20),
@StadiumLocation Varchar(20),
@capacity INT
AS 
BEGIN 
INSERT INTO Stadium values(@StadiumName,@StadiumLocation,@capacity,1)

END
GO

create procedure deleteStadium
@StadiumName Varchar(20)

AS BEGIN
delete from Stadium where name=@StadiumName

END
GO

create proc blockFan
@fanNationalID INT
AS BEGIN

UPDATE Fan 
set status =0 where national_ID=@fanNationalID

END
GO

create proc unblockFan
@fanNationalID INT
AS BEGIN

UPDATE Fan 
set status =1 where national_ID=@fanNationalID

END
GO

create proc addRepresentative
  @name varchar(20) ,
  @club_name varchar(20) ,
  @password varchar(20) 

  AS
  Begin 
  declare @x  varchar(20),
   @y INT 
  select @x=username from  SystemUser S where S.password =@password
  select @y=club_ID from Club C where C.name=@club_name
INSERT INTO ClubRepresentative values  (@name,@y,@x)
  END 
GO

create function viewAvailableStadiumsOn 
(@ctime datetime) 
returns table
as
return
(
select s.name, s.location, s.capacity from Stadium s where s.status=1 and not exists (select m.stadium_ID from Match m where m.stadium_ID=s.ID)

UNION

select name,location,capacity 
from Stadium s1  inner join Match m on m.stadium_ID=s1.ID where s1.status=1 

EXCEPT

select name,location,capacity 
FROM Stadium s2  inner join Match m on m.stadium_ID=s2.ID WHERE m.start_time<@ctime and @ctime<m.end_time
)
GO

create procedure addHostRequest
@clubname varchar(20), ---guest club name
@stadiumname varchar(20),
@starttime datetime
as

declare @guestclubID Int
declare @repID Int
declare @hostclubID Int
declare @managerID Int
declare @matchID Int
declare @stadiumID Int

select @stadiumID=s.ID from Stadium s where s.name=@stadiumname
select @managerID=sm.ID from StadiumManager sm where sm.ID=@stadiumID

select @hostclubID=c.club_ID from Club c where c.name=@clubname
select @repID=cr.ID from ClubRepresentative cr where cr.club_ID=@hostclubID


insert into Match(start_time,host_club_ID,stadium_ID) values (@starttime,@hostclubID,@stadiumID)
select @matchID=m.match_ID from Match m where m.start_time=@starttime and m.host_club_ID=@hostclubID and m.stadium_ID=@stadiumID

Insert Into HostRequest values (@repID,@managerID,@matchID,'unhandled')
GO

create function allUnassignedMatches
(@cname varchar(20))
returns table
as
return
(
select c2.name as Guest_Club_name, m.start_time as Start_time
from Match m, Club c1,Club c2 
where m.host_club_ID=c1.club_ID and m.guest_club_ID=c2.club_ID
and @cname=c1.name and m.stadium_ID is null
)
GO

create procedure addStadiumManager
@name varchar(20),
@stadiumname varchar(20),
@username varchar(20),
@password varchar(20)
as
insert into SystemUser values (@username, @password)

declare @stadiumid varchar(20)
select distinct @stadiumid=s.ID from Stadium s where s.name=@stadiumname

insert into StadiumManager values (@name,@stadiumid,@username)
GO

create function allPendingRequests
(@smname varchar(20))
returns table
as
return
(
select cr.name as Representative_Name, c.name as Club_Name, m.start_time
from HostRequest hr, StadiumManager sm, ClubRepresentative cr, Club c, Match m
where @smname=sm.username and hr.status='unhandled' 
		and hr.manager_ID=sm.ID and hr.repersentative_ID=cr.ID 
		and cr.club_ID=c.club_ID and hr.match_ID=m.match_ID and m.guest_club_ID=cr.club_ID
)
GO

create procedure acceptRequest
@username_Stadium_manager varchar(20),
@hosting_club_name varchar(20),
@guest_club_name varchar(20),
@start_time Datetime 
as
declare @manager_id int ,@representitive_id int ,@match_id int ,@host_club_id int , @guest_club_id int
select @representitive_id=r.ID from ClubRepresentative r
                                    inner join Club c  on r.club_ID=c.club_ID
                                    where c.name= @hosting_club_name  ;  
select @host_club_id=c.club_ID from Club c where c.name=@hosting_club_name;
select @guest_club_id=c.club_ID from Club c where c.name=@guest_club_name;
select @manager_id = m.ID from StadiumManager m
                               where m.username=@username_Stadium_manager;
select @match_id=m.match_ID from match m
                                where m.start_time=@start_time and m.host_club_ID=@host_club_id and m.guest_club_ID=@guest_club_id;
UPDATE HostRequest
set HostRequest.status='accepted'
where HostRequest.repersentative_ID=@representitive_id and HostRequest.manager_ID=@manager_id and HostRequest.match_ID=@match_id and HostRequest.status='unhandled';
GO

create procedure rejectRequest -- ahmed 
@username_Stadium_manager varchar(20),
@hosting_club_name varchar(20),
@guest_club_name varchar(20),
@start_time Datetime 
As
declare @manager_id int ,@representitive_id int ,@match_id int ,@host_club_id int , @guest_club_id int
select @representitive_id=r.ID from ClubRepresentative r
                                    inner join Club c  on r.club_ID=c.club_ID
                                    where c.name= @hosting_club_name  ;  
select @host_club_id=c.club_ID from Club c where c.name=@hosting_club_name;
select @guest_club_id=c.club_ID from Club c where c.name=@guest_club_name;
select @manager_id = m.ID from StadiumManager m
                               where m.username=@username_Stadium_manager;
select @match_id=m.match_ID from match m
                                where m.start_time=@start_time and m.host_club_ID=@host_club_id and m.guest_club_ID=@guest_club_id;
UPDATE HostRequest
set HostRequest.status='rejected'
where HostRequest.repersentative_ID=@representitive_id and HostRequest.manager_ID=@manager_id and HostRequest.match_ID=@match_id and HostRequest.status='unhandled';
GO

create procedure addFan 
@fan_name varchar(20),
@username varchar(20),
@password varchar(20),
@fan_national_id varchar(20),
@fan_birthdate datetime,
@fan_address varchar(20),
@fan_phone int
as
if (@username not in  (select s.username from SystemUser s))
begin 
insert into SystemUser values (@username,@password)
insert into fan values (@fan_national_id,@fan_name,@fan_birthdate,@fan_address,@fan_phone,1,@username)
end
else 
begin
insert into fan values (@fan_national_id,@fan_name,@fan_birthdate,@fan_address,@fan_phone,1,@username)
end
GO

create function upcomingMatchesOfClub (@club_name varchar(20))
returns TABLE 
AS
return 
( 
	(select c1.name as host_club_name ,c2.name as guest_club_name ,m.start_time,s.name as name_of_the_stadium  
	from match m inner join Club c1 on m.host_club_ID=c1.club_ID
	inner join Club c2   on m.guest_club_ID =c2.club_ID
	inner join Stadium s on m.stadium_ID= s.ID
	where c1.name=@club_name and m.start_time>CURRENT_TIMESTAMP)
UNION
	(select c2.name,c1.name,m.start_time,s.name 
	from match m inner join Club c1 on m.guest_club_ID=c1.club_ID
	inner join Club c2 on m.host_club_ID =c2.club_ID
	inner join Stadium s on m.stadium_ID= s.ID
	where c1.name=@club_name and m.start_time>CURRENT_TIMESTAMP)
)
GO

create function availableMatchesToAttend (@input_date_time datetime)
returns TABLE AS
return select distinct c1.name as Host_club_name ,c2.name as Guest_club_name ,m.start_time,s.name as Stadium_name
												  from match m  inner join Club c1 on m.host_club_ID=c1.club_ID
                                                                inner join Club c2 on m.guest_club_ID=c2.club_ID
                                                                inner join Stadium s on m.stadium_ID=s.ID
                                                                inner join Ticket t on m.match_ID=t.match_ID
												  where m.start_time>@input_date_time and t.status=1
GO

create procedure purchaseTicket
@fan_national_id varchar(20),
@hosting_clubname varchar(20),
@guest_clubname varchar(20),
@the_starttime datetime
as 
declare @ticket_id int 
 
select @ticket_id=t.ID from Ticket t inner join Match m on t.match_ID=m.match_ID
                       inner join Club c1 on m.host_club_ID=c1.club_ID
                       inner join club c2 on m.guest_club_ID=c2.club_ID
                where m.start_time=@the_starttime and c1.name=@hosting_clubname and c2.name =@guest_clubname and t.status=1
insert into TicketBuyingTransaction values (@fan_national_id,@ticket_id)
update Ticket
set Ticket.status='0'
where ticket.ID=@ticket_id
GO

create procedure updateMatchTiming
@hosting_clubname varchar(20),
@guest_clubname varchar(20),
@theCurrent_starttime datetime,
@thenew_starttime datetime,
@thenew_endtime datetime
as
declare @match_id int
select @match_id=m.match_ID  from match m  inner join Club c1 on m.host_club_ID=c1.club_ID
                       inner join club c2 on m.guest_club_ID=c2.club_ID
                       where c1.name =@hosting_clubname and c2.name = @guest_clubname and m.start_time=@theCurrent_starttime
Update Match
      set Match.start_time=@thenew_starttime , Match.end_time=@thenew_endtime
      where Match.match_ID=@match_id
GO

create view matchesPerTeam
as
select c.name as Club_Name, count(m.match_ID) as Matches_Participated_in
from Match m, Club c
where (c.club_ID=m.guest_club_ID or c.club_ID=m.host_club_ID)
group by c.name
order by count(m.match_ID) desc offset 0 rows
GO

create procedure deleteMatchesOn
@date datetime 
as
delete from Match where Match.start_time=@date
GO

create view matchWithMostSoldTickets
as
select top 1 c1.name as Host_Club_Name, c2.name as Guest_Club_Name
from Match m, Club c1, Club c2, Ticket t
where t.status=0 and m.host_club_ID=c1.club_ID and m.guest_club_ID=c2.club_ID and m.match_ID=t.match_ID
group by c1.name, c2.name
order by count(t.status) desc 
GO

create view matchesRankedBySoldTickets
as
select c1.name as Host_Club_Name, c2.name as Guest_Club_Name, count(t.status)  as Tickets_sold_from_this_Match
from Match m, Club c1, Club c2, Ticket t
where t.status=0 and m.host_club_ID=c1.club_ID and m.guest_club_ID=c2.club_ID and m.match_ID=t.match_ID
group by c1.name, c2.name
order by count(t.status) desc offset 0 rows
GO

create procedure clubWithTheMostSoldTickets
@cname varchar(20) output
as
select  top 1 @cname=c.name
from Match m, Club c, Ticket t
where m.match_ID=t.match_ID and t.status=0 and (c.club_ID=m.host_club_ID or c.club_ID=m.guest_club_ID)
group by c.name
order by count(t.status) desc
GO


create view clubsRankedBySoldTickets
as
select c.name as Club_Name, count(t.status) as Tickets_sold_by_this_Club
from Match m, Club c, Ticket t
where m.match_ID=t.match_ID and t.status=0 and (c.club_ID=m.host_club_ID or c.club_ID=m.guest_club_ID)
group by c.name
order by count(t.status) desc offset 0 rows
GO

create function stadiumsNeverPlayedOn
(@cname varchar(20))
returns table
as
return
(
select name,capacity from Stadium
EXCEPT
	(
	select distinct s.name,s.capacity from Stadium s, Club c, Match m
	where c.name=@cname and s.ID=m.stadium_ID and c.club_ID=m.host_club_ID
	UNION 
	select distinct s.name,s.capacity from Stadium s, Club c, Match m
	where c.name=@cname and s.ID=m.stadium_ID and c.club_ID=m.guest_club_ID
	)
)

use model3

go
drop table if exists ActorsList
drop table if exists Productions
drop table if exists Movies 
drop table if exists Directors
drop table if exists Company
drop table if exists Actors

create table Company (
	cid int primary key identity(1,1),
	cname varchar(100)
);

create table Directors(
	did int primary key identity(1,1),
	dname varchar(100),
	awards int, 
);

create table Movies (
	mid int primary key identity(1,1),
	mname varchar(100),
	rdate date,
	cid int foreign key references Company(cid),
	did int foreign key references Directors(did)
);



create table Actors(
	aid int primary key identity(1,1),
	aname varchar(100),
	ranking int
);

create table Productions(
	pid int primary key identity(1,1),
	title varchar(100), 
	mid int foreign key references Movies(mid)
);

create table ActorsList(
	id int primary key identity(1,1),
	aid int foreign key references Actors(aid),
	pid int foreign key references Productions(pid),
	entrymom int
);

insert into Directors values ('scorsese',12)
insert into Directors values ('tarkovsky',5)

insert into Company values ('miramax'),('universal')

insert into Movies values ('raging bull','1980-05-10',2,1)
insert into Movies values ('solaris','1972-05-12',1,2)

insert into Actors values ('deniro',1)
insert into Actors values ('pacino',2)
insert into Actors values ('adam sandler',1231)

insert into Productions values ('abc',1),('def',2)

insert into ActorsList values (1,1,1)
insert into ActorsList values (2,1,10)
insert into ActorsList values (3,2,123)

select * from ActorsList
go
create or alter proc uspAddActorToProd(@actor int, @entrymom int, @prod int) 
as 
	insert into ActorsList values (@actor, @prod, @entrymom)

go
exec uspAddActorToProd 2,3,1;

select * from ActorsList

go
create or alter view actorsInAllProds as 
	select a.aname, a.ranking
	from Actors a
	where a.aid in 
		(select al.aid
		from ActorsList al inner join 
		Actors a on al.aid=a.aid 
		group by al.aid)

go
select * from actorsInAllProds


go
create or alter function ufReleaseDateAfter (@p int)
returns table
as 
	return 
	select m.mname
	from Movies m 
	where m.mid in (
		Select CP.mid
       From Productions CP Inner join Movies M ON (Cp.mid=M.mid)
	   where M.rdate>'1972-12-01' 
	   Group By Cp.mid
	   HAving Count(*)>=@p
	  )
	

go 
select * from ufReleaseDateAfter(1)
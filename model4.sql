--create database model4

use model4

go
drop table if exists OrdersStorage
drop table if exists Specializations
drop table if exists Orders
drop table if exists Cakes 
drop table if exists CakeTypes
drop table if exists Chefs

go
create table CakeTypes(
	ctid int primary key identity (1,1),
	ctname varchar(30),
	ctdesc varchar(100)
);

create table Cakes(
	cid int primary key identity (1,1),
	cname varchar (30),
	shape varchar (30),
	weight int,
	price int, 
	ctype int foreign key references CakeTypes(ctid)
);

create table Chefs(
	chid int primary key identity (1,1),
	chname varchar (30), 
	gender varchar(1),
	dob varchar(15)
);

create table Specializations(
	chefid int references Chefs(chid),
	cakeid int references Cakes(cid),
	primary key (chefid, cakeid) 
);

create table Orders(
	oid int primary key identity(1,1),
	date varchar(15)
);

create table OrdersStorage(
	oid int references Orders(oid),
	cakeid int references Cakes(cid), 
	howmany int
);

go	
insert into CakeTypes values ('t1','desc1'), ('t2','desc2'), ('t3','desc3')
insert into Cakes values ('cake1','round',10,100,1),('cake2','square',10,100,2),('cake3','oval',25,300,2)
insert into Chefs values ('alex','m','1999-08-18'),('rzv','f','1999-08-18'),('aaa','m','1999-08-18')
insert into Orders values ('2018-03-02'),('2019-12-22')
insert into Specializations values (1,1),(1,2),(2,2),(2,3),(1,3)
insert into OrdersStorage values (1,2,3),(1,3,5),(2,1,2)

select * from OrdersStorage

go
create or alter proc uspInsertOrder (@oid int, @cname varchar(30), @p int)
as
	--get cake id with the name @cname
	declare @cakeid int 
	set @cakeid = (select c.cid from Cakes c where c.cname=@cname)
	declare @orderid int
	set @orderid = (select o.oid from Orders o where o.oid=@oid)
	if @cakeid is null or @orderid is null
	begin
		print 'cake/order doesnt exist'
		return
	end
	if exists (select * from OrdersStorage o where o.cakeid=@cakeid and o.oid=@oid)
	begin 
		update OrdersStorage
		set OrdersStorage.howmany=@p 
		where OrdersStorage.oid=@oid and OrdersStorage.cakeid=@cakeid
	end
	else 
	begin 
		insert into OrdersStorage values (@oid, @cakeid, @p)
	end


go
exec uspInsertOrder 1,'cake2',10;
exec uspInsertOrder 1,'cake3',10;
exec uspInsertOrder 1,'sad',10;

select * from OrdersStorage

go
create or alter function ufListChefsSpecialized ()
returns table
as 
	return 
	select ch.chname
	from Chefs ch inner join 
		(select s.chefid
		 from Specializations s
		 group by s.chefid
		 having count(*)>=(select count(*) from Cakes)
		) as SpecializedChefs 
	on ch.chid = SpecializedChefs.chefid

go
select * from ufListChefsSpecialized()
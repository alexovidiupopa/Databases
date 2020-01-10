use model2 

go
drop table if exists Stock
drop table if exists Transactions
drop table if exists Shoes
drop table if exists ShoeModels 
drop table if exists Shops
drop table if exists Women


create table Shops(
	sid int primary key identity (1,1),
	sname varchar(100),
	city varchar(100)
);

create table Women(
	wid int primary key identity (1,1),
	wname varchar(100),
	maxspend int
);

create table ShoeModels(
	smid int primary key identity (1,1),
	smname varchar(100),
	season varchar(10),
	
);

create table Shoes(
	shid int primary key identity (1,1),
	price int,
	smid int foreign key references ShoeModels(smid)
);

create table Transactions(
	tid int primary key identity (1,1),
	wid int foreign key references Women(wid),
	shid int foreign key references Shoes(shid),
	bought int, 
	spent int,
);

create table Stock(
	stid int primary key identity(1,1),
	available int,
	shopid int foreign key references Shops(sid),
	shoeid int foreign key references Shoes(shid)
);

go

insert into ShoeModels values ('low top', 'summer')
insert into ShoeModels values ('hi top', 'winter')

insert into Shops values ('soho','nyc')
insert into Shops values ('nike','la')

insert into Women values ('alice',123)
insert into Women values ('mary',444)

insert into Shoes values (50, 1)
insert into Shoes values (99, 2)

insert into Transactions values (1,1,1,1)
insert into Transactions values (1,2,30,200)
insert into Transactions values (2,2,22,150)

insert into Stock values (10, 2, 2)
insert into Stock values (99, 1, 2)

go
select * from Transactions

go
create or alter proc uspAddShoeToShop (@shoeid INT, @shopid INT, @nrShoes INT) 
AS 
	insert into Stock values (@nrShoes, @shopid, @shoeid)

go 
select * from Stock

go
exec uspAddShoeToShop 1,1,10;

go 
select * from Stock

go
create or alter view womenWithAtLeastTwoShoes
as 
	select w.wname
	from Women w
	where w.wid in
		(select t.wid
		from Transactions t inner join 
		Shoes s on s.shid=t.shid
		where s.smid = 2
		group by t.wid
		having sum(t.bought)>=2)

go
select * from womenWithAtLeastTwoShoes

go
create or alter function ufListShoesTShops (@t int) 
returns table 
as 
	return 
	select s.shid, s.price
	from Shoes s 
	where s.shid in (
		select st.shoeid
		from Stock st
		group by st.shoeid
		having count(*)>=@t
		)

go
select * from ufListShoesTShops(2)
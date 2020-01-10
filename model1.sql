use model1

GO
--1)
drop table if exists transactions
drop table if exists cards 
drop table if exists accounts 
drop table if exists atms
drop table if exists customers 

create table customers(
	cid int primary key identity (1,1),
	cname varchar(100),
	dob varchar(10)
);


create table atms(
	atid int primary key identity (1,1),
	addr varchar(100)
);

create table accounts(
	aid int primary key identity (1,1),
	iban varchar (20), 
	balance int,
	holder INT FOREIGN KEY REFERENCES customers(cid)
);  

create table cards(
	cid int primary key identity (1,1),
	number varchar(20) ,
	cvv int, 
	account int foreign key references accounts(aid)
);

create table transactions(
	tid int primary key identity(1,1),
	trans_time datetime,
	money int, 
	
	atm int foreign key references atms(atid),
	card int foreign key references cards(cid)
);

GO


insert into customers values ('alex', '10-8-2010')
insert into customers values ('alin', '10-8-2010')
insert into atms values ('al vaida voievod')
insert into atms values ('al vaida voievod2')
insert into accounts values ('123',100,1)
insert into accounts values ('456',999,2)
insert into cards values ('12313',313, 2)
insert into cards values ('5444' ,2132,1)
insert into transactions values ('01/01/98 23:59:59.999', 4000,1, 1)
insert into transactions values ('01/01/98 23:59:59.999', 10,1, 1)
insert into transactions values ('08/02/90 23:59:59.999', 1999, 2, 2)

GO

select * from transactions
go

--2)
CREATE OR ALTER PROC uspDeleteCardTransactions @cid INT 
AS
	DELETE FROM transactions 
	WHERE card=@cid
GO

exec uspDeleteCardTransactions 3;

select * from transactions
go


--3)
go

select c.number
from cards c
where c.cid in
	(select t.card
	from transactions t inner join atms a on t.atm=a.atid)

--4)
go
create or alter function listCards (@sum int) RETURNS TABLE 
as 
return 
	(
		select c.number, c.cvv
		from transactions t
		inner join cards c on t.card=c.cid
		group by c.number, c.cvv
		having sum(t.money)>@sum
	);

go

select * from listCards(5000)
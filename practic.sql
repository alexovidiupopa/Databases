use practic

go
drop table if exists PrescriptionsLog
drop table if exists Stock
drop table if exists Medicine
drop table if exists Pharmacy
drop table if exists Prescription
drop table if exists Office


go
create table Medicine(
	id int primary key identity (1,1),
	medname varchar(30),
	expdate date
);

insert into Medicine values ('m1','2018-02-02'),('m2','2018-02-02'),('m3','2001-02-02')

create table Pharmacy(
	id int primary key identity (1,1),
	pname varchar(30),
	paddr varchar(30)
);

insert into Pharmacy values ('p1','addr1'),('p2','addr2'),('p3','addr3')

create table Stock(
	lastbuy time,
	mid int references Medicine(id),
	pid int references Pharmacy(id),
	primary key (mid,pid)
);

insert into Stock values ('12:15:59.9999', 1,1), ('12:15:59.9999', 1,2), ('12:15:59.9999',1,3), ('12:15:59.9999',3,3)

create table Office(
	id int primary key identity (1,1),
	oname varchar(30) unique, 
	oaddr varchar(30)
);

insert into Office values ('o1','oaddr1'),('o2','oaddr2')

create table Prescription(
	refno int primary key,
	issuedby int foreign key references Office(id),
);

insert into Prescription values (1, 1), (2, 1), (3,2)

create table PrescriptionsLog(
	ref int references Prescription(refno),
	med int references Medicine(id),
	primary key (ref,med)
);

insert into PrescriptionsLog values (1,1),(1,3),(2,3),(3,3)

go
select * from Stock
select * from PrescriptionsLog

go
create or alter proc uspDeletePrescriptions (@offname varchar(30)) 
as
	declare @offid int 
	set @offid = (select id from Office where oname=@offname)
	if @offid is null
	begin
		print 'No office with such name' 
		return 
	end
	delete from PrescriptionsLog
	where ref in (
				select p.refno
				from Prescription p
				where p.issuedby=@offid
				)

go
exec uspDeletePrescriptions ' ';
exec uspDeletePrescriptions 'o1';

select * from PrescriptionsLog

go
create or alter view vShowMedicines 
as
	select m.medname
	from Medicine m
	where not exists (
		select p.id
		from Pharmacy p
		except 
		select s.pid
		from Stock s
		where s.mid=m.id)

go
select * from vShowMedicines

go
create or alter function ufReturnNames (@d date, @p int)
returns table
as
	return 
	select m.medname 
	from Medicine m
	where m.expdate>@d and m.id in
		(
		select s.mid
		from Stock s
		group by s.mid
		having count(*)>=@p) 


go
select * from ufReturnNames('2000-01-01',2)
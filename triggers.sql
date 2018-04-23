create table ActorsAudit(
AuditId int primary key auto_increment,
CreatedDate Timestamp not null default current_timestamp(),
ActorsId int not null,
constraint FK_AuditActorId foreign key (ActorsId) references actors(ActorsId)
);

-- delimiter $;

-- blad byl poniewaz bylo before a musi byc after 
create trigger TR_BEFORE_ACTOR after insert on actors for each row 
insert into ActorsAudit(CreatedDate,ActorsId) value (current_timestamp,NEW.ActorsId);

drop trigger TR_BEFORE_ACTOR;
drop table actorsaudit;

SET FOREIGN_KEY_CHECKS=0;
insert into  actors(FirstName,LastName,BirthDate,DIC_CountryCountryId) values ('Brat','Breat','1997-10-10',2);
SET FOREIGN_KEY_CHECKS=1;

select * from actorsaudit;
select * from actors;

create table CountryDictAudit(
AuditId int primary key auto_increment,
CreateDate timestamp Not null default current_timestamp(),
DictID int not null,
old_value varchar(255) not null,
new_value varchar(255) not null,
constraint FK_CountryDict foreign key(DictId) references dic_country(CountryId)
);

create trigger TR_COUNTRY_UPDATE after update on dic_country for each row
insert into CountryDictAudit(DictId,old_value,new_value) values (OLD.CountryId,OLD.CountryName,NEW.CountryName);

update dic_country set CountryName = 'U S A' where CountryId=3;

select * from countrydictaudit;

# also makes a comment and ctrl + numpad /
-- advanced triger
delimiter $
create trigger MOVIE_TIME_CHECK before insert on movie for each row 
BEGIN
	IF NEW.ProductionYear <1900 then
		set NEW.ProductionYear =1900;
	end if;
END$
delimiter ;

insert into movie(DIC_CountryCountryId,Title,ProductionYear,PremiereDate,Length) values
(2,'Test',1500,'1900-12-12',150);

select * from movie;
delimiter $

# trigger on insert 
create trigger ACTORS_AGE_CHECK2 before insert on actors for each row
BEGIN
	if New.BirthDate <'1990-01-01' then 
		signal sqlstate'16640' set message_text ='12345:failed';
	end if;
END$
# trigger on  update
create trigger ACTORS_AGE_CHECK3 before update on actors for each row
BEGIN
	if New.BirthDate < '1990-01-01' then 
		signal sqlstate'12345' set message_text ='failed';
	end if;
END$

delimiter ;

drop trigger if exists ACTORS_AGE_CHECK2;
drop trigger if exists ACTORS_AGE_CHECK3;

# z tym triggerem wyskakuje blad  12345:failed jezeli chcemy wstawic date wczesniejsza niz podana w trigerze 
insert into actors(
actors.FirstName,actors.LastName,actors.BirthDate,actors.DIC_CountryCountryId
) values (
'abel','abbc','1890-04-19',1 
) ;
insert into actors(
actors.FirstName,actors.LastName,actors.BirthDate,actors.DIC_CountryCountryId
) values (
'abel','abbc','2000-04-19',1 
) ;
# z tym triggerem wyskakuje blad   jak chcemy uaktualnic date urodzenia wczesniejsza niz 1 stycznia 1900
update actors set BirthDate = '2000-02-09' where ActorsId=5; -- dziala 
update actors set BirthDate = '1880-02-09' where ActorsId=5; -- wyswietla failed 

select * from actors;


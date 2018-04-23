create table reviewers (
ReviewerId int primary key auto_increment,
Username varchar(50) not null
);

create table reviews (
ReviewId int primary key auto_increment,
MovieId int not null,
ReviewerId int not null,
Rating double not null,
Content varchar(1000) 
);

alter table reviews
	add	constraint
    FK_MOVIE_REVIEW foreign key (MovieId) references movie(MovieId);
    
alter table reviews
	add	constraint
    FK_REVIEWER_REVIEW foreign key (ReviewerID) references reviewers(ReviewerId);

insert into reviewers (
Username
) values ( 'JonDoe'), ( 'JaneDoe'),('Binary'),('RowsAffected');
insert into reviews (
MovieId, ReviewerID, Rating, Content
) values (1,1,4.5,'Bla bla bla'), (3,1,4.5,'Bla bla bla'),(2,1,4,'Bla bla bla'),(4,1,1,'Bla bla bla');
insert into reviews (
MovieId, ReviewerID, Rating, Content
) values (1,2,4.5,'Bla bla'
), (3,2,4.5,'Bla bla '
),(2,3,3,'Bla bla'
),(4,2,1,'Bla bl'
);
select * from reviews;

#procedura 
delimiter $
drop procedure if exists PROC_AddReview$
create procedure PROC_AddReview(
# parametry moga byc in, out lub in/out
 in movieid int,
 in reviewerid int,
 in rating double,
 in content varchar(1000),
 out avgRating double,
 out reviewid int 
 ) 
 begin 
 insert into reviews (MovieId, ReviewerId, Rating, Content) values ( movieid,reviewerid,rating,content);
 
 #średnia 
 select avg(r.Rating) into avgRating from reviews r where MovieId = movieid;
 #ostatni id
 set reviewid = last_insert_id();
 end$

delimiter ;

select * from reviews;
#wywołanie procedury
call PROC_AddReview(1,2,5,'Super film');

select * from reviews;
call PROC_AddReview(1,3,4,'Dobry film',@rating);
select @rating;
call PROC_AddReview(1,3,4,'Dobry film',@rating,@reviewid);
select @rating as Rating, @reviewid as LastId;


drop procedure if exists PROC_AddMovieWith3Actors;
delimiter $
# kolejna procedura ktora wstawia film z 3 aktorami ktora wstawia aktorów odrazu do tabeli łączącej actor_movie
create procedure PROC_AddMovieWith3Actors(
#8 parametrów
in title varchar(250),
in productionYear int(10),
in premiereDate date,
in country varchar(200),
in length int(10),
in actor1 int,
in actor2 int,
in actor3 int
) begin
start transaction; -- to jest tylko dla "ozdoby poniewaz procedura dziala  
# sprawdzamy czy dany kraj jest juz dodany do naszego slownika dic_country jezeli jest to
# bierzemy jego id jezeli nie to wstawiamy go do slownika 
set @countryId=0;
if exists (select CountryId from dic_country where CountryName = country)
then
	select CountryId into @countryId from dic_country where CountryName = country;
else 
	insert into dic_country (CountryName) values (country);
    set @countryId=last_insert_id();
end if;

--  ta czesc jest potrzebna jezeli nie mamy auto incrementa na primary key 
-- set @maxMovieId =0l
-- select max(MovieId) into @maxMovieId from Movie;
-- set @maxMovieId= @maxMovieId +1 ;

insert into movie( Title,ProductionYear,PremiereDate,Length, DIC_CountryCountryId) values (title, productionYear,premiereDate,length,@countryId);
insert into actor_movie (MovieMovieId,ActorsActorId) values (last_insert_id(),actor1),(last_insert_id(),actor2),(last_insert_id(),actor3);

commit;-- to jest tylko dla "ozdoby poniewaz procedura dziala  
end$
delimiter ;

call PROC_AddMovieWith3Actors('Procedura',1990,'1992-12-12','Italia',122,1,2,3);
select * from movie;
select * from actor_movie;
# przykładowe połączenie selcta z insertem 
# w tabele SomeTable wkladamey wyniki MovieId tych filmów które maja CountryId=1
-- insert into SomeTable(MovieId) select MovieId from Movie where CountryId =1;


-- przeklasztalcanie selectów z createDatabaseSdaFilmweb na procedury 
-- 
-- film wyprodukowany przed rokiem x i wydane na y('BlueRay'),('VHS'),('DVD'),('Streaming  Platforms')
drop procedure if exists PROC_ReturnMoviesReleasedBeforeXAndOnY;
delimiter $
create procedure PROC_ReturnMoviesReleasedAfterXAndOnY(
	in x int(10),
    in y varchar(250)
) begin 
select distinct Title,ProductionYear from movie,dic_form_movie dlm
	join dic_form df on df.FormId =dlm.DIC_FormFormId
	where ProductionYear < 2010 and FormName = 'BlueRay'; 
end$
delimiter ;

call PROC_ReturnMoviesReleasedAfterXAndOnY(2000,'DVD');


-- recenzje napisane przez recenzenta <id>
drop procedure if exists PROC_ReturnReviewsByIdOfReviewer;
delimiter $
create procedure PROC_ReturnReviewsByIdOfReviewer(
	in _reviewId int(10)
) begin
select * from  reviews r where r.ReviewerId = _reviewId;
end$
delimiter ;

call PROC_ReturnReviewsByIdOfReviewer (1);


-- procedura ktora wsawia aktorów
drop procedure if exists PROC_InsertActor;
delimiter $
create procedure PROC_InsertActor(
	in FirstName varchar(250),
    in LastName varchar(250),
    in BirthDate date,
    in country varchar(200)
)begin
set @countryId=0;
if exists (select CountryId from dic_country where CountryName = country) then
		select CountryId into @countryId from dic_country where CountryName = country;
	else 
		insert into dic_country (CountryName) values (country);
		set @countryId=last_insert_id();
 end if;
 insert actors (actors.FirstName,actors.LastName,actors.BirthDate,actors.DIC_CountryCountryId) values (
 FirstName,LastName,BirthDate,@countryId); 
end$
delimiter ;

-- procedura ktora wypisuje film i srednia ocene recenzentow
drop procedure if exists PROC_ReturnMovieWithRating;
delimiter $
create procedure PROC_ReturnMovieWithRating(
	in movieTitle varchar(250)
)begin
	select  m.Title as Movie , avg(rws.Rating)as Rating from movie m 
    join reviews rws on  rws.MovieId =m.MovieId 
    where m.Title=movieTitle;
end$
delimiter ;

select * from movie;
call PROC_ReturnMovieWithRating ('Test');
call PROC_ReturnMovieWithRating ('Procedura'); # nie ma jeszcze żadnej recenzji
call PROC_ReturnMovieWithRating ('Main Event');

-- procedura ktora pokazuje filmy z ocena wieksza od
drop procedure if exists PROC_ReturnMovieWithRatingsHigherThan;
delimiter $
create procedure PROC_ReturnMovieWithRatingsHigherThan(
	in reqRating double
)begin 
select m.Title, avg(r.Rating) as rating
from Movie m
join Reviews r on r.MovieId=m.MovieId
group by m.MovieId having rating>reqRating;
end$

delimiter ;
call PROC_ReturnMovieWithRatingsHigherThan(2.0);
call PROC_ReturnMovieWithRatingsHigherThan(3.5);

-- filmy z ocena wieksza niz 2 i napisana przez recenzenta o id 2 
select distinct m.Title from Movie m join Reviews r on r.MovieId =m.MovieId where r.ReviewerId=3 and r.rating>2;



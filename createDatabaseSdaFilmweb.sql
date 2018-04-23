create database SdaFilmweb
	default character set 'utf8'
    default collate 'utf8_polish_ci';
    
create table DIC_Country(
	CountryId int primary key auto_increment,
    CountryName varchar(250) not null
);

create table DIC_Genre(
	GenreId int primary key auto_increment,
    GenreName varchar(250) not null
);

create table DIC_Studio(
	StudioId int primary key auto_increment,
    StudioName varchar(250) not null
);

create table DIC_Language(
	LanguageId int primary key auto_increment,
    LanguageName varchar(250) not null
);

create table DIC_Form(
	FormId int primary key auto_increment,
    FormName varchar(250) not null
);

create table Actors(
	ActorsId int primary key auto_increment,
    FirstName varchar(250) not null,
    LastName varchar(250) not null,
    BirthDate date not null,
    DIC_CountryCountryId int(10) not null,
    constraint foreign key (DIC_CountryCountryId)
    references dic_country(CountryId)
);

create table Directors(
	DirectorId int primary key auto_increment,
    FirstName varchar(250) not null,
    LastName varchar(250) not null,
    DIC_CountryCountryId int(10) not null,
    constraint foreign key (DIC_CountryCountryId)
    references dic_country(CountryId)
    
);

create table Movie(
	MovieId int primary key auto_increment,
    Title varchar(250) not null,
    ProductionYear int(10) not null,
    PremiereDate date,
    Length int(10) not null,
    DIC_CountryCountryId int(10) not null,
    constraint foreign key (DIC_CountryCountryId)
    references dic_country(CountryId)
);

create table Actor_Movie(
	ActorsActorId int(10) not null,
    constraint FK_Actors foreign key (ActorsActorId)
    references actors(ActorsId),
    MovieMovieId int(10) not null,
    constraint FK_Movie foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Actors_Movie primary key (ActorsActorId,MovieMovieId)
);

create table Directors_Movie(
	DirectorsDirectorId int(10) not null,
    constraint FK_Directors foreign key (DirectorsDirectorId)
    references directors(DirectorId),
    MovieMovieId int(10) not null,
    constraint FK_Movie2 foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Directors_Movies primary key (DirectorsDirectorId,MovieMovieId)
);

create table DIC_Genre_Movie(
	DIC_GenreGenreId int(10) not null,
    constraint FK_Genre foreign key (DIC_GenreGenreId)
    references dic_genre(GenreId),
    MovieMovieId int(10) not null,
    constraint FK_Movie3 foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Genre_Movies primary key (DIC_GenreGenreId,MovieMovieId)
);

create table DIC_Studio_Movie(
	DIC_StudioStudioId int(10) not null,
    constraint FK_Studio foreign key (DIC_StudioStudioId)
    references dic_studio(StudioId),
    MovieMovieId int(10) not null,
    constraint FK_Movie4 foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Studio_Movies primary key (DIC_StudioStudioId,MovieMovieId)
);

create table DIC_Form_Movie(
	DIC_FormFormId int(10) not null,
    constraint FK_Form foreign key (DIC_FormFormId)
    references dic_form(FormId),
    MovieMovieId int(10) not null,
    constraint FK_Movie5 foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Form_Movies primary key (DIC_FormFormId,MovieMovieId)
);

create table DIC_Language_Movie(
	DIC_LanguageLanguageId int(10) not null,
    constraint FK_Language foreign key (DIC_LanguageLanguageId)
    references dic_language(LanguageId),
    MovieMovieId int(10) not null,
    constraint FK_Movie6 foreign key (MovieMovieId)
    references movie(MovieId),
    constraint PK_Language_Movies primary key (DIC_LanguageLanguageId,MovieMovieId)
);

insert into dic_country (CountryName) values ('Turkey'),('Poland'),('USA'),('France');
insert into dic_genre (GenreName) values ('Drama'),('Comedy'),('Western'),('Action');
insert into dic_studio (StudioName) values ('Walt Disney Pictures'),('Warner Bros. Pictures'),('Universal Pictures'),('20th Century Fox');
insert into dic_language (LanguageName) values ('en'),('pl'),('de'),('es');
insert into dic_form (FormName) values ('BlueRay'),('VHS'),('DVD'),('Streaming  Platforms');
insert into actors (
    FirstName,    LastName,    BirthDate,    DIC_CountryCountryId
) values ('Marc',    'Darcy',    '1975-02-15',    1),(
'Marc',    'Dark',    '1999-03-15',    4),(
'Amelie',    'Archybard',    '1965-08-15',    3),(
'Cece',    'Quebeq',    '1970-02-16',    3);

select FirstName,LastName,BirthDate,CountryName from actors a join dic_country dc on a.DIC_CountryCountryId=dc.CountryId order by BirthDate;

insert into directors (
 FirstName,    LastName,    DIC_CountryCountryId
) values (
'Martha', 'Steward', 3
),(
'Ben', 'Ward', 3
),(
'Marek', 'Stew', 2
);

insert into movie (
    Title ,    ProductionYear ,    PremiereDate ,    Length ,    DIC_CountryCountryId
) values ('Main Event',2001,'2003-04-20',126,1),(
'Last Prayer',2012,'2013-04-20',156,2
),(
'Misfits',1965,'1966-08-13',95,3
);

insert into actor_movie (ActorsActorId,MovieMovieId
) values (
1,1
),(
1,2
),(
2,1
),(
2,3
);
select * from movie;
insert into actor_movie (ActorsActorId,MovieMovieId
) values (
3,1
),(
3,2
),(
4,1
),(
4,3
);

(select 	FirstName,
		LastName,
        Title 
	from actor_movie am 
		right join actors a on am.ActorsActorId=a.ActorsId 
        right join movie m on am.ActorsActorId=m.MovieId);
        
insert into dic_genre_movie (DIC_GenreGenreId,MovieMovieId
) values (1,2
),( 1,3
),( 2,1
),( 3,1
),( 4,2
);

insert into directors_movie (DirectorsDirectorId,MovieMovieId
) values (1,2
),( 1,3
),( 2,1
),( 3,1
);

insert into dic_studio_movie (DIC_StudioStudioId,MovieMovieId
) values (1,2
),( 1,3
),( 2,1
),( 3,1
),( 4,2
);

insert into dic_form_movie (DIC_FormFormId,MovieMovieId
) values (1,2
),( 1,3
),( 2,1
),( 3,1
),( 4,2
);

insert into dic_language_movie (DIC_LanguageLanguageId,MovieMovieId
) values (1,2
),( 1,3
),( 2,1
),( 3,1
),( 4,2
);

(select LanguageName,Title from dic_language_movie dlm
	join dic_language  dl on dl.LanguageId=dlm.DIC_LanguageLanguageId 
    join movie m on m.MovieId=dlm.MovieMovieId);
-- film wyprodukowany przed rokiem 2010 i wydane na blueray
(select distinct Title,ProductionYear from movie,dic_form_movie dlm
	join dic_form df on df.FormId =dlm.DIC_FormFormId
	where ProductionYear < 2010 and FormName = 'BlueRay'); 
-- aktorzy w filmie o id nr 3 
(select distinct m.Title,FirstName,LastName from actor_movie am
	join actors a on a.ActorsId = am.ActorsActorId
    join movie m on m.MovieId = am.MovieMovieId
    where m.MovieId = 3) ; 
-- reżyster filmu z like
(select distinct m.Title,FirstName,LastName from directors_movie dm
	join directors d on d.DirectorId = dm.DirectorsDirectorId 
    join movie m on dm.MovieMovieId = m.MovieId
    where m.Title like '% %'); 
-- filmy w ktorych gral aktor <id>
(select distinct * from actor_movie am
	join movie m on m.MovieId = am.MovieMovieId
	join actors a on a.ActorsId = am.ActorsActorId
    where am.ActorsActorId = 1); 
-- najstarszy aktor
select * from actors order by BirthDate limit 1;
select LastName,FirstName,BirthDate from actors order by BirthDate limit 1;
-- reżyser który nakrecił najwiecej filmów
(SELECT d.FirstName,d.LastName, count(*) as numberOfMovies FROM directors_movie dm
	join movie m on m.MovieId=dm.MovieMovieId
    join directors d on d.DirectorId= dm.DirectorsDirectorId
    group by d.FirstName,d.LastName
    order by numberOfMovies desc
    -- limit 1)
   ) ;
-- aktorzy ktorzy grali w filmie typu <id> ja zrobilem w formacie 
(select m.Title,df.FormName from actor_movie am
	join actors a on a.ActorsId=am.ActorsActorId
    join movie m on m.MovieId=am.MovieMovieId
	join dic_form_movie dfm on dfm.MovieMovieId = m.MovieId
    join dic_form df on df.FormId=dfm.DIC_FormFormId
    where df.FormId = 1
    );
-- gatunki fimow w jezyku <id>
 (select * from dic_genre_movie dgm
	join dic_genre dg on dg.GenreId=dgm.DIC_GenreGenreId
    join movie m on m.MovieId=dgm.MovieMovieId
    join dic_language_movie dlm on m.MovieId =dlm.MovieMovieId
    join dic_language dl on dl.LanguageId=dlm.DIC_LanguageLanguageId
    where dl.LanguageName = 'pl'
    );
-- aktorzy starsi od 25 lat i ich filmy
(select distinct m.Title,a.LastName,a.FirstName from actor_movie am
	join movie m on m.MovieId=am.MovieMovieId
    join actors a on a.ActorsId=am.ActorsActorId
    where date_add(now(), interval -25 year) < a.BirthDate);
-- wszystkie wytwornie dl akazdej jej filmy 
(select distinct ds.StudioName, m.Title from dic_studio_movie dsm
	join movie m on m.MovieId = dsm.MovieMovieId
    join dic_studio ds on ds.StudioId = dsm.DIC_StudioStudioId
);
-- gatunik filmow w jezyku 
(select distinct dl.LanguageName, dg.GenreName, m.Title from dic_genre_movie dgm 
	join dic_genre dg on dg.GenreId=dgm.DIC_GenreGenreId
    join movie m on m.MovieId=dgm.MovieMovieId
    join dic_language_movie dlm on m.MovieId=dlm.MovieMovieId
    join dic_language dl on dlm.DIC_LanguageLanguageId= dl.LanguageId
    where dl.LanguageName = 'es'
);
-- wszystki kraje i urodzeni w nich aktorzy
( select distinct dc.CountryName,a.LastName,a.FirstName from actor_movie am
	join  actors a on  a.ActorsId=am.ActorsActorId
    join movie m on m.MovieId=am.MovieMovieId
    join dic_country dc on dc.CountryId = m.DIC_CountryCountryId
);    
-- średnia liczba aktorów w filamch reżysera <id>
-- ctrl + b modyfikuje na ladniejszy kod
SELECT 
    AVG(PrimarySelect.AvgCount)
FROM
    (SELECT 
        am.MovieMovieId AS MovieId,
            COUNT(am.ActorsActorId) AS AvgCount
    FROM
        movie m
    JOIN directors_movie dm ON m.MovieId = dm.MovieMovieId
    JOIN directors d ON d.DirectorId = dm.DirectorsDirectorId
    JOIN actor_movie am ON m.MovieId = am.MovieMovieId
    JOIN actors a ON a.ActorsId = am.ActorsActorId
    WHERE
        d.DirectorId = 2
    GROUP BY 1) AS PrimarySelect;

-- średnia liczba aktorów w filamch reżysera na rezysera
SELECT 
    PrimarySelect.DirectorID, AVG(PrimarySelect.AvgCount)
FROM
    (SELECT 
        d.DirectorId AS DirectorId,
            am.MovieMovieId AS MovieId,
            COUNT(am.ActorsActorId) AS AvgCount
    FROM
        movie m
    JOIN directors_movie dm ON m.MovieId = dm.MovieMovieId
    JOIN directors d ON d.DirectorId = dm.DirectorsDirectorId
    JOIN actor_movie am ON m.MovieId = am.MovieMovieId
    JOIN actors a ON a.ActorsId = am.ActorsActorId
    GROUP BY 2) AS PrimarySelect
GROUP BY 1;
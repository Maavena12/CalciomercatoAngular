/*----------------------------------------------------------------------------------------------------------------------
--------------------------------------------- PRIMERO CORRE ESTO -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------ */

CREATE TABLE IF NOT EXISTS player
(
    idPlayer serial primary key,
    firstName character varying(255) not null,
    lastName character varying(255) not null,
    position character varying(255) not null,
    birth_date date not null,
    image character varying not null,
    cost character varying(255) not null,
    createdDate timestamp with time zone NOT NULL default now(),
    modifiedDate timestamp with time zone NOT NULL default now()
);

CREATE TABLE IF NOT EXISTS team
(
    idTeam serial primary key,
    name character varying(255) not null,
    country character varying(255) not null,
    fundation character varying(255) not null,
    image character varying not null,
    createdDate timestamp with time zone NOT NULL default now(),
    modifiedDate timestamp with time zone NOT NULL default now()
);

CREATE TABLE IF NOT EXISTS contract
(
    idContract serial primary key,
    games integer not null,
    goals integer not null,
    assits integer not null,
    salary character varying(255) not null,
    beginDate date not null,
    endDate date,
    idTeam integer NOT NULL references team(idTeam) ON DELETE CASCADE,
    idPlayer integer NOT NULL references player(idPlayer) ON DELETE CASCADE,
    createdDate timestamp with time zone NOT NULL default now(),
    modifiedDate timestamp with time zone NOT NULL default now()
);


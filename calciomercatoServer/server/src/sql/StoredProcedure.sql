/*----------------------------------------------------------------------------------------------------------------------
--------------------------------------------- DESPUES TERCERO CORRE ESTO -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------ */

CREATE OR REPLACE FUNCTION sp_create_player_contract(
	p_firstName character varying,
    p_lastName character varying,
    p_position character varying,
    p_birth_date date,
    p_image character varying,
	p_cost character varying,
	p_name character varying,
    p_country character varying,
    p_fundation character varying,
    pp_image character varying,
	p_games integer,
    p_goals integer,
    p_assits integer,
	p_salary character varying,
    p_beginDate date,
    p_endDate date)
    RETURNS varchar
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_id                                    integer;
	p_id                                integer;
	v_name                              varchar;
	v_country                           varchar;
	v_fundation                         varchar;
	v_image                             varchar;
	v_firstName                         varchar;
	v_lastName                          varchar;
begin
	select firstName into v_firstName from player where firstName = p_firstName;
	select lastName into v_lastName from player where lastName = p_lastName;
	if ((v_firstName !== '') and (v_lastName !== '')) then
		return 'El jugador ya fue ingresado anteriormente.';
	else
		Insert into player(firstName, lastName, position, birth_date, image, cost) 
		VALUES (p_firstName, p_lastName, p_position, p_birth_date, p_image, p_cost) RETURNING idPlayer into p_id;
		select name into v_name from team where name = p_name;
		if (v_name is not null) then
		select country into v_country from team where name = p_name;
		select fundation into v_fundation from team where name = p_name;
		select image into v_image from team where name = p_name;
		select idTeam into v_id from team where name = p_name;
		else
		Insert into team(name, country, fundation, image) 
		VALUES (p_name, p_country, p_fundation, pp_image) RETURNING idTeam into v_id;
		end if;
		if (p_endDate is null) then
		Insert into contract(games, goals, assits, salary, beginDate, idTeam, idPlayer) 
		VALUES (p_games, p_goals, p_assits, p_salary, p_beginDate, v_id, p_id);
		return 'Inserción exitosa';
		else
		Insert into contract(games, goals, assits, salary, beginDate, endDate, idTeam, idPlayer) 
		VALUES (p_games, p_goals, p_assits, p_salary, p_beginDate, p_endDate, v_id, p_id);
		return 'Inserción exitosa';
		end if;
	end if;
end;
$BODY$;

CREATE OR REPLACE FUNCTION sp_find_all_players(
	)
    RETURNS json[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare 
	v_json_resp json[];
begin
	select array(
        select jsonb_build_object(
			'idPlayer', a.idPlayer,
			'firstName', a.firstName,
            'lastName', a.lastName,
			'position', a.position,
			'birth_date', a.birth_date,
			'image', a.image,
			'cost', a.cost,
			'createdDate', a.createdDate,
            'modifiedDate', a.modifiedDate
		)
		from player a
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

CREATE OR REPLACE FUNCTION sp_find_all_teams(
	)
    RETURNS json[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare 
	v_json_resp json[];
begin
	select array(
        select jsonb_build_object(
			'idTeam', a.idTeam,
			'name', a.name,
            'country', a.country,
			'fundation', a.fundation,
			'image', a.image,
			'createdDate', a.createdDate,
            'modifiedDate', a.modifiedDate
		)
		from team a
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

CREATE OR REPLACE FUNCTION sp_find_all_contracts(
	)
    RETURNS json[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare 
	v_json_resp json[];
begin
	select array(
        select jsonb_build_object(
			'idPlayer', p.idPlayer,
			'idTeam', t.idTeam,
			'idContract', c.idContract,
			'firstName', p.firstName,
            'lastName', p.lastName,
			'position', p.position,
			'birth_date', p.birth_date,
			'playerImage', p.image,
			'name', t.name,
            'country', t.country,
			'fundation', t.fundation,
			'teamImage', t.image,
			'games', c.games,
			'goals', c.goals,
			'assits', c.assits,
			'salary', c.salary,
			'beginDate', c.beginDate,
			'endDate', c.endDate,
			'createdDate', c.createdDate,
            'modifiedDate', c.modifiedDate
		)
		from team t, contract c, player p
		where t.idteam = c.idteam
		and p.idplayer = c.idplayer
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;



CREATE OR REPLACE FUNCTION sp_find_team_by_name(
	p_name varchar)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_name                              varchar;
	v_country                             varchar;
	v_createdDate                       TIMESTAMP;
	v_modifiedDate                      TIMESTAMP;
	v_fundation                         varchar;
	v_image                             varchar;
	v_idTeam                                    integer;
begin
	select u.name into v_name from team u where u.name = p_name;
	select u.country into v_country from team u where u.name = p_name;
	select u.createdDate into v_createdDate from team u where u.name = p_name;
	select u.modifiedDate into v_modifiedDate from team u where u.name = p_name;
	select u.fundation into v_fundation from team u where u.name = p_name;
	select u.image into v_image from team u where u.name = p_name;
	select u.idTeam into v_idTeam from team u where u.name = p_name;
	return json_build_object(
		'idTeam', v_idTeam,
		'name', v_name,
		'country', v_country,
		'fundation', v_fundation,
		'image', v_image,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate
	);
end;
$BODY$;



CREATE OR REPLACE FUNCTION sp_find_player_by_name(
	p_name varchar)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_firstName                              varchar;
	v_lastName                             varchar;
	v_createdDate                       TIMESTAMP;
	v_modifiedDate                      TIMESTAMP;
	v_position                         varchar;
	v_image                             varchar;
	v_idPlayer                                    integer;
	v_birth_date                        date;
	v_cost                             varchar;
begin
	select u.firstName into v_firstName from player u where u.firstName = p_name or u.lastName = p_name;
	select u.lastName into v_lastName from player u where u.firstName = p_name or u.lastName = p_name;
	select u.createdDate into v_createdDate from player u where u.firstName = p_name or u.lastName = p_name;
	select u.modifiedDate into v_modifiedDate from player u where u.firstName = p_name or u.lastName = p_name;
	select u.position into v_position from player u where u.firstName = p_name or u.lastName = p_name;
	select u.image into v_image from player u where u.firstName = p_name or u.lastName = p_name;
	select u.idPlayer into v_idPlayer from player u where u.firstName = p_name or u.lastName = p_name;
	select u.birth_date into v_birth_date from player u where u.firstName = p_name or u.lastName = p_name;
	select u.cost into v_cost from player u where u.firstName = p_name or u.lastName = p_name;
	return json_build_object(
		'idPlayer', v_idPlayer,
		'firstName', v_firstName,
		'lastName', v_lastName,
		'position', v_position,
		'image', v_image,
		'birth_date', v_birth_date,
		'cost', v_cost,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate
	);
end;
$BODY$;


CREATE OR REPLACE FUNCTION sp_find_player_by_contract(
	p_name varchar)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_firstName                              varchar;
	v_lastName                             varchar;
	v_createdDate                       TIMESTAMP;
	v_modifiedDate                      TIMESTAMP;
	v_position                         varchar;
	v_image                             varchar;
	v_idPlayer                                    integer;
	v_birth_date                        date;
	v_idTeam                                    integer;
	v_name                              varchar;
	v_country                             varchar;
	vv_image                             varchar;
	v_games                              integer;
	v_goals                              integer;
	v_assits                              integer;
	v_beginDate                       date;
	v_endDate                        date;
	v_cost                           varchar;
	v_salary                         varchar;
begin
	select u.firstName into v_firstName from player u where u.firstName = p_name or u.lastName = p_name;
	select u.cost into v_cost from player u where u.firstName = p_name or u.lastName = p_name;
	select u.lastName into v_lastName from player u where u.firstName = p_name or u.lastName = p_name;
	select u.createdDate into v_createdDate from player u, contract c where c.idPlayer = c.idPlayer and (u.firstName = p_name or u.lastName = p_name);
	select u.modifiedDate into v_modifiedDate from player u, contract c where c.idPlayer = c.idPlayer and (u.firstName = p_name or u.lastName = p_name);
	select u.position into v_position from player u where u.firstName = p_name or u.lastName = p_name;
	select u.image into v_image from player u where u.firstName = p_name or u.lastName = p_name;
	select u.idPlayer into v_idPlayer from player u where u.firstName = p_name or u.lastName = p_name;
	select u.birth_date into v_birth_date from player u where u.firstName = p_name or u.lastName = p_name;
	select u.idTeam into v_idTeam from team u, player p, contract c where c.idTeam = u.idTeam and c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select u.name into v_name from team u, player p, contract c where c.idTeam = u.idTeam and c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select u.country into v_country from team u, player p, contract c where c.idTeam = u.idTeam and c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select l.image into vv_image from team l, player p, contract c where c.idTeam = l.idTeam and c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.games into v_games from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.goals into v_goals from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.assits into v_assits from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.beginDate into v_beginDate from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.endDate into v_endDate from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	select c.salary into v_salary from player p, contract c where c.idPlayer = p.idPlayer and (p.firstName = p_name or p.lastName = p_name);
	return json_build_object(
		'idPlayer', v_idPlayer,
		'firstName', v_firstName,
		'lastName', v_lastName,
		'position', v_position,
		'playerImage', v_image,
		'birth_date', v_birth_date,
		'cost', v_cost,
		'idTeam', v_idTeam,
		'name', v_name,
		'country', v_country,
		'teamImage', vv_image,
		'games', v_games,
		'goals', v_goals,
		'assits', v_assits,
		'beginDate', v_beginDate,
		'endDate', v_endDate,
		'salary', v_salary,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate
	);
end;
$BODY$;

CREATE OR REPLACE FUNCTION sp_find_player_by_team(
	p_name varchar)
    RETURNS json[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_json_resp json[];
begin
	select array(
        select jsonb_build_object(
			'idPlayer', p.idPlayer,
			'firstName', p.firstName,
            'lastName', p.lastName,
			'position', p.position,
			'birth_date', p.birth_date,
			'cost', p.cost,
			'playerImage', p.image,
			'games', c.games,
			'goals', c.goals,
			'assits', c.assits,
			'salary', c.salary,
			'beginDate', c.beginDate,
			'endDate', c.endDate
		)
		from team t, contract c, player p
		where t.idteam = c.idteam
		and p.idplayer = c.idplayer
		and t.name = p_name
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;
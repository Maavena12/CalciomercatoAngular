CREATE OR REPLACE FUNCTION cahub.sp_find_info_user(
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
			'idCanvasUser', a.canvasUserId
		)
		from cahub.assigment a
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_info_assignment(
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
        select distinct jsonb_build_object(
			'idCanvas', a.canvasId
		)
		from cahub.assigment a WHERE a.canvasId is not null
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_info_course(
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
        select distinct jsonb_build_object(
			'idCanvasCourse', a.canvasCourseId
		)
		from cahub.assigment a WHERE a.canvasCourseId is not null
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_info_report1(
	p_idcourse integer,
	p_initdate character varying,
	p_enddate character varying,
	p_iduser integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_name                              varchar;
	v_quantity                             integer;
begin
	if ((p_initDate = '0') and (p_endDate = '0') and (p_idCourse = 0) and (p_idUser = 0)) THEN
	select count(*) into v_quantity from cahub.assigment;
	raise notice 'jjjjjj';
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate != '0') and (p_endDate = '0') and (p_idCourse = 0) and (p_idUser = 0) and (p_idCourse = 0)) THEN
	raise notice 'bbbbb: %', p_initdate;
	select count(*) into v_quantity from cahub.assigment where createddate BETWEEN p_initDate::TIMESTAMP and now();
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initDate = '0') and (p_idCourse = 0) and (p_idUser = 0)) then
	raise notice 'oooooo';
	select count(*) into v_quantity from cahub.assigment where createddate BETWEEN createddate and p_endDate::TIMESTAMP;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_idCourse = 0) and (p_idUser = 0)) then
	raise notice 'vvvvvv';
	select count(*) into v_quantity from cahub.assigment where createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initDate = '0') and (p_endDate = '0') and (p_idCourse = 0)) THEN
	raise notice 'zzzzzz' ;
	select count(*) into v_quantity from cahub.assigment a, cahub.user u where a.iduser = u.iduser and a.canvasUserId = p_idUser;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initDate = '0') and (p_endDate = '0') and (p_idUser = 0)) THEN
	raise notice 'aaaaaa';
	select count(*) into v_quantity from cahub.assigment a, cahub.user u where a.iduser = u.iduser and a.canvasCourseId = p_idCourse;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initDate != '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'cccccc';
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP
	and a.canvasCourseId = p_idCourse;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate = '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'cccccc';
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.canvasCourseId = p_idCourse;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate != '0') and (p_endDate = '0') and (p_idCourse = 0) and (p_idUser != 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now();
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate != '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser = 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now();
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate = '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser = 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate = '0') and (p_endDate != '0') and (p_idCourse = 0) and (p_idUser != 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate = '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP;
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	elsif ((p_initdate != '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	select count(*) into v_quantity 
	from cahub.assigment a, cahub.user u 
	where a.iduser = u.iduser and a.canvasUserId = p_idUser
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now();
	return json_build_object(
		'Name', 'Cantidad Total de Actividades',
		'Cantidad', v_quantity
	);
	end if;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_info_report2(
	p_idcourse integer,
	p_initdate character varying,
	p_enddate character varying,
	p_iduser integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_name                              varchar;
	v_quantity                             integer;
	v_json                              json;
begin
	if ((p_initDate = '0') and (p_endDate = '0') and (p_idCourse = 0) and (p_idUser = 0)) THEN
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idquiz IS NOT NULL

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idcrossword IS NOT NULL

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idmemory IS NOT NULL

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idwordsearch IS NOT NULL
) as subquery into v_json;
	raise notice 'jjjjjj';
	return v_json;
	elsif ((p_endDate = '0') and (p_idCourse = 0) and (p_idUser = 0)) THEN
	raise notice 'bbbbb';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idquiz IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idcrossword IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idmemory IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idwordsearch IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and now()
) as subquery into v_json;
	return v_json;
	elsif ((p_initDate = '0') and (p_idCourse = 0) and (p_idUser = 0)) then
	raise notice 'oooooo';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idquiz IS NOT NULL
	and createddate BETWEEN createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idcrossword IS NOT NULL
	and createddate BETWEEN createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idmemory IS NOT NULL
	and createddate BETWEEN createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idwordsearch IS NOT NULL
	and createddate BETWEEN createddate and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif ((p_idCourse = 0) and (p_idUser = 0)) then
	raise notice 'vvvvvv';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idquiz IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idcrossword IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idmemory IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment
    WHERE idwordsearch IS NOT NULL
	and createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif ((p_initDate = '0') and (p_endDate = '0') and (p_idCourse = 0)) THEN
	raise notice 'zzzzzz';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
) as subquery into v_json;
	return v_json;
	elsif ((p_initDate = '0') and (p_endDate = '0') and (p_idUser = 0)) THEN
	raise notice 'aaaaaa';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif((p_initDate = '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser = 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate = '0') and (p_idCourse = 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()
) as subquery into v_json;
	return v_json;
	elsif((p_initDate = '0') and (p_endDate != '0') and (p_idCourse = 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif((p_initDate = '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser = 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif((p_initDate = '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN a.createddate and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate = '0') and (p_idCourse != 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and now()
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate != '0') and (p_idCourse != 0) and (p_idUser = 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasCourseId = p_idCourse
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	elsif((p_initDate != '0') and (p_endDate != '0') and (p_idCourse = 0) and (p_idUser != 0)) THEN
	raise notice 'ccccc';
	SELECT json_agg(json_build_object('Name', tipo_actividad, 'Cantidad', cantidad)) as resultado
FROM (
    SELECT 'Quiz' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idquiz IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Crucigrama' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idcrossword IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Memoria' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idmemory IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP

    UNION

    SELECT 'Sopa de Letras' as tipo_actividad, COUNT(*) as cantidad
    FROM cahub.assigment a, cahub.user u
    WHERE a.idwordsearch IS NOT NULL
	and a.iduser = u.iduser 
	and a.canvasUserId = p_idUser
	and a.createddate BETWEEN p_initDate::TIMESTAMP and p_endDate::TIMESTAMP
) as subquery into v_json;
	return v_json;
	end if;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_info_assignment_by_course(
p_id_course integer
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
        select distinct jsonb_build_object(
			'idCanvas', a.canvasId
		)
		from cahub.assigment a WHERE a.canvasId is not null and a.canvascourseid = p_id_course
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;

alter table cahub.user
add column avatar varchar;

CREATE OR REPLACE FUNCTION cahub.sp_createuser(
	p_username character varying,
	p_email character varying,
	p_password text,
	p_firstname character varying,
	p_lastname character varying,
	p_role character varying,
	p_consumer_key character varying,
	p_shared_secret character varying,
	p_avatar varchar)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    p_id integer;
BEGIN
    INSERT INTO cahub.user(username, email, password, firstname, lastname, role, consumer_key, shared_secret, avatar) 
    VALUES (p_username, p_email, p_password::text, p_firstname, p_lastname, p_role, p_consumer_key, p_shared_secret, p_avatar) 
    RETURNING idUser INTO p_id;
    
    RETURN json_build_object(
        'idUser', p_id,
        'username', p_username,
        'email', p_email,
        'firstName', p_firstname,
        'lastName', p_lastname,
        'role', p_role,
		'avatar', p_avatar
    );
END;
$BODY$;

-- FUNCTION: cahub.sp_find_user_by_email(character varying)

-- DROP FUNCTION IF EXISTS cahub.sp_find_user_by_email(character varying);

CREATE OR REPLACE FUNCTION cahub.sp_find_user_by_email(
	p_email character varying)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_username                              varchar;
	v_password                              varchar;
	v_id                                    integer;
	v_email                                 varchar;
	v_avatar                                 varchar;
begin
	select u.username into v_username from cahub.user u where email = p_email;
	select u.password into v_password from cahub.user u where email = p_email;
	select u.idUser into v_id from cahub.user u where email = p_email;
	select u.email into v_email from cahub.user u where email = p_email;
	select u.avatar into v_avatar from cahub.user u where email = p_email;
	if v_username isnull then
	return v_username;
	else
	return json_build_object(
		'id', v_id,
		'username', v_username,
		'password', v_password,
	'email', v_email,
	'picture', v_avatar);
	end if;
end;
$BODY$;

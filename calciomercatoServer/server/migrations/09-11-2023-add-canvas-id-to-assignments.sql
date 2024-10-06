alter table cahub.assigment
add column canvasId integer,
add column canvasUserId integer,
add column canvasCourseId integer;

CREATE OR REPLACE FUNCTION cahub.sp_update_activity_by_canvasid(
	p_canvasid integer,
	p_internalid integer,
	p_canvascourseid integer,
	p_canvasuserid integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_modifiedDate                      TIMESTAMP;
	v_canvasId                          integer;
	v_canvasUserId                      integer;
	v_canvasCourseId                    integer;
begin
	if (p_canvasid is null) THEN
	update cahub.assigment
	set canvasId = p_canvasId, canvasuserid = p_canvasUserId, canvascourseid = p_canvasCourseId, modifiedDate = now()
	where idassigment = p_internalId;
	return json_build_object(
		'Success', 'true',
		'Operation', 'unlink'
	);
	else
	update cahub.assigment
	set canvasId = p_canvasId, canvasuserid = p_canvasUserId, canvascourseid = p_canvasCourseId, modifiedDate = now()
	where idassigment = p_internalId;
	return json_build_object(
		'Success', 'true',
		'Operation', 'link'
	);
	end if;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_search_activity_by_type(
	p_idquiz integer,
	p_idcrossword integer,
	p_idmemory integer,
	p_idwordsearch integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_name                              varchar;
	v_description                             varchar;
	v_createdDate                       TIMESTAMP;
	v_modifiedDate                      TIMESTAMP;
	v_id                                    integer;
	v_idquiz                            integer;
	v_json_resp                       json;
	v_json_resp_act                   json[];
begin
	if (p_idquiz is not null or p_idquiz != 0) then
	select u.name into v_name from cahub.quiz u where idquiz = p_idquiz;
	select u.description into v_description from cahub.quiz u where idquiz = p_idquiz;
	select u.createdDate into v_createdDate from cahub.question u where idquiz = p_idquiz;
	select u.modifiedDate into v_modifiedDate from cahub.question u where idquiz = p_idquiz;
	select u.idquiz into v_id from cahub.quiz u where idquiz = p_idquiz;
	SELECT json_build_object(
		'idQuiz', v_id,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'Question', (
			SELECT json_object_agg(q.idquestion, jsonb_build_object(
				'idQuestion', q.idquestion,
				'text', q.text,
				'description', q.description,
				'idQuiz', q.idquiz,
				'createdDate', q.createdDate,
				'modifiedDate', q.modifiedDate,
				'Answer', v_json_resp_answer
			))
			FROM cahub.question q
			LEFT JOIN (
				SELECT a.idquestion, jsonb_agg(jsonb_build_object(
					'idAnswer', a.idanswer,
					'text', a.text,
					'description', a.description,
					'isCorrect', a.iscorrect,
					'createdDate', a.createdDate,
					'modifiedDate', a.modifiedDate
				)) AS v_json_resp_answer
				FROM cahub.answer a
				GROUP BY a.idquestion
			) a ON q.idquestion = a.idquestion
			WHERE q.idquiz = p_idquiz
		)
	) into v_json_resp;
	return v_json_resp;
	elsif (p_idcrossword is not null or p_idcrossword != 0) THEN
	select array(
        select jsonb_build_object(
			'idWords', w.idwordincrossword,
			'text', w.text,
            'description', w.description,
			'direction', w.direction,
			'idCrossWord', w.idcrossword,
			'createdDate', w.createdDate,
            'modifiedDate', w.modifiedDate
		)
		from cahub.wordincrossword w, cahub.crossword c
		where w.idcrossword = c.idcrossword and c.idcrossword = p_idcrossword
        ) ::json[] into v_json_resp_act;
	
	select u.name into v_name from cahub.crossword u where idcrossword = p_idcrossword;
	select u.description into v_description from cahub.crossword u where idcrossword = p_idcrossword;
	select u.createdDate into v_createdDate from cahub.crossword u where idcrossword = p_idcrossword;
	select u.modifiedDate into v_modifiedDate from cahub.crossword u where idcrossword = p_idcrossword;
	select u.idcrossword into v_id from cahub.crossword u where idcrossword = p_idcrossword;
	return json_build_object(
		'idCrossWord', v_id,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'Words', v_json_resp_act
	);
	elsif (p_idmemory is not null or p_idmemory != 0) THEN
		select array(
        select jsonb_build_object(
			'idWords', c.idrecord,
			'text', c.text,
            'description', c.description,
			'idMemory', c.idmemory,
			'createdDate', c.createdDate,
            'modifiedDate', c.modifiedDate
		)
		from cahub.memory w, cahub.record c
		where w.idmemory = c.idmemory and c.idmemory = p_idmemory
        ) ::json[] into v_json_resp_act;
	
	select u.name into v_name from cahub.memory u where idmemory = p_idmemory;
	select u.description into v_description from cahub.memory u where idmemory = p_idmemory;
	select u.createdDate into v_createdDate from cahub.memory u where idmemory = p_idmemory;
	select u.modifiedDate into v_modifiedDate from cahub.memory u where idmemory = p_idmemory;
	select u.idmemory into v_id from cahub.memory u where idmemory = p_idmemory;
	return json_build_object(
		'idMemory', v_id,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'Words', v_json_resp_act
	);
	elsif (p_idwordsearch is not null or p_idwordsearch != 0) THEN
	select array(
        select jsonb_build_object(
			'idWords', c.idwordinwordsearch,
			'text', c.text,
            'description', c.description,
			'direction', c.direction,
			'isReverse', c.reverse,
			'idWordSearch', c.idwordsearch,
			'createdDate', c.createdDate,
            'modifiedDate', c.modifiedDate
		)
		from cahub.wordsearch w, cahub.wordinwordsearch c
		where w.idwordsearch = c.idwordsearch and c.idwordsearch = p_idwordsearch
        ) ::json[] into v_json_resp_act;
	
	select u.name into v_name from cahub.wordsearch u where idwordsearch = p_idwordsearch;
	select u.description into v_description from cahub.wordsearch u where idwordsearch = p_idwordsearch;
	select u.createdDate into v_createdDate from cahub.wordsearch u where idwordsearch = p_idwordsearch;
	select u.modifiedDate into v_modifiedDate from cahub.wordsearch u where idwordsearch = p_idwordsearch;
	select u.idwordsearch into v_id from cahub.wordsearch u where idwordsearch = p_idwordsearch;
	return json_build_object(
		'idWordSearch', v_id,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'Words', v_json_resp_act
	);
	end if;
end;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.sp_find_activity_by_canvasId(
	p_id integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	v_idquiz               integer;
	v_idcrossword          integer;
	v_idmemory             integer;
	v_idwordsearch          integer;
	v_json_resp                       json;
begin
	select idquiz into v_idquiz from cahub.assigment where canvasid = p_id;
	select idcrossword into v_idcrossword from cahub.assigment where canvasid = p_id;
	select idmemory into v_idmemory from cahub.assigment where canvasid = p_id;
	select idwordsearch into v_idwordsearch from cahub.assigment where canvasid = p_id;
	
	if(v_idquiz is null and v_idcrossword is null and v_idmemory is null and v_idwordsearch is null) then
	return null;
	else
	v_json_resp := cahub.sp_search_activity_by_type(v_idquiz, v_idcrossword, v_idmemory, v_idwordsearch);
	if (v_json_resp is null) then
	return null;
	else
	return v_json_resp;
	end if;
	end if;
end;
$BODY$;
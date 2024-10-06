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
	v_json                            json;
	v_json2                           json;
begin
	if (p_idquiz is not null or p_idquiz != 0) then
	raise notice 'entra en quiz';
	select u.name into v_name from cahub.quiz u where idquiz = p_idquiz;
	select u.description into v_description from cahub.quiz u where idquiz = p_idquiz;
	select u.createdDate into v_createdDate from cahub.question u where idquiz = p_idquiz;
	select u.modifiedDate into v_modifiedDate from cahub.question u where idquiz = p_idquiz;
	select u.idquiz into v_id from cahub.quiz u where idquiz = p_idquiz;
	
	SELECT json_build_object(
    'name', a.name,
	'description', a.description
		)
		FROM cahub.assigment a
		where a.idassigment = p_idquiz into v_json2;
	
	SELECT json_agg(json_build_object(
    'question', q.text,
	'description', q.description,
	'questionType', q.question_type,
    'answers', (
        SELECT json_agg(json_build_object(
            'text', text,
			'isCorrect', isCorrect
        ))
        FROM cahub.answer
        WHERE idquestion = q.idquestion
    )
		))
		FROM cahub.question q
		where q.idquiz = p_idquiz into v_json;
	
	SELECT json_build_object(
		'idQuiz', v_id,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'questions', v_json) into v_json_resp;
	return v_json_resp;
	elsif (p_idcrossword is not null or p_idcrossword != 0) THEN
	raise notice 'entra en crucigrama';
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
		'words', v_json_resp_act
	);
	elsif (p_idmemory is not null or p_idmemory != 0) THEN
	raise notice 'entra en memoria';
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
		'words', v_json_resp_act
	);
	elsif (p_idwordsearch is not null or p_idwordsearch != 0) THEN
	raise notice 'entra en sopa';
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
		'words', v_json_resp_act
	);
	end if;
end;
$BODY$;
alter table cahub.record
add column image varchar

CREATE OR REPLACE FUNCTION cahub.create_activity_and_gamesmemory(
	description_data jsonb,
	words_list jsonb)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  crossword_id integer;
  word_record jsonb;
BEGIN
  -- Insertar la descripción en la tabla activity
  INSERT INTO cahub.memory (name, description) 
  VALUES (description_data->>'name', description_data->>'description') 
  RETURNING idmemory INTO crossword_id;
  
  INSERT INTO cahub.assigment (name, description, idmemory, iduser) 
  VALUES (description_data->>'name', description_data->>'description', crossword_id, (description_data->>'idUser')::integer);
 
  -- Insertar las palabras en la tabla games
  FOR word_record IN SELECT * FROM jsonb_array_elements(words_list)
  LOOP
      raise notice 'llegapppppppp: %', word_record->>'text';
    INSERT INTO cahub.record (text, description, idmemory, image) 
    VALUES (word_record->>'text', 
            word_record->>'description', 
			crossword_id,
			(word_record->>'image')::bytea 
		   );
  END LOOP;

  -- Retornar el ID de la actividad creada
  RETURN true;
END;
$BODY$;

ALTER FUNCTION cahub.create_activity_and_gamesmemory(jsonb, jsonb)
    OWNER TO postgres;

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
	v_assignment                        integer;
	v_description                             varchar;
	v_createdDate                       TIMESTAMP;
	v_modifiedDate                      TIMESTAMP;
	v_id                                    integer;
	v_idquiz                            integer;
	v_json_resp                       json;
	v_json_resp_act                   json[];
	v_json                            json;
	v_json2                           json;
	v_image                           bytea;
begin
	if (p_idquiz is not null or p_idquiz != 0) then
	raise notice 'entra en quiz';
	select u.name into v_name from cahub.quiz u where idquiz = p_idquiz;
	select u.description into v_description from cahub.quiz u where idquiz = p_idquiz;
	select u.createdDate into v_createdDate from cahub.question u where idquiz = p_idquiz;
	select u.modifiedDate into v_modifiedDate from cahub.question u where idquiz = p_idquiz;
	select u.idquiz into v_id from cahub.quiz u where idquiz = p_idquiz;
	select a.idAssigment into v_assignment from cahub.quiz u, cahub.assigment a where a.idQuiz = u.idquiz and u.idquiz = p_idquiz;
	
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
		'idAssigment', v_assignment,
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
	select a.idassigment into v_assignment from cahub.crossword u, cahub.assigment a where a.idCrossword = u.idcrossword and u.idcrossword = p_idcrossword;
	return json_build_object(
		'idCrossWord', v_id,
		'idAssigment', v_assignment,
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
			'image', c.image,
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
	select a.idAssigment into v_assignment from cahub.memory u, cahub.assigment a where a.idmemory = u.idmemory and u.idmemory = p_idmemory;
	return json_build_object(
		'idMemory', v_id,
		'name', v_name,
		'idAssigment', v_assignment,
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
	select a.idAssigment into v_assignment from cahub.wordsearch u, cahub.assigment a where a.idwordsearch = u.idwordsearch and u.idwordsearch = p_idwordsearch;
	return json_build_object(
		'idWordSearch', v_id,
		'idAssigment', v_assignment,
		'name', v_name,
		'description', v_description,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'words', v_json_resp_act
	);
	end if;
end;
$BODY$;

ALTER FUNCTION cahub.sp_search_activity_by_type(integer, integer, integer, integer)
    OWNER TO postgres;


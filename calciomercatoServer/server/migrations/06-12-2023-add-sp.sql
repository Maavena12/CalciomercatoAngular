CREATE OR REPLACE FUNCTION cahub.sp_find_assigment_and_game_by_id(
	p_id integer)
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
	v_active                            boolean;
	v_idquiz                                    integer;
	v_idcrossword                                    integer;
	v_idmemory                                    integer;
	v_idwordsearch                                    integer;
	v_iduser                                    integer;
	v_json_resp                       json;
begin
	select u.name into v_name from cahub.assigment u where idassigment = p_id;
	select u.description into v_description from cahub.assigment u where idassigment = p_id;
	select u.createdDate into v_createdDate from cahub.assigment u where idassigment = p_id;
	select u.modifiedDate into v_modifiedDate from cahub.assigment u where idassigment = p_id;
	select u.idassigment into v_id from cahub.assigment u where idassigment = p_id;
	select u.active into v_active from cahub.assigment u where idassigment = p_id;
	select u.idquiz into v_idquiz from cahub.assigment u where idassigment = p_id;
	select u.idcrossword into v_idcrossword from cahub.assigment u where idassigment = p_id;
	select u.idmemory into v_idmemory from cahub.assigment u where idassigment = p_id;
	select u.idwordsearch into v_idwordsearch from cahub.assigment u where idassigment = p_id;
	select u.iduser into v_iduser from cahub.assigment u where idassigment = p_id;
	if(v_idquiz is null and v_idcrossword is null and v_idmemory is null and v_idwordsearch is null) then
	return null;
	else
	v_json_resp := cahub.sp_search_activity_by_type(v_idquiz, v_idcrossword, v_idmemory, v_idwordsearch);
	if (v_json_resp is null) then
	return null;
	else
	return json_build_object(
		'idAssigemnt', v_id,
		'name', v_name,
		'description', v_description,
		'active', v_active,
		'idQuiz', v_idquiz,
		'idCrossword', v_idcrossword,
		'idMemory', v_idmemory,
		'idWordsearch', v_idwordsearch,
		'idUser', v_iduser,
		'createdDate', v_createdDate,
		'modifiedDate', v_modifiedDate,
		'game', v_json_resp
	);
	end if;
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

alter table cahub.question
add column question_type varchar check(question_type in ('single-choice', 'multiple-choice', 'true-false'))


CREATE OR REPLACE FUNCTION cahub.create_activity_and_gamesquiz(
	description_data jsonb,
	words_list jsonb,
	answer_list jsonb)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  crossword_id integer;
  word_record jsonb;
  answer_record jsonb;
  question_id integer;
  v_idquestion integer;
BEGIN
  -- Insertar la descripción en la tabla activity
  INSERT INTO cahub.quiz (name, description) 
  VALUES (description_data->>'name', description_data->>'description') 
  RETURNING idquiz INTO crossword_id;
  
  INSERT INTO cahub.assigment (name, description, idquiz, iduser) 
  VALUES (description_data->>'name', description_data->>'description', crossword_id, (description_data->>'idUser')::integer);
  
  -- Insertar las palabras en la tabla games
  FOR word_record IN SELECT * FROM jsonb_array_elements(words_list)
  LOOP
    INSERT INTO cahub.question (text, description, idquiz) 
    VALUES (word_record->>'question', 
            word_record->>'description',
			word_record->>'question_type',
			crossword_id
		   );
  END LOOP;
  FOR answer_record IN SELECT * FROM jsonb_array_elements(answer_list)
    LOOP
	select idquestion into v_idquestion from cahub.question q, cahub.quiz qq where qq.idquiz = q.idquiz and q.text = (answer_record->> 'question')::varchar;
	INSERT INTO cahub.answer (text, isCorrect, idquestion) 
    VALUES (answer_record->>'text', 
            (answer_record->>'isCorrect')::boolean,
			v_idquestion
		   );
  END LOOP;

  -- Retornar el ID de la actividad creada
  RETURN true;
END;
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

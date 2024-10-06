ALTER TABLE cahub.question 
alter column description drop not null;

ALTER TABLE cahub.wordInCrossWord 
alter column description drop not null;

ALTER TABLE cahub.record 
alter column description drop not null;

ALTER TABLE cahub.wordInWordSearch 
alter column description drop not null;

CREATE OR REPLACE FUNCTION cahub.create_activity_and_gamesQuiz(
  description_data jsonb,
  words_list jsonb,
  answer_list jsonb
)
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

CREATE OR REPLACE FUNCTION cahub.create_activity_and_games(
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
  INSERT INTO cahub.crossword (name, description) 
  VALUES (description_data->>'name', description_data->>'description') 
  RETURNING idcrossword INTO crossword_id;
  
  INSERT INTO cahub.assigment (name, description, idcrossword, iduser) 
  VALUES (description_data->>'name', description_data->>'description', crossword_id, (description_data->>'idUser')::integer);
  
  -- Insertar las palabras en la tabla games
  FOR word_record IN SELECT * FROM jsonb_array_elements(words_list)
  LOOP
    INSERT INTO cahub.wordincrossword (text, description, direction, idcrossword) 
    VALUES (word_record->>'text', 
            word_record->>'description', 
            word_record->>'direction',
			crossword_id
		   );
  END LOOP;

  -- Retornar el ID de la actividad creada
  RETURN true;
END;
$BODY$;

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
    INSERT INTO cahub.record (text, description, idmemory) 
    VALUES (word_record->>'text', 
            word_record->>'description', 
			crossword_id
		   );
  END LOOP;

  -- Retornar el ID de la actividad creada
  RETURN true;
END;
$BODY$;

CREATE OR REPLACE FUNCTION cahub.create_activity_and_gameswordsearch(
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
  INSERT INTO cahub.wordsearch (name, description) 
  VALUES (description_data->>'name', description_data->>'description') 
  RETURNING idwordsearch INTO crossword_id;
  
  INSERT INTO cahub.assigment (name, description, idwordsearch, iduser) 
  VALUES (description_data->>'name', description_data->>'description', crossword_id, (description_data->>'idUser')::integer);
  
  -- Insertar las palabras en la tabla games
  FOR word_record IN SELECT * FROM jsonb_array_elements(words_list)
  LOOP
    INSERT INTO cahub.wordinwordsearch (text, description, direction, reverse, idwordsearch) 
    VALUES (word_record->>'text', 
            word_record->>'description',
			word_record->>'direction', 
            (word_record->>'isReversed')::boolean,
			crossword_id
		   );
  END LOOP;

  -- Retornar el ID de la actividad creada
  RETURN true;
END;
$BODY$;
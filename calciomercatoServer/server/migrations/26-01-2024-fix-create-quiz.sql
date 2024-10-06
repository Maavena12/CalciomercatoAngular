-- FUNCTION: cahub.create_activity_and_gamesquiz(jsonb, jsonb, jsonb)

-- DROP FUNCTION IF EXISTS cahub.create_activity_and_gamesquiz(jsonb, jsonb, jsonb);

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
    INSERT INTO cahub.question (text, description, question_type, idquiz) 
    VALUES (word_record->>'question', 
            word_record->>'description',
			word_record->>'question_type',
			crossword_id
		   );
  END LOOP;
  FOR answer_record IN SELECT * FROM jsonb_array_elements(answer_list)
    LOOP
	select idquestion into v_idquestion 
	from cahub.question q, cahub.quiz qq
	where crossword_id = q.idquiz 
	and q.text = (answer_record->> 'question')::varchar
	ORDER BY idquestion DESC 
	LIMIT 1;
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

ALTER FUNCTION cahub.create_activity_and_gamesquiz(jsonb, jsonb, jsonb)
    OWNER TO postgres;

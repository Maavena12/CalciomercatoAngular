CREATE OR REPLACE FUNCTION cahub.sp_find_all_assigment_by_user(
	p_id integer)
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
			'idAssigment', a.idAssigment,
			'name', a.name,
            'description', a.description,
			'active', a.active,
			'idQuiz', a.idquiz,
			'idCrossword', a.idcrossword,
			'idMemory', a.idmemory,
			'idWordsearch', a.idwordsearch,
			'idUser', a.iduser,
			'createdDate', a.createdDate,
            'modifiedDate', a.modifiedDate
		)
		from cahub.assigment a where active = true and a.idUser = p_id
        ) ::json[] into v_json_resp;
		return v_json_resp;
end;
$BODY$;
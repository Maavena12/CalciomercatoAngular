/*----------------------------------------------------------------------------------------------------------------------
--------------------------------------------- DESPUES CUARTO CORRE ESTO -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------ */


CREATE OR REPLACE FUNCTION cahub.update_date_function()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
					NEW.modifiedDate = NOW();
					return NEW;
				END;
$BODY$;
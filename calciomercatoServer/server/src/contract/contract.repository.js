import pool from "../config/database.js"

const contractRepository = {};

contractRepository.readContract = async () => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_all_contracts()`);
    return resp.rows[0].sp_find_all_contracts;
  } catch (error) {
    throw error;
  }
}

contractRepository.readContractByName = async text => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_player_by_contract('${text}')`);
    return resp.rows[0].sp_find_player_by_contract;
  } catch (error) {
    throw error;
  }
}

contractRepository.createContract = async (firstName, lastName, position, birth_date, playerImage, cost, name, country, fundation, teamImage, games, goals, assits, salary, beginDate, endDate) => {
  try {
    if ((endDate === null) || (endDate === '')){
      const resp = await pool.query(`SELECT * FROM sp_create_player_contract('${firstName}', '${lastName}', '${position}', '${birth_date}', '${playerImage}', '${cost}', '${name}', '${country}', '${fundation}', '${teamImage}', ${games}, ${goals}, ${assits}, '${salary}', '${beginDate}', null)`);
      return resp.rows[0].sp_create_player_contract;
    } else {
      const resp = await pool.query(`SELECT * FROM sp_create_player_contract('${firstName}', '${lastName}', '${position}', '${birth_date}', '${playerImage}', '${cost}', '${name}', '${country}', '${fundation}', '${teamImage}', ${games}, ${goals}, ${assits}, '${salary}', '${beginDate}', '${endDate}')`);
      return resp.rows[0].sp_create_player_contract;
    }
  } catch (error) {
    throw error;
  }
}

export default contractRepository
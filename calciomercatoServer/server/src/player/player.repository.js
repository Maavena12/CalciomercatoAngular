import pool from "../config/database.js"

const playerRepository = {};

playerRepository.readPlayer = async () => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_all_players()`);
    return resp.rows[0].sp_find_all_players;
  } catch (error) {
    throw error;
  }
}

playerRepository.readPlayerByName = async text => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_player_by_name('${text}')`);
    return resp.rows[0].sp_find_player_by_name;
  } catch (error) {
    throw error;
  }
}

export default playerRepository
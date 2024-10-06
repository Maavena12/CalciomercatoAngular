import pool from "../config/database.js"

const teamRepository = {};

teamRepository.readTeam = async () => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_all_teams()`);
    return resp.rows[0].sp_find_all_teams;
  } catch (error) {
    throw error;
  }
}

teamRepository.readPlayersByTeamName = async (team) => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_player_by_team('${team}')`);
    return resp.rows[0].sp_find_player_by_team;
  } catch (error) {
    throw error;
  }
}

teamRepository.readTeamByName = async text => {
  try {
    const resp = await pool.query(`SELECT * FROM sp_find_team_by_name('${text}')`);
    return resp.rows[0].sp_find_team_by_name;
  } catch (error) {
    throw error;
  }
}

export default teamRepository
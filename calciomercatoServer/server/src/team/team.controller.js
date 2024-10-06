import teamServices from './team.services.js'

const teamController = {};

teamController.readTeam = async (req, res) => {
    try {
      const answer = await teamServices.readTeam()
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

teamController.readPlayersByTeamName = async (req, res) => {
  try {

    const answer = await teamServices.readPlayersByTeamName(req.params.team)

    res.send(answer)
  } catch (error) {
    return res.status(400).send(error.stack)
  }
}

teamController.readTeamByName = async (req, res) => {
    try {
      const answer = await teamServices.readTeamByName(req.params.name)
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

export default teamController
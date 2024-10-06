import contractServices from './contract.services.js'

const contractController = {};

contractController.readContract = async (req, res) => {
    try {
      const answer = await contractServices.readContract()
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

contractController.readContractByName = async (req, res) => {
    try {
      const answer = await contractServices.readContractByName(req.params.name)
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

contractController.createContract = async (req, res) => {
  try {
    const answer = await contractServices.createContract(req.body.firstName, req.body.lastName, req.body.position, req.body.birth_date, req.body.playerImage, req.body.cost, req.body.name, req.body.country, req.body.fundation, req.body.teamImage, req.body.games, req.body.goals, req.body.assits, req.body.salary, req.body.beginDate, req.body.endDate)
    res.send(answer)
  } catch (error) {
    return res.status(400).send(error.stack)
  }
}

export default contractController
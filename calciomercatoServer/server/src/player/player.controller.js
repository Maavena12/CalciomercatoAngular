import playerServices from './player.services.js'

const playerController = {};

playerController.readPlayer = async (req, res) => {
    try {
      const answer = await playerServices.readPlayer()
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

playerController.readPlayerByName = async (req, res) => {
    try {
      const answer = await playerServices.readPlayerByName(req.params.name)
  
      res.send(answer)
    } catch (error) {
      return res.status(400).send(error.stack)
    }
}

export default playerController
import playerRepository from './player.repository.js'

const playerServices = {};

playerServices.readPlayer = async () => {
    return await playerRepository.readPlayer()
}
  
playerServices.readPlayerByName = async name => {
    return await playerRepository.readPlayerByName(name)
}

export default playerServices
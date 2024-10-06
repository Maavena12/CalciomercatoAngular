import teamRepository from './team.repository.js'

const teamServices = {};

teamServices.readTeam = async () => {
    return await teamRepository.readTeam()
}

teamServices.readPlayersByTeamName = async team => {
    return await teamRepository.readPlayersByTeamName(team)
}
  
teamServices.readTeamByName = async name => {
    return await teamRepository.readTeamByName(name)
}

export default teamServices
import contractRepository from './contract.repository.js'

const contractServices = {};

contractServices.readContract = async () => {
    return await contractRepository.readContract()
}
  
contractServices.readContractByName = async name => {
    return await contractRepository.readContractByName(name)
}

contractServices.createContract = async (firstName, lastName, position, birth_date, playerImage, cost, name, country, fundation, teamImage, games, goals, assits, salary, beginDate, endDate) => {
    return await contractRepository.createContract(firstName, lastName, position, birth_date, playerImage, cost, name, country, fundation, teamImage, games, goals, assits, salary, beginDate, endDate)
}

export default contractServices
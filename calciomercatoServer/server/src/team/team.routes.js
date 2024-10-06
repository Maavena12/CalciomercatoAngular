import express from 'express'
const teamRouter = express.Router()
import teamController from './team.controller.js'


teamRouter.get('/', teamController.readTeam)
teamRouter.get('/team/:team', teamController.readPlayersByTeamName)
teamRouter.get('/name/:name', teamController.readTeamByName)


export default teamRouter
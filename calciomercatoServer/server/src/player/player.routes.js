import express from 'express'
const playerRouter = express.Router()
import playerController from './player.controller.js'


playerRouter.get('/', playerController.readPlayer)
playerRouter.get('/name/:name', playerController.readPlayerByName)


export default playerRouter
import express from 'express'
const contractRouter = express.Router()
import contractController from './contract.controller.js'


contractRouter.get('/', contractController.readContract)
contractRouter.get('/name/:name', contractController.readContractByName)
contractRouter.post('/', contractController.createContract)


export default contractRouter
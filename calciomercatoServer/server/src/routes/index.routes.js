import Router from "express-promise-router";
import playerRouter from "../player/player.routes.js";
import teamRouter from "../team/team.routes.js"
import contractRouter from "../contract/contract.routes.js";


const routerModule = Router();

routerModule.use("/player", playerRouter);
routerModule.use("/team", teamRouter);
routerModule.use("/contract", contractRouter);

export default routerModule
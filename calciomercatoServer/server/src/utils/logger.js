import { createLogger, format, transports } from 'winston';
import NODE_ENV from "./environment.js";

const logger = createLogger({
    format: NODE_ENV === "production"? 
    format.combine(
        format.simple(),
        format.printf(info => `${info.level.toUpperCase()} - ${info.message}`)
    ) :
    format.combine(
        format.simple(),
        format.timestamp({
            format: "YYYY-MM-DD HH:mm:ss",
        }),
        format.colorize({ all: true }),
        format.printf(info => `[${info.timestamp}] - ${info.level} - ${info.message}`)
    ),
    transports: [
        new transports.Console({
            level: 'debug',
        })
    ]
});

logger.stream = {
    write: function(message, encoding){
        logger.info(message.slice(0, -1));
    },
};

export default logger
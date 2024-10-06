import redis from 'redis';
import env from "./environment.js";

const client = redis.createClient({
    host: env.REDIS_DB_HOST,
    port: env.REDIS_DB_PORT,
    password: env.REDIS_DB_PASSWORD,
    db: env.REDIS_DB_NUMBER,
    read_timeout: env.REDIS_DB_TIMEOUT,
});

client.on('error', function(error){
    console.log(error);
})

export default client
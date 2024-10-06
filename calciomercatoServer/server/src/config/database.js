import pkg from "pg";
const { Pool, Client } = pkg;
import logger  from '../utils/logger.js';
import ObjLog  from '../utils/ObjLog.js';
import env from '../utils/environment.js';

const connectionData = {
  user: env.PG_DB_USER,
  host: env.PG_DB_HOST,
  database: env.PG_DB_NAME,
  password: env.PG_DB_PASSWORD,
  port: env.PG_DB_PORT,
};

const pool = new Pool(connectionData);
const client = new Client(connectionData);

pool
  .connect()
  .then((response) => {
    logger.info(`PGDB is connected`);
    ObjLog.log(`PGDB is connected`);
    pool.on(
      'connect', client => {
        client.on('notice', notice => {
          console.log(notice.message)
        })
      }
    )
  })
  .catch((err) => {
    logger.error(`PGDB is not connected: ${err}`);
    ObjLog.log(`PGDB is not connected: ${err}`);
    client.end();
  });
  client.connect()
  .then(response => {
    logger.info("PG-DB client-listener is connected");
    ObjLog.log("PG-DB client-listener is connected");
  
    // // Se escuchan los canales
    client.query("listen level_upgrade");
    client.query("listen verif_code");
    client.query("listen to_pro_chat");
    client.query("listen chat_asign");
    client.query("listen to_basic_chat");
    client.query("listen rate_change");
    client.query("listen cost_rate_update");
    client.query("listen operation_route_update");
  
    // Se recibe el evento y se envía al FE
    client.on('notification', async (data) => {
      console.log('channel :',data.channel)
      console.log('channel :',data.payload) 
  
      if (data.channel === "level_upgrade") {
          const level = JSON.parse(data.payload);
  
          console.log("🚀 ~  level", level)
          if (level.noti && level.noti[0].title === 'CONVERSION_CRIPTO_COMPLETADO') {
            // se envia email
            let mailBody = {
              subject: getMailSubject(level.exchangeType),
              title: getMailTitle(level.exchangeType),
              subtitle: `${
                level.exchange.client_gender === "M" ? "Estimado" : "Estimada"
              } ${level.exchange.client_first_name},`,
              firstParagraph: getMailFirstParagraph(
                level.exchangeType,
                level.exchange
              ),
              secondParagraph: `Si usted NO realizó esta operación y se preocupa por por la seguridad de su cuenta CriptoRemesa, contacte inmediatamente a servicioalcliente@criptoremesa.com.`,
              from: "no-reply@criptoremesa.com",
              to: level.exchange.email_client,
            };
            
            console.log("🚀 ~ mailBody", mailBody)
            await mailSender.sendMail(mailBody);
  
            // se envia sms
            const phone_number = level.exchange.phone_client
            const msg = getSMSMessage(level.exchangeType,level.exchange)
  
            console.log("🚀 ~ msg", msg)
            await smsSender.sendSMS(phone_number,msg);
          }
  
      }
  
      if (data.channel === "verif_code") {
          const pld = JSON.parse(data.payload);
      }
  
      if (data.channel === "to_pro_chat") {
          const msg = JSON.parse(data.payload);
      }
  
      if (data.channel === "chat_asign") {
        const msg = JSON.parse(data.payload);
      }
  
      if (data.channel === "to_basic_chat") {
        const msg = JSON.parse(data.payload);
      }
  
      if (data.channel === "rate_change") {
        const rate = JSON.parse(data.payload);
      }
  
      if (data.channel  === "cost_rate_update"){
      }
  
      if (data.channel === "operation_route_update") {
        const opRoute = JSON.parse(data.payload);
      }
    });
  })
  .catch(err => {
      logger.error(`PG-DB client-listener is not connected: ${err}`);
      client.end();
  });

export default pool
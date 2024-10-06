import * as dotenv from 'dotenv'
if (process.env.NODE_ENV !== 'production') dotenv.config()

const env = {
  NODE_ENV: process.env.NODE_ENV,

  PORT: process.env.PORT,
  DBMS: process.env.DBMS,

  PG_DB_NAME: process.env.PG_DB_NAME,
  PG_DB_HOST: process.env.PG_DB_HOST,
  PG_DB_PORT: process.env.PG_DB_PORT,
  PG_DB_USER: process.env.PG_DB_USER,
  PG_DB_PASSWORD: process.env.PG_DB_PASSWORD,

  BITNAMI_CANVAS_URL: process.env.BITNAMI_CANVAS_URL,
  BITNAMI_CANVAS_CLIENT_ID: process.env.BITNAMI_CANVAS_CLIENT_ID,
  BITNAMI_CANVAS_CLIENT_SECRET: process.env.BITNAMI_CANVAS_CLIENT_SECRET,
  CANVAS_REDIRECT_URI: process.env.CANVAS_REDIRECT_URI,
  CANVAS_EXT_APP: process.env.CANVAS_EXT_APP,
  CANVAS_API_TOKEN: process.env.CANVAS_API_TOKEN
}

export default env

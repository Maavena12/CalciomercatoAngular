import env from '../utils/enviroment.js'
import Provider from 'oidc-provider'

export const configuration = {
  clients: [
    {
      client_id: env.BITNAMI_CANVAS_CLIENT_ID,
      client_secret: env.BITNAMI_CANVAS_CLIENT_SECRET,
      grant_types: ['authorization_code'],
      redirect_uris: [
        env.CANVAS_REDIRECT_URI,
        'https://oidcdebugger.com/debug',
      ],
      response_types: ['code'],

      //other configurations if needed
    },
  ],
  pkce: {
    required: () => false,
  },
}

export const oidc = new Provider(`http://localhost:${env.PORT}`, configuration)

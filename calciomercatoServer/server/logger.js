import morgan from 'morgan'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url';

import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc.js'
import timezone from 'dayjs/plugin/timezone.js'

dayjs.extend(utc)
dayjs.extend(timezone)

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

morgan.token('date', (req, res) => dayjs().tz('America/Caracas').format())

morgan.format(
  'monitor',
  '[:date] :remote-addr ":method :url HTTP/:http-version" :status - :response-time ms'
)

const stream = fs.createWriteStream(path.join(__dirname, 'access.log'), {
  flags: 'a',
})

morgan.format(
  'csv',
  ':date, :remote-addr, :method, :url, HTTP/:http-version, :status, :response-time'
)

export default morgan

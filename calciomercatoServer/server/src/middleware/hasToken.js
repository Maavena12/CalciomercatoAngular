import jwt from 'jsonwebtoken'

async function isAdmin(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1]

  if (!token) {
    return res.status(401).json({
      message: 'No autorizado',
    })
  }

  try {
    console.log('entra')
    const decoded = jwt.verify(token, process.env.JWT_SECRET)
    req.userId = decoded.id
  } catch (error) {
    return res
      .status(401)
      .json({ message: 'No autorizado', error: error.message })
  }

  next()
}

export default isAdmin

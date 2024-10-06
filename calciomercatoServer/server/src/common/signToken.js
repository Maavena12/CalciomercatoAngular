import jwt from 'jsonwebtoken'

function signToken(payload) {
  return jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: '1h',
  })
}

export default signToken

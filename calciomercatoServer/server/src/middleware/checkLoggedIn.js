import jwt from 'jsonwebtoken';

function checkLoggedIn(req, res, next) {
  const token = req.cookies.t || req.headers.authorization;

  if (!token) {
    // El usuario no está logueado
    return false;
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    // El usuario está logueado
    return true;
  } catch (error) {
    // El token no es válido o ha expirado
    return false;
  }
}

export default checkLoggedIn;
const validate = require('../middleware/validate')

function createValidation(...validators) {
  return [...validators, validate]
}

export default createValidation

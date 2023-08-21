import { Request } from 'firebase-functions/lib/common/providers/https'
import {
  validationResult,
  ValidationChain,
  ValidationError,
} from 'express-validator'

const functionValidators = async (
  validations: ValidationChain[],
  request: Request,
): Promise<{ valid: boolean; errors?: ValidationError[] }> => {
  for (const validation of validations) {
    const result = await validation.run(request)
    if (!result.isEmpty) break
  }

  const errors = validationResult(request)
  if (errors.isEmpty()) {
    return { valid: true }
  }

  return { valid: false, errors: errors.array() }
}

export { functionValidators }

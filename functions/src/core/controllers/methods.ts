import { Request } from 'firebase-functions/lib/common/providers/https'
import { authenticatedRequest } from '../../middlewares/authentification'
import { auth } from '../../admin'
import { DecodedIdToken } from 'firebase-admin/auth'
import { ValidationChain } from 'express-validator'
import { Response } from 'express'
import * as logger from 'firebase-functions/logger'
import { functionValidators } from '../../middlewares/validators'

export const ControllerRequest = async (
  request: Request,
  response: Response,
  {
    method,
    authenticated = true,
    validators = [],
    callback,
  }: {
    method: 'GET' | 'POST' | 'PUT' | 'DELETE'
    authenticated?: boolean
    validators?: ValidationChain[]
    callback: (props: {
      request: Request
      response: Response
      decoded: DecodedIdToken | undefined
    }) => unknown
  },
) => {
  if (request.method !== method) {
    response.sendStatus(405)
    return
  }

  let decoded: DecodedIdToken | undefined

  if (authenticated) {
    const {
      authenticated,
      error,
      decoded: decodedUser,
    } = await authenticatedRequest(request, auth)

    decoded = decodedUser

    if (!authenticated) {
      response.status(401).json({ error })
      return
    }
  }

  const validation = await functionValidators(validators, request)

  if (!validation.valid) {
    response.status(400).json({ errors: validation.errors })
    return
  }

  try {
    const result = await callback({ request, response, decoded })
    response.status(method === 'POST' ? 201 : 200).json(result)
  } catch (error) {
    logger.error(error)
    response.sendStatus(500)
  }
}

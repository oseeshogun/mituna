import { Request } from 'firebase-functions/lib/common/providers/https'
import * as admin from 'firebase-admin'
import { DecodedIdToken } from 'firebase-admin/auth'
import * as logger from 'firebase-functions/logger'

const authenticatedRequest = async (
  request: Request,
): Promise<{
  authenticated: boolean
  error?: unknown
  decoded?: DecodedIdToken
}> => {
  const tokenId = request.get('Authorization')?.split('Bearer ')[1]
  if (!tokenId) {
    return { authenticated: false, error: { message: 'No Authorization' } }
  }

  try {
    const decoded = await admin.auth().verifyIdToken(tokenId)

    return { authenticated: true, decoded }
  } catch (error) {
    logger.error(error)
    return { authenticated: false, error }
  }
}

export { authenticatedRequest }

import admin from 'firebase-admin'

import * as serviceAccount from './firebase.json'

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
})

const auth = admin.auth()

export { admin, auth }

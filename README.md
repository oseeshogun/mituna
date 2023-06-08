# Mituna - Application de Quiz

Mituna est une application de quiz open source créée avec Flutter et Dart. Elle vous permet de tester vos connaissances dans divers domaines en répondant à des questions à choix multiples. Ce document fournit des instructions détaillées sur la configuration et le lancement de l'application.

## Configuration

Avant de pouvoir exécuter l'application, vous devrez effectuer plusieurs étapes de configuration.

### 1. Configuration de flutter_dotenv

Mituna utilise le package `flutter_dotenv` pour charger les variables d'environnement à partir d'un fichier `.env`. Pour configurer le fichier `.env`, suivez ces étapes :

1. Copiez le fichier `.env.example` et renommez-le en `.env`.
2. Ouvrez le fichier `.env` dans un éditeur de texte.
3. Remplacez les valeurs des variables d'environnement par les valeurs appropriées.

### 2. Configuration de Firebase

Mituna utilise Firebase pour diverses fonctionnalités, y compris l'authentification des utilisateurs et le stockage des données. Suivez les étapes ci-dessous pour configurer Firebase sur iOS et Android :

#### Configuration pour Android :

1. Créez un projet Firebase sur le [site Firebase](https://console.firebase.google.com).
2. Téléchargez le fichier de configuration Firebase (fichier de service Google) pour votre projet.
3. Placez le fichier de configuration Firebase téléchargé dans le répertoire `android/app` de votre projet Flutter.

#### Configuration pour iOS :

1. Créez un projet Firebase sur le [site Firebase](https://console.firebase.google.com).
2. Téléchargez le fichier de configuration Firebase (fichier `GoogleService-Info.plist`) pour votre projet.
3. Placez le fichier de configuration Firebase téléchargé dans le répertoire `ios/Runner` de votre projet Flutter.

### 3. Configuration du fichier `questions.json`

Le fichier `questions.json` contient les questions qui seront posées dans l'application. Vous devez fournir votre propre fichier `questions.json` avec le format approprié. Placez ce fichier dans le répertoire `assets/data` de votre projet Flutter.

### 4. Configuration du backend NestJS (open source)

Mituna dispose d'un backend NestJS open source pour gérer la progression des scores des utilisateurs, les compétitions en ligne et le leaderboard. Vous pouvez trouver le code source du backend dans le dépôt suivant : [Lien du Repo Backend](https://github.com/oseeshogun/mituna-backend)

Suivez les instructions fournies dans le README du dépôt backend pour configurer et exécuter le backend.

### 5. Installation des dépendances

Pour installer les dépendances requises, exécutez la commande suivante à la racine de votre projet Flutter :

`flutter pub get`


## Lancement de l'application

Une fois la configuration terminée, vous pouvez lancer l'application Mituna en suivant ces étapes :

1. Assurez-vous que vous avez un périphérique émulé ou un appareil physique connecté.
2. À partir de la racine de votre projet Flutter, exécutez la commande suivante :

`flutter run`


L'application sera compilée et déployée sur votre périphérique. Vous pouvez maintenant profiter de Mituna et tester vos connaissances avec les quiz trivia proposés.

## Contributions

Les contributions à Mituna sont les bienvenues ! Si vous souhaitez contribuer, veuillez suivre ces étapes :

1. Fork du dépôt Mituna.
2. Créez une branche pour votre fonctionnalité ou votre correction de bogue.
3. Effectuez vos modifications et vos tests.
4. Soumettez une demande d'extraction vers la branche principale du dépôt Mituna.

Assurez-vous de fournir une description claire de votre contribution et de suivre les lignes directrices de contribution du projet.

## Licence

Mituna est distribué sous la licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus d'informations.

---

N'hésitez pas à contacter l'auteur du projet pour toute question ou demande d'assistance supplémentaire. Amusez-vous bien avec Mituna !
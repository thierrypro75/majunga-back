# API Platform - Système d'authentification

Ce projet est une API REST construite avec **Symfony 7.3** et **API Platform 4.1** qui implémente un système complet d'authentification et de gestion des utilisateurs avec JWT.

## 🚀 Fonctionnalités

- ✅ **Authentification JWT** avec LexikJWTAuthenticationBundle
- ✅ **Gestion des utilisateurs** avec rôles et permissions
- ✅ **API REST** complète avec API Platform
- ✅ **Sécurité** configurée avec Symfony Security
- ✅ **Base de données** SQLite pour le développement
- ✅ **CORS** configuré pour les applications frontend

## 📋 Prérequis

- PHP 8.2+
- Composer
- Symfony CLI (optionnel)

## 🛠️ Installation

1. **Cloner le projet**
```bash
git clone <repository-url>
cd majunga-back
```

2. **Installer les dépendances**
```bash
composer install
```

3. **Configurer l'environnement**
```bash
# Copier le fichier .env.example vers .env.local
cp .env.example .env.local

# Éditer .env.local avec vos configurations
# DATABASE_URL="sqlite:///var/data.db"
# JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
# JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
# JWT_PASSPHRASE=your_jwt_passphrase_here
```

4. **Créer les clés JWT** (déjà fait)
```bash
# Les clés sont déjà créées dans config/jwt/
# private.pem et public.pem
```

5. **Créer la base de données et exécuter les migrations**
```bash
# Créer la base SQLite
touch var/data.db

# Exécuter la migration
php bin/console doctrine:migrations:migrate
```

6. **Charger les données de test**
```bash
php bin/console doctrine:fixtures:load
```

## 🔐 Authentification

### Endpoints disponibles

#### 1. Inscription
```http
POST /api/auth/register
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "password123",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+33123456789"
}
```

#### 2. Connexion
```http
POST /api/auth/login
Content-Type: application/json

{
    "email": "user@example.com",
    "password": "password123"
}
```

#### 3. Profil utilisateur
```http
GET /api/auth/profile
Authorization: Bearer <jwt_token>
```

#### 4. Renouvellement de token
```http
POST /api/auth/refresh
Authorization: Bearer <jwt_token>
```

## 👥 Gestion des utilisateurs

### Utilisateurs de test créés

1. **Administrateur**
   - Email: `admin@example.com`
   - Mot de passe: `admin123`
   - Rôles: `ROLE_USER`, `ROLE_ADMIN`

2. **Utilisateur standard**
   - Email: `user@example.com`
   - Mot de passe: `user123`
   - Rôles: `ROLE_USER`

### API des utilisateurs

#### Lister les utilisateurs (Admin uniquement)
```http
GET /api/users
Authorization: Bearer <jwt_token_admin>
```

#### Obtenir un utilisateur
```http
GET /api/users/{id}
Authorization: Bearer <jwt_token>
```

#### Créer un utilisateur (Admin uniquement)
```http
POST /api/users
Authorization: Bearer <jwt_token_admin>
Content-Type: application/json

{
    "email": "newuser@example.com",
    "password": "password123",
    "firstName": "Jane",
    "lastName": "Smith",
    "phone": "+33987654321",
    "isActive": true,
    "roles": ["ROLE_USER"],
    "userRoles": ["/api/roles/1"]
}
```

#### Modifier un utilisateur
```http
PUT /api/users/{id}
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
    "firstName": "Updated Name",
    "lastName": "Updated Last Name"
}
```

## 🎭 Gestion des rôles

### API des rôles (Admin uniquement)

#### Lister les rôles
```http
GET /api/roles
Authorization: Bearer <jwt_token_admin>
```

#### Créer un rôle
```http
POST /api/roles
Authorization: Bearer <jwt_token_admin>
Content-Type: application/json

{
    "label": "ROLE_CUSTOM",
    "description": "Rôle personnalisé",
    "isActive": true
}
```

### Rôles par défaut

- `ROLE_USER` - Utilisateur standard
- `ROLE_ADMIN` - Administrateur
- `ROLE_MODERATOR` - Modérateur
- `ROLE_EDITOR` - Éditeur

## 🔒 Sécurité

### Configuration de sécurité

- **JWT Authentication** pour les API
- **Stateless** - Pas de session
- **CORS** configuré pour les applications frontend
- **Validation** des données avec Symfony Validator
- **Hachage** des mots de passe avec Argon2i

### Contrôle d'accès

- `/api/auth/register` - Accès public
- `/api/auth/login` - Accès public
- `/api/*` - Authentification requise
- `/api/users/*` - Rôles spécifiques selon l'opération
- `/api/roles/*` - ROLE_ADMIN uniquement

## 🛠️ Commandes utiles

```bash
# Démarrer le serveur de développement
symfony server:start

# Vider le cache
php bin/console cache:clear

# Voir les routes disponibles
php bin/console debug:router

# Voir la configuration de sécurité
php bin/console debug:config security

# Tester la connexion à la base de données
php bin/console doctrine:query:sql "SELECT 1"
```

## 📁 Structure du projet

```
majunga-back/
├── config/
│   ├── jwt/                    # Clés JWT
│   ├── packages/
│   │   ├── api_platform.yaml   # Configuration API Platform
│   │   ├── security.yaml       # Configuration sécurité
│   │   └── lexik_jwt_authentication.yaml
├── src/
│   ├── Controller/
│   │   └── AuthController.php  # Contrôleur d'authentification
│   ├── Entity/
│   │   ├── User.php           # Entité utilisateur
│   │   └── Role.php           # Entité rôle
│   ├── Repository/
│   └── DataFixtures/
│       └── AppFixtures.php    # Données de test
├── migrations/
│   └── Version20241221000000.php
└── var/
    └── data.db                # Base de données SQLite
```

## 🧪 Tests

Pour tester l'API, vous pouvez utiliser :

1. **Postman** ou **Insomnia**
2. **cURL** en ligne de commande
3. **L'interface API Platform** : `http://localhost:8000/api`

### Exemple avec cURL

```bash
# Inscription
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User"
  }'

# Connexion
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "admin123"
  }'

# Accéder au profil (avec le token reçu)
curl -X GET http://localhost:8000/api/auth/profile \
  -H "Authorization: Bearer <jwt_token>"
```

## 🚀 Déploiement

Pour la production, n'oubliez pas de :

1. **Changer les clés JWT** avec des clés sécurisées
2. **Configurer une base de données** PostgreSQL ou MySQL
3. **Définir les variables d'environnement** appropriées
4. **Configurer HTTPS**
5. **Optimiser les performances** (cache, etc.)

## 📝 Licence

Ce projet est sous licence propriétaire.

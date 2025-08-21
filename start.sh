#!/bin/bash

echo "🚀 Démarrage de l'API Platform - Système d'authentification"
echo "=========================================================="

# Vérifier si PHP est installé
if ! command -v php &> /dev/null; then
    echo "❌ PHP n'est pas installé. Veuillez installer PHP 8.2+"
    exit 1
fi

# Vérifier si Composer est installé
if ! command -v composer &> /dev/null; then
    echo "❌ Composer n'est pas installé. Veuillez installer Composer"
    exit 1
fi

echo "✅ PHP et Composer sont installés"

# Installer les dépendances si nécessaire
if [ ! -d "vendor" ]; then
    echo "📦 Installation des dépendances..."
    composer install
fi

# Créer la base de données SQLite si elle n'existe pas
if [ ! -f "var/data.db" ]; then
    echo "🗄️  Création de la base de données SQLite..."
    touch var/data.db
fi

# Exécuter les migrations
echo "🔄 Exécution des migrations..."
DATABASE_URL="sqlite:///var/data.db" \
APP_SECRET="test_secret" \
JWT_SECRET_KEY="config/jwt/private.pem" \
JWT_PUBLIC_KEY="config/jwt/public.pem" \
JWT_PASSPHRASE="" \
CORS_ALLOW_ORIGIN="^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?$" \
php bin/console doctrine:migrations:migrate --no-interaction

# Charger les fixtures si la base est vide
echo "📊 Chargement des données de test..."
DATABASE_URL="sqlite:///var/data.db" \
APP_SECRET="test_secret" \
JWT_SECRET_KEY="config/jwt/private.pem" \
JWT_PUBLIC_KEY="config/jwt/public.pem" \
JWT_PASSPHRASE="" \
CORS_ALLOW_ORIGIN="^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?$" \
php bin/console doctrine:fixtures:load --no-interaction

# Vider le cache
echo "🧹 Nettoyage du cache..."
DATABASE_URL="sqlite:///var/data.db" \
APP_SECRET="test_secret" \
JWT_SECRET_KEY="config/jwt/private.pem" \
JWT_PUBLIC_KEY="config/jwt/public.pem" \
JWT_PASSPHRASE="" \
CORS_ALLOW_ORIGIN="^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?$" \
php bin/console cache:clear

echo "✅ Configuration terminée !"
echo ""
echo "🔐 Utilisateurs de test créés :"
echo "   👤 Admin: admin@example.com / admin123"
echo "   👤 User: user@example.com / user123"
echo ""
echo "🌐 Pour démarrer le serveur :"
echo "   symfony server:start"
echo "   ou"
echo "   php -S localhost:8000 -t public"
echo ""
echo "📚 Documentation complète dans README.md"
echo "🔗 Interface API Platform: http://localhost:8000/api"

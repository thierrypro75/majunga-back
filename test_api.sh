#!/bin/bash

echo "🧪 Test de l'API d'authentification"
echo "=================================="

# URL de base
BASE_URL="http://localhost:8000"

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les résultats
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

# Test 1: Vérifier que le serveur répond
echo "1. Test de connexion au serveur..."
if curl -s "$BASE_URL" > /dev/null; then
    print_result 0 "Serveur accessible"
else
    print_result 1 "Serveur inaccessible - Assurez-vous que le serveur est démarré"
    exit 1
fi

# Test 2: Test d'inscription
echo "2. Test d'inscription d'un nouvel utilisateur..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "test@example.com",
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    }')

if echo "$REGISTER_RESPONSE" | grep -q "Utilisateur créé avec succès"; then
    print_result 0 "Inscription réussie"
    # Extraire le token JWT
    TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
else
    print_result 1 "Échec de l'inscription"
    echo "Réponse: $REGISTER_RESPONSE"
fi

# Test 3: Test de connexion
echo "3. Test de connexion..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "admin@example.com",
        "password": "admin123"
    }')

if echo "$LOGIN_RESPONSE" | grep -q "Connexion réussie"; then
    print_result 0 "Connexion réussie"
    # Extraire le token JWT admin
    ADMIN_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
else
    print_result 1 "Échec de la connexion"
    echo "Réponse: $LOGIN_RESPONSE"
fi

# Test 4: Test d'accès au profil (avec token)
echo "4. Test d'accès au profil..."
if [ ! -z "$ADMIN_TOKEN" ]; then
    PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/api/auth/profile" \
        -H "Authorization: Bearer $ADMIN_TOKEN")
    
    if echo "$PROFILE_RESPONSE" | grep -q "admin@example.com"; then
        print_result 0 "Accès au profil réussi"
    else
        print_result 1 "Échec d'accès au profil"
        echo "Réponse: $PROFILE_RESPONSE"
    fi
else
    print_result 1 "Token manquant pour le test de profil"
fi

# Test 5: Test d'accès à l'API des utilisateurs (admin)
echo "5. Test d'accès à l'API des utilisateurs (admin)..."
if [ ! -z "$ADMIN_TOKEN" ]; then
    USERS_RESPONSE=$(curl -s -X GET "$BASE_URL/api/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN")
    
    if echo "$USERS_RESPONSE" | grep -q "hydra:member"; then
        print_result 0 "Accès à l'API des utilisateurs réussi"
    else
        print_result 1 "Échec d'accès à l'API des utilisateurs"
        echo "Réponse: $USERS_RESPONSE"
    fi
else
    print_result 1 "Token admin manquant"
fi

# Test 6: Test d'accès à l'API des rôles (admin)
echo "6. Test d'accès à l'API des rôles (admin)..."
if [ ! -z "$ADMIN_TOKEN" ]; then
    ROLES_RESPONSE=$(curl -s -X GET "$BASE_URL/api/roles" \
        -H "Authorization: Bearer $ADMIN_TOKEN")
    
    if echo "$ROLES_RESPONSE" | grep -q "hydra:member"; then
        print_result 0 "Accès à l'API des rôles réussi"
    else
        print_result 1 "Échec d'accès à l'API des rôles"
        echo "Réponse: $ROLES_RESPONSE"
    fi
else
    print_result 1 "Token admin manquant"
fi

# Test 7: Test d'accès sans authentification (doit échouer)
echo "7. Test d'accès sans authentification (doit échouer)..."
UNAUTH_RESPONSE=$(curl -s -X GET "$BASE_URL/api/users")
if echo "$UNAUTH_RESPONSE" | grep -q "401\|401\|Unauthorized"; then
    print_result 0 "Accès non authentifié correctement refusé"
else
    print_result 1 "Accès non authentifié autorisé (problème de sécurité)"
fi

echo ""
echo -e "${YELLOW}📊 Résumé des tests :${NC}"
echo "=================================="
echo "🔗 Interface API Platform: $BASE_URL/api"
echo "📚 Documentation: README.md"
echo ""
echo -e "${GREEN}✅ Tests terminés !${NC}"
echo ""
echo "Pour tester manuellement :"
echo "1. Ouvrez $BASE_URL/api dans votre navigateur"
echo "2. Utilisez Postman ou cURL avec les endpoints documentés"
echo "3. Connectez-vous avec admin@example.com / admin123"

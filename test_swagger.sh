#!/bin/bash

echo "🧪 Test de l'accès à Swagger/OpenAPI"
echo "===================================="

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

echo "🔍 Vérification des endpoints Swagger/OpenAPI..."

# Test 1: Documentation HTML (Swagger UI)
echo "1. Test de l'interface Swagger HTML..."
SWAGGER_HTML=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/docs.html")
if [ "$SWAGGER_HTML" = "200" ]; then
    print_result 0 "Interface Swagger HTML accessible"
    echo "   URL: $BASE_URL/api/docs.html"
else
    print_result 1 "Interface Swagger HTML non accessible (HTTP $SWAGGER_HTML)"
fi

# Test 2: Documentation JSON-LD
echo "2. Test de la documentation JSON-LD..."
JSONLD=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/docs.jsonld")
if [ "$JSONLD" = "200" ]; then
    print_result 0 "Documentation JSON-LD accessible"
    echo "   URL: $BASE_URL/api/docs.jsonld"
else
    print_result 1 "Documentation JSON-LD non accessible (HTTP $JSONLD)"
fi

# Test 3: Documentation OpenAPI JSON
echo "3. Test de la documentation OpenAPI JSON..."
OPENAPI=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/docs.jsonopenapi")
if [ "$OPENAPI" = "200" ]; then
    print_result 0 "Documentation OpenAPI JSON accessible"
    echo "   URL: $BASE_URL/api/docs.jsonopenapi"
else
    print_result 1 "Documentation OpenAPI JSON non accessible (HTTP $OPENAPI)"
fi

# Test 4: Entrypoint API
echo "4. Test de l'entrypoint API..."
ENTRYPOINT=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api")
if [ "$ENTRYPOINT" = "200" ]; then
    print_result 0 "Entrypoint API accessible"
    echo "   URL: $BASE_URL/api"
else
    print_result 1 "Entrypoint API non accessible (HTTP $ENTRYPOINT)"
fi

echo ""
echo -e "${YELLOW}📊 Résumé des tests Swagger :${NC}"
echo "===================================="
echo "🔗 Interface Swagger UI: $BASE_URL/api/docs.html"
echo "📄 Documentation JSON-LD: $BASE_URL/api/docs.jsonld"
echo "📋 Documentation OpenAPI: $BASE_URL/api/docs.jsonopenapi"
echo "🚪 Entrypoint API: $BASE_URL/api"
echo ""
echo "💡 Si les tests échouent, assurez-vous que :"
echo "   1. Le serveur est démarré (php -S localhost:8000 -t public)"
echo "   2. La base de données est créée et les migrations sont exécutées"
echo "   3. Les entités sont chargées dans la base de données"
echo ""
echo -e "${GREEN}✅ Tests terminés !${NC}"

#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "🧪 Probando devOps-test API..."
echo ""

# Verificar que la imagen existe
if ! docker image inspect devops-test:latest > /dev/null 2>&1; then
    echo -e "${RED}❌ Imagen devops-test:latest no encontrada${NC}"
    echo "Ejecuta './deploy.sh' primero"
    exit 1
fi

# Iniciar contenedor temporal para pruebas
echo "Iniciando contenedor de prueba..."
docker run -d --name devops-test-temp -p 3001:3000 devops-test:latest

sleep 3

# Contador de tests
PASSED=0
FAILED=0

# Test 1: Endpoint /
echo "Test 1: Endpoint /"
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/)
if [ $response -eq 200 ]; then
    echo -e "${GREEN}✅ Test / PASADO${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ Test / FALLADO (HTTP $response)${NC}"
    FAILED=$((FAILED+1))
fi

# Test 2: Endpoint /health
echo "Test 2: Endpoint /health"
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health)
if [ $response -eq 200 ]; then
    echo -e "${GREEN}✅ Test /health PASADO${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ Test /health FALLADO (HTTP $response)${NC}"
    FAILED=$((FAILED+1))
fi

# Test 3: Endpoint /ready
echo "Test 3: Endpoint /ready"
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/ready)
if [ $response -eq 200 ]; then
    echo -e "${GREEN}✅ Test /ready PASADO${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ Test /ready FALLADO (HTTP $response)${NC}"
    FAILED=$((FAILED+1))
fi

# Test 4: Verificar respuesta JSON en /health
echo "Test 4: Validar JSON response en /health"
json_response=$(curl -s http://localhost:3001/health)
if echo "$json_response" | grep -q "healthy" && echo "$json_response" | grep -q "timestamp"; then
    echo -e "${GREEN}✅ Test JSON response PASADO${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ Test JSON response FALLADO${NC}"
    FAILED=$((FAILED+1))
fi

# Test 5: Verificar proyecto en endpoint /
echo "Test 5: Validar project name en /"
json_response=$(curl -s http://localhost:3001/)
if echo "$json_response" | grep -q "devOps-test"; then
    echo -e "${GREEN}✅ Test project name PASADO${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ Test project name FALLADO${NC}"
    FAILED=$((FAILED+1))
fi

# Limpiar
docker stop devops-test-temp > /dev/null 2>&1
docker rm devops-test-temp > /dev/null 2>&1

echo ""
echo "==================================="
echo "📊 Resultados: $PASSED/$((PASSED+FAILED)) tests pasaron"
echo "==================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Todos los tests pasaron exitosamente!${NC}"
    exit 0
else
    echo -e "${RED}❌ Algunos tests fallaron${NC}"
    exit 1
fi

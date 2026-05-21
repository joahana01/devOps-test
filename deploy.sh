#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🚀 Desplegando devOps-test con Docker..."

# Construir imagen
echo "📦 Construyendo imagen Docker..."
docker build -t devops-test:latest .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error construyendo la imagen${NC}"
    exit 1
fi

# Detener contenedor anterior si existe
echo "🛑 Deteniendo contenedor anterior..."
docker stop devops-test 2>/dev/null || true
docker rm devops-test 2>/dev/null || true

# Ejecutar nuevo contenedor
echo "▶️  Iniciando nuevo contenedor..."
docker run -d \
  --name devops-test \
  --restart unless-stopped \
  -p 3000:3000 \
  -e ENVIRONMENT=production \
  devops-test:latest

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error ejecutando el contenedor${NC}"
    exit 1
fi

# Esperar a que inicie
sleep 3

# Verificar salud
echo "🔍 Verificando healthcheck..."
if curl -f http://localhost:3000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Despliegue exitoso!${NC}"
    echo ""
    echo "🌐 API disponible en: http://localhost:3000"
    echo ""
    echo "📝 Endpoints disponibles:"
    echo "   - http://localhost:3000/"
    echo "   - http://localhost:3000/health"
    echo "   - http://localhost:3000/ready"
    echo ""
    echo "📊 Ver logs: docker logs devops-test"
    echo "🛑 Detener: docker stop devops-test"
else
    echo -e "${RED}❌ Error: El contenedor no responde al healthcheck${NC}"
    echo ""
    echo "📋 Logs del contenedor:"
    docker logs devops-test
    exit 1
fi

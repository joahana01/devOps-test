##  Descripción
API desarrollada en **Python con FastAPI** que implementa un pipeline CI/CD completo con GitHub Actions y Docker.

### Tecnologías utilizadas
- Python 3.11 + FastAPI
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Docker Hub (Registry)

---

##  Correr localmente

   chmod +x deploy.sh

# Ejecutar deploy
   ./deploy.sh

### Requisitos previos
- Docker instalado
- (Opcional) Python 3.11 para pruebas locales

### Opción 1: Usando Docker

```bash
# Clonar el repositorio
git clone https://github.com/joahana01/devOps-test.git
cd devOps-test

# Construir la imagen
docker build -t devops-test:latest .

# Ejecutar el contenedor
docker run -d \
  --name devops-test \
  --restart unless-stopped \
  -p 3000:3000 \
  -e ENVIRONMENT=production \
  devops-test:latest

# Verificar que está corriendo
docker ps

# Probar la API
# Health check
curl http://localhost:3000/health

# Endpoint principal
curl http://localhost:3000/

# Readiness
curl http://localhost:3000/ready


#Monitoreo básico
## Ver uso de recursos
docker stats devops-test

# Ver información detallada
docker inspect devops-test

# Ver logs de healthcheck
docker inspect devops-test | grep -A 5 Health

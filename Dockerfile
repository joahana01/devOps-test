FROM python:3.11-slim

WORKDIR /app

# Copiar y instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY app.py .

# Crear usuario no-root para seguridad
RUN addgroup --system --gid 1001 appuser && \
    adduser --system --uid 1001 --gid 1001 appuser

USER appuser

EXPOSE 3000

# Healthcheck para monitoreo
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:3000/health')"

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3000"]

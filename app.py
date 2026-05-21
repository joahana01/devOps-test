from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI(title="DevOps Test API", version="1.0.0")

@app.get("/")
def root():
    return {
        "message": "API funcionando correctamente",
        "status": "ok",
        "service": "Python FastAPI",
        "project": "devOps-test",
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

@app.get("/ready")
def ready():
    return {"status": "ready"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 3000))
    uvicorn.run(app, host="0.0.0.0", port=port)

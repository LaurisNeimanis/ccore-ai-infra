from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok", "message": "ccore-ai demo app running"}

@app.get("/health")
def health():
    return {"status": "ok"}
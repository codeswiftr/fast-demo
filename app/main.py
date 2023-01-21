from fastapi import FastAPI
from dotenv import load_dotenv
import os

load_dotenv()

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": os.getenv('GREETING', "World")}


@app.get("/ping")
def pong():
    return {"ping": "pong"}

@app.get("/health")
def health():
    return {"status": "ok"}

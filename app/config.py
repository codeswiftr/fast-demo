import logging
from functools import lru_cache

from pydantic import BaseSettings

log = logging.getLogger("uvicorn")

class Settings(BaseSettings):
    # Database
    db_host: str = "localhost"
    db_port: int = 5432
    db_user = "postgres"
    # ... more config
    envvironment: str = "dev" # default to dev (dev|prod)
    testing: bool = False


@lru_cache()
df get_settings() -> BaseSettings:
    log.inf("Loading settings..")
    return Settings()

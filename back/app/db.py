from collections.abc import Generator

from sqlmodel import Session, SQLModel, create_engine, select

from .settings import settings


engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    pool_recycle=1800,
    # Safety net: if application code ever hangs after a commit while still holding
    # the session open (a slow/blocking external call with no timeout, a missed
    # session close, etc.), Postgres itself kills the connection instead of it
    # sitting "idle in transaction" forever and slowly starving the pool — this is
    # exactly how two real outages happened (pool exhausted by stuck connections).
    connect_args={"options": "-c idle_in_transaction_session_timeout=60000"},
)


def create_db_and_tables() -> None:
    SQLModel.metadata.create_all(engine)


def get_session() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session


def check_db_connection() -> None:
    """
    Raises if the DB is not reachable or credentials/DB name are wrong.
    """
    with Session(engine) as session:
        session.exec(select(1)).first()


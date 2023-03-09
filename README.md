Set up your development environment:
Set up a Postgres database instance using Docker Compose.
Install the necessary Python packages: FastAPI, SQLAlchemy, Pytest, and any other dependencies.
Define your database schema:
Identify the entities in your system and the relationships between them.
Use SQLAlchemy to define the tables, columns, and relationships in your database.
Implement the model layer:
Use SQLAlchemy's ORM (Object-Relational Mapping) to map the database schema to Python objects.
Define the models for each entity in your system, including any necessary relationships and data validations.
Implement the API endpoints:
Use FastAPI to define the routes and request/response models for your API.
Implement the logic for each endpoint using the models and database functions defined in the previous steps.
Write tests for your API:
Use Pytest to write unit tests for each endpoint.
Set up test fixtures for the database and other dependencies.
Implement test-driven development (TDD):
Follow the TDD cycle of writing a failing test, writing code to make the test pass, and refactoring as needed.
Use Pytest to run your tests regularly as you develop the API.
Deploy your API:
Use Docker Compose to build and run the API in a production-like environment.
Set up a CI/CD pipeline to automate the build, test, and deployment process.

# Prerequisites

- Install Docker and Docker Compose on your machine.
- Make sure you have properly configured the .env file

# Build images
```bash
make build
```

```bash
make push
```

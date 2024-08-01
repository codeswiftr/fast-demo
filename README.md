@startuml
entity "Venue" {
  * id : int
  * name : string
  * location : string
  * capacity : int
}

entity "Request" {
  * id : int
  * method : string
  * endpoint : string
  * body : json
}

entity "Response" {
  * status_code : int
  * body : json
}

Request --> Venue : Create
Venue --> Response : Created

Request --> Venue : Read
Venue --> Response : Retrieved

Request --> Venue : Update
Venue --> Response : Updated

Request --> Venue : Delete
Venue --> Response : Deleted
@enduml

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

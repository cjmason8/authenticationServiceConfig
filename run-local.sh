#!/bin/bash

DB_DRIVER=org.postgresql.Driver
DB_PASS=postgres
DB_URL=jdbc:postgresql://localhost:5432/authservice
DB_USER=postgres
HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
HIBERNATE_HBM2DDL_AUTO=update

export DB_DRIVER
export DB_PASS
export DB_URL
export DB_USER
export HIBERNATE_DIALECT
export HIBERNATE_HBM2DDL_AUTO

mvn clean install
mvn -Dserver.port=8082 spring-boot:run


CREATE SCHEMA IF NOT EXISTS dev;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS production;

-- Documentation des schemas
COMMENT ON SCHEMA dev IS 'Environnement de developpement local - Sprint 0';
COMMENT ON SCHEMA staging IS 'Environnement de pre-production/test - Sprint 0';
COMMENT ON SCHEMA production IS 'Environnement de production - Sprint 0';

-- Table de suivi des migrations (dans chaque schema)
CREATE TABLE IF NOT EXISTS dev.schema_version (
    version VARCHAR(50) PRIMARY KEY,
    description TEXT,
    script_name VARCHAR(255),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    executed_by VARCHAR(100) DEFAULT CURRENT_USER,
    success BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS staging.schema_version (
    version VARCHAR(50) PRIMARY KEY,
    description TEXT,
    script_name VARCHAR(255),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    executed_by VARCHAR(100) DEFAULT CURRENT_USER,
    success BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS production.schema_version (
    version VARCHAR(50) PRIMARY KEY,
    description TEXT,
    script_name VARCHAR(255),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    executed_by VARCHAR(100) DEFAULT CURRENT_USER,
    success BOOLEAN DEFAULT TRUE
);

-- Enregistrer cette migration
INSERT INTO dev.schema_version (version, description, script_name) 
VALUES ('1.0', 'Initialisation des schemas', 'V1.0__2026-02-05__init_schemas.sql');

INSERT INTO staging.schema_version (version, description, script_name) 
VALUES ('1.0', 'Initialisation des schemas', 'V1.0__2026-02-05__init_schemas.sql');

INSERT INTO production.schema_version (version, description, script_name) 
VALUES ('1.0', 'Initialisation des schemas', 'V1.0__2026-02-05__init_schemas.sql');
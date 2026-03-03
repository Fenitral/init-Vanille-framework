-- ============================================
-- Migration V1.2 - Configuration des permissions
-- Date: 2026-01-28
-- Sprint: 0
-- ============================================

-- Créer les utilisateurs pour chaque environnement
DO $$
BEGIN
    -- Utilisateur DEV
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'dev_user') THEN
        CREATE ROLE dev_user WITH LOGIN PASSWORD 'dev_pass_123';
    END IF;
    
    -- Utilisateur STAGING
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'staging_user') THEN
        CREATE ROLE staging_user WITH LOGIN PASSWORD 'staging_pass_456';
    END IF;
    
    -- Utilisateur PRODUCTION
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'prod_user') THEN
        CREATE ROLE prod_user WITH LOGIN PASSWORD 'prod_pass_789';
    END IF;
END $$;

-- Accorder les permissions DEV (toutes les permissions)
GRANT ALL PRIVILEGES ON SCHEMA dev TO dev_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA dev TO dev_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA dev TO dev_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA dev GRANT ALL ON TABLES TO dev_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA dev GRANT ALL ON SEQUENCES TO dev_user;

-- Accorder les permissions STAGING
GRANT ALL PRIVILEGES ON SCHEMA staging TO staging_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA staging TO staging_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA staging TO staging_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT ALL ON TABLES TO staging_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT ALL ON SEQUENCES TO staging_user;

-- Accorder les permissions PRODUCTION (plus restrictives)
GRANT USAGE ON SCHEMA production TO prod_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA production TO prod_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA production TO prod_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA production GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO prod_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA production GRANT USAGE, SELECT ON SEQUENCES TO prod_user;

-- Insérer les rôles par défaut dans chaque schéma
INSERT INTO dev.roles (role_name, description) VALUES 
    ('ADMIN', 'Administrateur avec tous les droits'),
    ('MANAGER', 'Gestionnaire avec droits de modification'),
    ('USER', 'Utilisateur standard avec droits de lecture'),
    ('GUEST', 'Invité avec accès limité');

INSERT INTO staging.roles (role_name, description) VALUES 
    ('ADMIN', 'Administrateur avec tous les droits'),
    ('MANAGER', 'Gestionnaire avec droits de modification'),
    ('USER', 'Utilisateur standard avec droits de lecture'),
    ('GUEST', 'Invité avec accès limité');

INSERT INTO production.roles (role_name, description) VALUES 
    ('ADMIN', 'Administrateur avec tous les droits'),
    ('MANAGER', 'Gestionnaire avec droits de modification'),
    ('USER', 'Utilisateur standard avec droits de lecturce'),
    ('GUEST', 'Invité avec accès limité');

-- Enregistrer la migration
INSERT INTO dev.schema_version (version, description, script_name) 
VALUES ('1.2', 'Configuration des permissions et rôles', 'V1.2__2026-02-05__setup_permissions.sql');
INSERT INTO staging.schema_version (version, description, script_name) 
VALUES ('1.2', 'Configuration des permissions et rôles', 'V1.2__2026-02-05__setup_permissions.sql');

INSERT INTO production.schema_version (version, description, script_name) 
VALUES ('1.2', 'Configuration des permissions et rôles', 'V1.2__2026-02-05__setup_permissions.sql');
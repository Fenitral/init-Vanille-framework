-- ============================================
-- Migration V1.1 - Création des tables de base
-- Date: 2026-01-28
-- Sprint: 0
-- ============================================

-- Fonction pour créer les tables dans tous les schémas
DO $$
DECLARE
    schema_name TEXT;
BEGIN
    FOREACH schema_name IN ARRAY ARRAY['dev', 'staging', 'production']
    LOOP
        -- Table Users (pour BackOffice - authentification)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.users (
                id SERIAL PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                email VARCHAR(150) UNIQUE NOT NULL,
                role VARCHAR(50) NOT NULL DEFAULT ''user'',
                is_active BOOLEAN DEFAULT TRUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table Roles (pour BackOffice)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.roles (
                id SERIAL PRIMARY KEY,
                role_name VARCHAR(50) UNIQUE NOT NULL,
                description TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table User_Roles (relation many-to-many)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.user_roles (
                user_id INTEGER REFERENCES %I.users(id) ON DELETE CASCADE,
                role_id INTEGER REFERENCES %I.roles(id) ON DELETE CASCADE,
                assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (user_id, role_id)
            )', schema_name, schema_name, schema_name);

        -- Table Client (pour FrontOffice - publique)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.client (
                id SERIAL PRIMARY KEY,
                nom VARCHAR(100) NOT NULL,
                prenom VARCHAR(100) NOT NULL,
                email VARCHAR(150) UNIQUE,
                telephone VARCHAR(20),
                adresse TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table Hotel
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.hotel (
                id SERIAL PRIMARY KEY,
                nom VARCHAR(150) NOT NULL,
                adresse TEXT NOT NULL,
                ville VARCHAR(100),
                code_postal VARCHAR(10),
                telephone VARCHAR(20),
                email VARCHAR(150),
                nombre_chambres INTEGER,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table Vehicule
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.vehicule (
                id SERIAL PRIMARY KEY,
                immatriculation VARCHAR(20) UNIQUE NOT NULL,
                marque VARCHAR(50),
                modele VARCHAR(50),
                capacite INTEGER NOT NULL,
                type_carburant VARCHAR(50) NOT NULL CHECK (type_carburant IN (''Essence'', ''Diesel'', ''Hybride'', ''Electrique'')),
                consommation_km DECIMAL(5,2),
                disponible BOOLEAN DEFAULT TRUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table Parcours
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.parcours (
                id SERIAL PRIMARY KEY,
                depart VARCHAR(150) NOT NULL,
                destination VARCHAR(150) NOT NULL,
                distance_km DECIMAL(10,2) NOT NULL,
                duree_estimee_minutes INTEGER,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name);

        -- Table Reservation
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.reservation (
                id SERIAL PRIMARY KEY,
                client_id INTEGER REFERENCES %I.client(id) ON DELETE CASCADE,
                hotel_id INTEGER REFERENCES %I.hotel(id),
                vehicule_id INTEGER,
                nombre_personnes INTEGER NOT NULL CHECK (nombre_personnes > 0),
                date_reservation DATE NOT NULL,
                heure_depart TIME,
                statut VARCHAR(50) DEFAULT ''en_attente'' CHECK (statut IN (''en_attente'', ''confirmee'', ''en_cours'', ''terminee'', ''annulee'')),
                montant_total DECIMAL(10,2),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )', schema_name, schema_name, schema_name);

        -- Table Assignation (véhicule assigné à une réservation)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.assignation (
                id SERIAL PRIMARY KEY,
                reservation_id INTEGER REFERENCES %I.reservation(id) ON DELETE CASCADE,
                vehicule_id INTEGER REFERENCES %I.vehicule(id),
                parcours_id INTEGER REFERENCES %I.parcours(id),
                date_assignation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                statut VARCHAR(50) DEFAULT ''assignee'',
                UNIQUE(reservation_id)
            )', schema_name, schema_name, schema_name, schema_name);

        -- Enregistrer la migration
        EXECUTE format('
            INSERT INTO %I.schema_version (version, description, script_name) 
            VALUES (''1.1'', ''Création des tables de base'', ''V1.1__2026-01-28__create_base_tables.sql'')
        ', schema_name);

    END LOOP;
END $$;
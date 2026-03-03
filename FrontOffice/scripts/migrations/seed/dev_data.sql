-- ============================================
-- Données de test pour DEV
-- Date: 2026-01-28
-- ============================================

-- Utilisateur admin pour le BackOffice
INSERT INTO dev.users (username, password, email, role) VALUES
    ('admin', 'admin', 'admin@test.com', 'ADMIN'),  -- mot de passe hashé
    ('manager', 'manager', 'manager@test.com', 'MANAGER'),
    ('user', 'user', 'user@test.com', 'USER');

-- Clients de test
INSERT INTO dev.client (nom, prenom, email, telephone) VALUES
    ('Rakoto', 'Jean', 'jean.rakoto@email.com', '0340123456'),
    ('Ravelo', 'Marie', 'marie.ravelo@email.com', '0341234567'),
    ('Rabe', 'Pierre', 'pierre.rabe@email.com', '0342345678');

-- Hôtels de test
INSERT INTO dev.hotel (nom, adresse, ville, telephone, nombre_chambres) VALUES
    ('Hotel Ivandry', 'Ivandry', 'Antananarivo', '0340111222', 50),
    ('Hotel Ankorondrano', 'Ankorondrano', 'Antananarivo', '0340222333', 30),
    ('Hotel Antsirabe', 'Centre Ville', 'Antsirabe', '0340333444', 40);

-- Véhicules de test
INSERT INTO dev.vehicule (immatriculation, marque, modele, capacite, type_carburant, consommation_km) VALUES
    ('1234 TAA', 'Toyota', 'Hiace', 15, 'Diesel', 8.5),
    ('5678 TAB', 'Mercedes', 'Sprinter', 20, 'Diesel', 9.2),
    ('9012 TAC', 'Ford', 'Transit', 12, 'Essence', 10.5);

-- Parcours de test
INSERT INTO dev.parcours (depart, destination, distance_km, duree_estimee_minutes) VALUES
    ('Antananarivo', 'Antsirabe', 170, 180),
    ('Antananarivo', 'Toamasina', 350, 420),
    ('Antsirabe', 'Morondava', 420, 540);
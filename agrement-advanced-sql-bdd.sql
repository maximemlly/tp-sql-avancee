USE `advanced_sql`;

-- 1. Enrichissement de `categories` (générera les IDs 7 à 9)[cite: 1]
INSERT INTO `categories` (`nom`, `marge_cible`) VALUES
('Intelligence Artificielle & GPU', 0.28),
('Téléphonie & Visioconférence', 0.33),
('Sauvegarde & Archivage', 0.26);

-- 2. Enrichissement de `entrepots` (générera les IDs 5 à 6)[cite: 1]
INSERT INTO `entrepots` (`nom`, `ville`, `capacite_m3`) VALUES
('Lille-Nord', 'Lille', 3800),
('Bordeaux-Atlantique', 'Bordeaux', 3400);

-- 3. Enrichissement de `clients` (générera les IDs 25 à 30)[cite: 1]
INSERT INTO `clients` (`nom`, `email`, `ville`, `segment`, `date_inscription`) VALUES
('Valentin Marchand', 'valentin.marchand@orleans-it.fr', 'Orléans', 'PME', '2026-02-11'),
('Élodie Carpentier', 'elodie.carpentier@stras-cloud.fr', 'Strasbourg', 'Entreprise', '2026-03-19'),
('Maxime Meyer', 'maxime.meyer@luxdata.fr', 'Paris', 'Grand Compte', '2026-04-07'),
('Mélanie Roche', 'melanie.roche@alpine-ai.fr', 'Grenoble', 'Startup', '2026-05-28'),
('Sébastien Colin', 'sebastien.colin@oceanic-si.fr', 'Bordeaux', 'Entreprise', '2026-07-14'),
('Laura Vidal', 'laura.vidal@medit-tech.fr', 'Marseille', 'Grand Compte', '2026-09-02');

-- 4. Enrichissement de `produits` (générera les IDs 25 à 32)[cite: 1]
INSERT INTO `produits` (`nom`, `categorie_id`, `prix_unitaire`, `stock`, `entrepot_id`) VALUES
('Serveur IA 4x GPU H100', 7, 14500.00, 5, 2),
('Carte Accélératrice Tensor 80Go', 7, 4200.00, 12, 2),
('Barre Visio Tout-en-Un 4K', 8, 980.00, 29, 1),
('Téléphone IP PoE Gigabit', 8, 165.00, 140, 5),
('Robot Bande LTO-9 24 Slots', 9, 4850.00, 9, 6),
('Cartouche LTO-9 18To', 9, 115.00, 250, 6),
('Switch Core 100GbE 32P', 2, 5400.00, 11, 2),
('Licence Orchestration Kubernetes', 5, 2200.00, 999, 2);

-- 5. Enrichissement de `employes` (générera les IDs 13 à 18)[cite: 1]
INSERT INTO `employes` (`nom`, `poste`, `manager_id`, `departement`, `salaire`) VALUES
('Laurent Mercier', 'VP Cybersécurité & Cloud', 1, 'Sécurité', 75000.00),
('Céline Dumas', 'Lead Pentester & Audit', 13, 'Sécurité', 63000.00),
('Damien Charpentier', 'Ingénieur DevSecOps', 13, 'Sécurité', 58000.00),
('Mathilde Perrot', 'Analyste SOC Junior', 14, 'Sécurité', 41000.00),
('Hugo Barbier', 'Data Scientist IA', 5, 'Data', 54000.00),
('Manon Lemoine', 'Administratrice Stockage SAN', 7, 'Infra', 46000.00);

-- 6. Enrichissement de `comptes_bancaires` (générera les IDs 5 à 8)[cite: 1]
INSERT INTO `comptes_bancaires` (`titulaire`, `solde`, `statut`) VALUES
('SysCore Infrastructure', 48000.00, 'ACTIF'),
('MedData Santé', 19200.00, 'ACTIF'),
('Kapsul Studio', 450.00, 'BLOQUE'),
('Quantis Finance', 65000.00, 'ACTIF');

-- 7. Enrichissement de `nosql_store` (clé primaire sur collection_name)[cite: 1]
INSERT INTO `nosql_store` (`collection_name`, `payload`) VALUES
('audit_logs_securite', '[
  {"event_id": "evt_901", "timestamp": "2026-11-18T08:12:44Z", "acteur": "Antoine Renaud", "action": "ALTER_INDEX", "cible": "commandes", "succes": true},
  {"event_id": "evt_902", "timestamp": "2026-11-18T09:45:10Z", "acteur": "inconnu", "ip": "185.220.101.4", "action": "LOGIN_FAILED", "tentatives": 14, "succes": false},
  {"event_id": "evt_903", "timestamp": "2026-11-19T14:20:05Z", "acteur": "Céline Dumas", "action": "REVOKE_PRIVILEGES", "cible": "user_readonly", "succes": true}
]'),
('factures_metadata', '[
  {"commande_id": 24, "numero_facture": "FAC-2026-0024", "tva_taux": 20.0, "mode_paiement": "Virement SEPA", "delai_reglement_jours": 30, "relances": 0},
  {"commande_id": 26, "numero_facture": "FAC-2026-0026", "tva_taux": 20.0, "mode_paiement": "Prélèvement", "delai_reglement_jours": 45, "relances": 0},
  {"commande_id": 31, "numero_facture": "FAC-2026-0031", "tva_taux": 20.0, "mode_paiement": "Virement SEPA", "delai_reglement_jours": 30, "relances": 2}
]');

-- 8. Peuplement complet de `commandes` (générera les IDs 1 à 32)[cite: 1]
INSERT INTO `commandes` (`client_id`, `date_commande`, `montant_total`, `statut`) VALUES
(1, '2024-02-10 10:15:00', 3570.00, 'LIVREE'),
(2, '2024-03-04 14:30:00', 7020.00, 'LIVREE'),
(3, '2024-04-12 09:20:00', 1650.00, 'LIVREE'),
(4, '2024-05-22 16:45:00', 2780.00, 'LIVREE'),
(6, '2024-06-18 11:05:00', 11670.00, 'LIVREE'),
(1, '2024-07-29 15:10:00', 1740.00, 'LIVREE'),
(5, '2024-08-14 10:00:00', 1340.00, 'ANNULEE'),
(9, '2024-09-09 17:25:00', 5400.00, 'LIVREE'),
(2, '2024-10-21 08:50:00', 4360.00, 'LIVREE'),
(7, '2024-11-15 13:40:00', 2250.00, 'LIVREE'),
(12, '2024-12-03 16:00:00', 8900.00, 'LIVREE'),
(1, '2025-01-19 11:30:00', 4900.00, 'LIVREE'),
(6, '2025-02-25 14:15:00', 6540.00, 'LIVREE'),
(15, '2025-03-14 09:45:00', 3300.00, 'LIVREE'),
(2, '2025-04-08 15:50:00', 9800.00, 'LIVREE'),
(8, '2025-05-19 10:20:00', 1470.00, 'ANNULEE'),
(17, '2025-06-11 16:10:00', 7780.00, 'LIVREE'),
(10, '2025-07-23 12:05:00', 2840.00, 'LIVREE'),
(20, '2025-08-30 17:00:00', 12250.00, 'LIVREE'),
(11, '2025-09-17 09:10:00', 3360.00, 'LIVREE'),
(9, '2025-10-28 14:40:00', 4170.00, 'LIVREE'),
(14, '2025-11-12 11:55:00', 1350.00, 'REMBOURSEE'),
(23, '2025-12-19 15:30:00', 5800.00, 'LIVREE'),
(1, '2026-01-22 10:05:00', 6120.00, 'LIVREE'),
(24, '2026-02-14 14:20:00', 2180.00, 'LIVREE'),
(2, '2026-03-30 16:45:00', 8400.00, 'LIVREE'),
(25, '2026-04-18 11:10:00', 1960.00, 'LIVREE'),
(27, '2026-06-05 15:40:00', 14500.00, 'LIVREE'),
(29, '2026-08-21 09:50:00', 5425.00, 'LIVREE'),
(30, '2026-09-29 16:30:00', 10800.00, 'EXPEDIEE'),
(15, '2026-11-12 10:50:00', 2550.00, 'EN_ATTENTE'),
(26, '2026-11-19 14:05:00', 4400.00, 'EN_COURS');
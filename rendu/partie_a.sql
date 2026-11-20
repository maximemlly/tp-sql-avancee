-- 1. Audit EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT *
FROM commandes
WHERE YEAR(date_commande) = 2026
  AND statut = 'LIVREE'
ORDER BY montant_total DESC
LIMIT 10;

-- Les 2 défauts du plan obtenu :
-- 1) Prédicat non-SARGable : YEAR(date_commande) empêche l'utilisation d'un index sur la date et force un Seq Scan complet de la table.
-- 2) SELECT * et Sort coûteux : SELECT * oblige à lire toute la table (empêche l'Index Only Scan) et impose un tri complet en mémoire (Sort) avant le LIMIT 10.


-- 2. Indexation, partitionnement RANGE et réécriture SARGable
CREATE INDEX idx_commandes_statut_date_montant
ON commandes (statut, date_commande, montant_total DESC);

CREATE TABLE commandes_part (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    client_id INT NOT NULL,
    date_commande DATE NOT NULL,
    statut VARCHAR(30) NOT NULL,
    montant_total NUMERIC(12, 2) NOT NULL,
    PRIMARY KEY (id, date_commande)
) PARTITION BY RANGE (date_commande);

CREATE TABLE commandes_2024 PARTITION OF commandes_part
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE commandes_2025 PARTITION OF commandes_part
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE commandes_2026 PARTITION OF commandes_part
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

EXPLAIN ANALYZE
SELECT id, client_id, date_commande, montant_total
FROM commandes
WHERE statut = 'LIVREE'
  AND date_commande >= '2026-01-01'
  AND date_commande < '2027-01-01'
ORDER BY montant_total DESC
LIMIT 10;

-- Comparaison et Partition Pruning :
-- - Coût avant/après : Passage d'un Seq Scan + Sort en O(N log N) à un Index Scan en O(log N), réduisant fortement le coût total et le temps d'exécution.
-- - Partition Pruning : Grâce au filtre par intervalle sur 2026, le moteur ignore directement les partitions commandes_2024 et commandes_2025 (66 % des données non lues).


-- 3. Vue matérialisée mv_synthese_segments
CREATE MATERIALIZED VIEW mv_synthese_segments AS
SELECT
    c.segment,
    COUNT(cmd.id) AS nb_commandes,
    ROUND(SUM(cmd.montant_total), 2) AS ca_total
FROM clients c
JOIN commandes cmd ON cmd.client_id = c.id
GROUP BY c.segment;

-- Insertion d'une commande test
INSERT INTO commandes (client_id, date_commande, montant_total, statut)
VALUES (1, '2026-11-20 10:30:00', 5000.00, 'LIVREE');

-- Lecture avant refresh : la vue est figée sur disque et marquée obsolète (stale), le nouveau CA n'apparaît pas.
SELECT * FROM mv_synthese_segments ORDER BY ca_total DESC;

-- Rafraîchissement et vérification de la mise à jour
REFRESH MATERIALIZED VIEW mv_synthese_segments;
SELECT * FROM mv_synthese_segments ORDER BY ca_total DESC;

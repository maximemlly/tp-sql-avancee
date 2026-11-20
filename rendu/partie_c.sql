-- 7. Piège du NOT IN avec NULL
-- Explication :
-- La CTO a manager_id = NULL. La sous-requête renvoie donc NULL dans la liste.
-- En logique ternaire SQL, `id NOT IN (..., NULL)` évalue `id != NULL` qui vaut UNKNOWN.
-- Le WHERE échoue pour toutes les lignes et retourne 0 résultat.

-- Correction fiable avec NOT EXISTS :
SELECT e.id, e.nom
FROM employes e
WHERE NOT EXISTS (
    SELECT 1
    FROM employes sub
    WHERE sub.manager_id = e.id
);


-- 8. Transactions ACID, isolation et rôle du WAL

-- a) Reproduction du Non-Repeatable Read sous READ COMMITTED :
-- Session T1 :
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT solde FROM comptes_bancaires WHERE id = 1; -- Lit 15000.00

-- Session T2 (en parallèle) :
BEGIN;
UPDATE comptes_bancaires SET solde = solde - 1000 WHERE id = 1;
COMMIT; -- Solde validé à 14000.00

-- Session T1 :
SELECT solde FROM comptes_bancaires WHERE id = 1; -- Lit 14000.00 (Non-Repeatable Read)
COMMIT;

-- b) Résolution sous REPEATABLE READ :
-- Session T1 :
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT solde FROM comptes_bancaires WHERE id = 1; -- Lit 15000.00 (Snapshot MVCC figé)

-- Session T2 (en parallèle) :
BEGIN;
UPDATE comptes_bancaires SET solde = solde - 1000 WHERE id = 1;
COMMIT;

-- Session T1 :
SELECT solde FROM comptes_bancaires WHERE id = 1; -- Lit toujours 15000.00 (Protégé)
COMMIT;

-- c) Rôle du WAL lors d'une coupure serveur en plein virement :
-- - Atomicité (Undo / Rollback) : Si le serveur coupe après le débit mais avant le crédit (sans COMMIT), le WAL annule le débit au redémarrage pour ne pas perdre d'argent.
-- - Durabilité (Redo / fsync) : Dès que le COMMIT est validé, l'opération est écrite sur disque dans le WAL et survit à toute panne électrique.


-- 9. Architecture polyglotte (Application de covoiturage temps réel)

-- (a) Suivi GPS toutes les 3 secondes de 30 000 véhicules (10 000 écritures/s) :
-- - Choix : Apache Cassandra (NoSQL Colonnes Larges)
-- - CAP / PACELC : AP et PA / EL (priorité à la disponibilité et à la latence minimale).
-- - 4 critères :
--   1. Cohérence : Cohérence éventuelle acceptable (1s de décalage GPS non critique).
--   2. Scalabilité : Sharding horizontal massif encaissant 10 000 écritures/s en append-only (LSM-Tree).
--   3. Structure : Séries temporelles avec Partition Key (vehicule_id, jour) et Clustering Key (timestamp).
--   4. Accès : Écritures continues ultra-rapides et lecture chronologique par véhicule.

-- (b) Facturation bancaire des trajets :
-- - Choix : PostgreSQL (SGBD Relationnel SQL ACID)
-- - CAP / PACELC : CP et PC / EC (priorité absolue à la cohérence stricte).
-- - 4 critères :
--   1. Cohérence : Zéro erreur tolérée, transactions ACID strictes sur les paiements.
--   2. Scalabilité : Volume modéré (1 écriture par fin de trajet), scalabilité verticale + réplicas lecture.
--   3. Structure : Schéma tabulaire fixe et normalisé en 3FN (trajets, factures, comptes).
--   4. Accès : Transactions OLTP sécurisées et requêtes analytiques / reporting comptable.

-- (c) Suggestion d'itinéraires et d'amis communs à 3 degrés de séparation :
-- - Choix : Neo4j (NoSQL Orienté Graphe)
-- - CAP / PACELC : PC / EC (cohérence des relations).
-- - 4 critères :
--   1. Cohérence : Liens sociaux et trajets fiables.
--   2. Scalabilité : Évite l'explosion des jointures récursives SQL sur plusieurs niveaux.
--   3. Structure : Réseau de Nœuds (Utilisateurs, Trajets) et Relations typées (AMI_AVEC, EMPRUNTE).
--   4. Accès : Traversée à 3 sauts en quelques millisecondes grâce à l'Index-Free Adjacency.

-- 4. Passage en 3FN de affectations_brutes
-- Dépendances fonctionnelles :
-- - employe_id -> employe_nom, dept_id
-- - dept_id -> dept_nom (dépendance transitive sortie de employes)
-- - projet_id -> projet_nom, chef_projet_id
-- - chef_projet_id -> chef_projet, chef_projet_tel (dépendance transitive sortie de projets)
-- - (employe_id, projet_id) -> clé primaire composée de la table de liaison (1FN : suppression de projets_liste)

CREATE TABLE departements (
    dept_id INT PRIMARY KEY,
    dept_nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employes_3fn (
    employe_id INT PRIMARY KEY,
    employe_nom VARCHAR(150) NOT NULL,
    dept_id INT NOT NULL REFERENCES departements(dept_id)
);

CREATE TABLE chefs_projet (
    chef_projet_id INT PRIMARY KEY,
    chef_projet_nom VARCHAR(150) NOT NULL,
    chef_projet_tel VARCHAR(30) NOT NULL
);

CREATE TABLE projets (
    projet_id INT PRIMARY KEY,
    projet_nom VARCHAR(150) NOT NULL,
    chef_projet_id INT NOT NULL REFERENCES chefs_projet(chef_projet_id)
);

CREATE TABLE affectations (
    employe_id INT NOT NULL REFERENCES employes_3fn(employe_id),
    projet_id INT NOT NULL REFERENCES projets(projet_id),
    PRIMARY KEY (employe_id, projet_id)
);


-- 5. Top 2 des produits les plus chers par catégorie (CTE + DENSE_RANK)
WITH classement AS (
    SELECT
        cat.nom AS categorie,
        p.nom AS produit,
        p.prix_unitaire,
        DENSE_RANK() OVER (
            PARTITION BY p.categorie_id
            ORDER BY p.prix_unitaire DESC
        ) AS rang_prix
    FROM produits p
    JOIN categories cat ON cat.id = p.categorie_id
)
SELECT categorie, produit, prix_unitaire, rang_prix
FROM classement
WHERE rang_prix <= 2
ORDER BY categorie ASC, rang_prix ASC;


-- 6. Organigramme complet depuis la CTO (WITH RECURSIVE)
WITH RECURSIVE organigramme AS (
    SELECT
        id,
        nom,
        poste,
        departement,
        1 AS niveau,
        nom AS chemin
    FROM employes
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.nom,
        e.poste,
        e.departement,
        o.niveau + 1 AS niveau,
        o.chemin || ' > ' || e.nom AS chemin
    FROM employes e
    JOIN organigramme o ON e.manager_id = o.id
)
SELECT id, nom, poste, niveau, chemin
FROM organigramme
ORDER BY niveau ASC, id ASC;
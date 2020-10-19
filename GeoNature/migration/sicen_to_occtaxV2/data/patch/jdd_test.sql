-- BASE GN

-- PATCH pour les test du script

-- On crée un jdd et un CA pour tester les importd
-- Toutes les données auront le même JDD

-- Cette partie doit être faite 'à la main'
-- cad creer les CA et JDD GN et les associer aux protocoles et etude OO dans la table export_oo.cor_dataset

-- on fait en sorte de ne pas pouvoir recreer les infos deux fois

DELETE FROM pr_occtax.t_releves_occtax r 
USING gn_meta.t_datasets d 
WHERE r.id_dataset = d.id_dataset AND d.dataset_name = :'db_oo_name';

DELETE FROM gn_meta.t_datasets WHERE dataset_name = :'db_oo_name';

DELETE FROM gn_meta.t_acquisition_frameworks WHERE acquisition_framework_name = :'db_oo_name';

-- INSERT CA
INSERT INTO gn_meta.t_acquisition_frameworks(
        acquisition_framework_name, 
        acquisition_framework_desc,
        acquisition_framework_start_date
)
VALUES (
    :'db_oo_name',
    :'db_oo_name',
    '2020-01-01'
);

-- INSERT JDD
INSERT INTO gn_meta.t_datasets(
    id_acquisition_framework,
    dataset_name,
    dataset_shortname,
    dataset_desc,
    marine_domain,
    terrestrial_domain
    ) 
    SELECT
        af.id_acquisition_framework,
        :'db_oo_name',
        :'db_oo_name',
        :'db_oo_name',
        FALSE,
        FALSE
        
        FROM gn_meta.t_acquisition_frameworks af
        WHERE af.acquisition_framework_name = :'db_oo_name'
;

-- ASSIGN id_dataset
UPDATE export_oo.cor_dataset SET (id_dataset) = ( 
    SELECT id_dataset 
    FROM gn_meta.t_datasets
    WHERE  dataset_name = :'db_oo_name'
) 
;
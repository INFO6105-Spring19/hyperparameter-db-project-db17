# Hyperparameter Project on Mushroom Dataset

## 1. Abstract
The project is a part of skunksworks hyperparameters project. First part is to create a database that stores the gilled mushrooms in the Agaricus and Lepiota Family, and second part is to store evalutions and hyperparameters that used to perform algorithms on mushroom data in part one.

## 2. Explain Data Source
This dataset is from UCI Machine Learning Repository, including descriptions of hypothetical samples corresponding to 23 species of gilled mushrooms in the Agaricus and Lepiota Family Mushroom drawn from The Audubon Society Field Guide to North American Mushrooms (1981). Each species is identified as definitely edible, definitely poisonous, or of unknown edibility and not recommended. This latter class was combined with the poisonous one. The Guide clearly states that there is no simple rule for determining the edibility of a mushroom; no rule like "leaflets three, let it be'' for Poisonous Oak and Ivy.

## 3. Conceptual Schema
The conceptual schema [ERD](https://github.com/uttgeorge/hyperparameter-project/blob/master/SQL/Conceptual_Model/ERD.pdf) is in SQL folder.\
This schema have five major parts:\
**1.** data_repository: It stores dataset ids and names;\
**2.** predictors: It stores all predictors for each dataset;\
**3.** metadata: It stores data like run_id, run_time and others that models are based on;\
**4.** models: For each run_id, there are several different models, each model has an unique performance;\
**5.** Hyper Parameters: In this database, we store hyper parameter not in a single table, but in several different tables separated by their algorithms.

## 4. ER diagrams
Mentioned in 3. Conceptual Schema.

## 5. Normalization(till 3NF)
#### 1NF
**Requirement:**
1. No repeating groups
2. Atomic
3. Each field has a unique name
4. Primary key
#### 2NF
**Requirement:**
1. Already 1NF
2. No partial dependencies
3. No calculated data
#### 3NF
**Requirement:**
1. Already 2NF
2. No transitive dependencies

*Table 1: data_repository*
>This table have one primary key(dataset_id), and one non-key attribute.
>It is in 3NF.

*Table 2: predictors*
>This table have a primary key consist tow parts(dataset_id,predictor_name), and no non-key attribute.
>It is in 3NF.

*Table 3: metadata*
>This table have a primary key(run_id), and several non-key attributes.
>All non-key attributes are based on and only on primary key.
>It is in 3NF.

*Table 4: models*
>This table have a primary key(model_id), and several non-key attributes, eg. measurements.
>All non-key attributes are based on and only on primary key.
>It is in 3NF.

*Table 4: Hyper-parameter*
>There are 7 tables have 7 primary keys, they are all unique.
>All non-key attributes are based on and only on primary key.
>It is in 3NF.

## 6. Physical model

### *6.1 Create Tables*

[Create Tables](https://github.com/uttgeorge/hyperparameter-project/blob/master/SQL/Physical_database/hyperparameter.sql) SQL file is in SQL folder.

##### Create Database
Database called hyperparameter
```mysql
create database if not exists hyperparameter;
use hyperparameter;
```

##### Create data_repository table 
A table to store the id and the name of each dataset

```mysql
drop table if exists data_repository;
create table if not exists data_repository(
    dataset_id int primary key auto_increment,
    dataset_name text not null
);
```
##### Create predictors table
For each predictor_id, we will have several predictors

```mysql
drop table if exists predictors;
create table if not exists predictors(
    dataset_id int not null,
    predictor_name varchar(255) not null,
    constraint predictor_pk primary key (dataset_id,predictor_name),
    constraint predictor_fk foreign key (dataset_id) references data_repository(dataset_id)
);
```

##### Create metadata table
For each dataset,there are several meta data, including run time, run id.
```mysql
drop table if exists metadata;
create table if not exists metadata(
    dataset_id int not null,
    run_id varchar(255) primary key,
    min_mem_size int not null,
    scale text not null,
    target text not null ,
...
    constraint metadata_fk foreign key (dataset_id) references data_repository(dataset_id)
);
```
##### Create models table
For each run id, we will generate several models with their performance respectively.
```mysql
drop table if exists models;
create table models(
    run_id varchar(255) not null,
    model_id varchar(255) not null,
    auc double default null,
    logloss double default null,
    mean_per_class_error double default null,
    rmse double default null,
    mse double default null,
    model_category varchar(255) not null,
    constraint models primary key (model_id(255)),
    constraint models_fk foreign key (run_id) references metadata(run_id)
);    
```
##### Create hyper parameter table.
We seperate hyper parameter table into 7 tables, each table corresponding to a algorithm. We take GBM as an example.
```mysql
drop table if exists GBM_model;
CREATE TABLE IF NOT EXISTS GBM_model (
  GBM_model_id VARCHAR(255) NOT NULL,
  # True means actual, False means default
  actual_or_default varchar(25) default false,
 
  `learn_rate` DOUBLE NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `col_sample_rate_per_tree` DOUBLE NULL DEFAULT NULL,
...
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,

  PRIMARY KEY (GBM_model_id,actual_or_default),
  CONSTRAINT GBM_model_fk FOREIGN KEY (GBM_model_id) REFERENCES models (model_id)
);
```
### *6.2 Import Data*

[Import Data](https://github.com/uttgeorge/hyperparameter-project/blob/master/SQL/Physical_database/importdata.sql) SQL file is in SQL folder.

1. data_repository 
```mysql
INSERT INTO data_repository(dataset_name)
VALUES ( 'mushroom');
```

2. predictors
```mysql
INSERT INTO predictors
VALUES
( '1','cap-shape'),
( '1','cap-surface'),
( '1','cap-color'),
( '1','bruises'),
( '1','odor'),
( '1','gill-attachment'),
( '1','gill-spacing'),
( '1','gill-size'),
( '1','gill-color'),
( '1','stalk-shape'),
( '1','stalk-root'),
( '1','stalk-surface-above-ring'),
( '1','stalk-surface-below-ring'),
( '1','stalk-color-above-ring'),
( '1','stalk-color-below-ring'),
( '1','veil-type'),
( '1','veil-color'),
( '1','ring-number'),
( '1','ring-type'),
( '1','spore-prstring-color'),
( '1','population'),
( '1','habitat');
```
3. metadata
```mysql
INSERT INTO metadata
VALUES 
(1,'JjUS31JGhX',6,'FALSE','class','TRUE',0,1555694048,'',1555694048,1,200,100,'FALSE',0.2),
(1,'2Rr6eu3vHP',6,'FALSE','class','TRUE',0,1555747273,'',1555747273,1,400,100,'FALSE',0.2),
(1,'utthNoQEU0',6,'FALSE','class','TRUE',0,1555756193,'',1555756193,1,800,100,'FALSE',0.2),
(1,'KPiL6NvWlS',6,'FALSE','class','TRUE',0,1555749638,'',1555749638,1,600,100,'FALSE',0.2),
(1,'fICT1DYlnK',6,'FALSE','class','TRUE',0,1555757937,'',1555757937,1,1000,100,'FALSE',0.2);
```

4. models
```mysql
INSERT INTO models
VALUES 
('JjUS31JGhX','GBM_1_AutoML_20190419_130933',1,1.51e-17,0,9.1e-16,8.28e-31,'GBM'),
('JjUS31JGhX','GBM_4_AutoML_20190419_130933',1,2.09e-16,0,0.0000000000000137,1.87e-28,'GBM'),
...
('fICT1DYlnK','XRT_1_AutoML_20190420_055921',0.995574938,0.277252845,0.020705733,0.291090532,0.084733698,'XRT'),
('fICT1DYlnK','DeepLearning_grid_1_AutoML_20190420_055921_model_5',0.994419071,0.125295746,0.015346759,0.118260271,0.013985492,'DeepLearning');
```
5. hyperparameter\
GLM as an example
```mysql
INSERT INTO GLM_model
VALUES
('GLM_grid_1_AutoML_20190420_034740_model_1','actual',0.0001,'','binomial','MeanImputation',1,1.71321e18,'TRUE',5,'FALSE','','automl_training_Key_Frame__upload_8690c96acf38431d14ed72e27dea4966.hex',-1,'FALSE',0,'','FALSE',0.0000000001,'','','TRUE','','class','TRUE','','[]','FALSE','TRUE','logit',0.000001,'[0.0, 0.2, 0.4, 0.6, 0.8, 1.0]',20,'FALSE','TRUE',5000,'FALSE','COORDINATE_DESCENT',0.0001,30,'Modulo',0,'','TRUE',5,0,'',0.000123092,0.000001,300,'','FALSE','[19.455893037534402, 12.082439195938939, 7.503399440052737, 4.659738174052406, 2.893776350865394, 1.7970841399325495, 1.116019696902739, 0.6930671392612864, 0.43040643534957707, 0.26728968825124244, 0.16599142479693543, 0.10308348700761596, 0.06401659186098818, 0.03975538810783111, 0.024688769546437426, 0.015332144162794084, 0.009521521280618938, 0.005913026027845397, 0.003672089341137756, 0.002280429692985968, 0.0014161854741368584, 0.0008794751722997229, 0.0005461689819711281, 0.0003391801909397374, 0.00021063664492759166, 0.00013080892508323167, 8.12345586273109e-05, 5.0448037174643384e-05, 3.1329085770628844e-05, 1.945589303753436e-05]'),
...;
```
## 7. use cases

[Qi Jin's Use Cases](https://github.com/uttgeorge/hyperparameter-project/blob/master/SQL/Physical_database/QI%20JIN%20USECASE.sql) SQL file is in SQL folder.

### ***Case 1***

Find the best model' name and aucuracy by their measurement: rmse,mse. 
Return its model name and auc, and runtime respectively.
```mysql
DROP VIEW best_model;
CREATE VIEW best_model AS
    SELECT 
        models.model_category,
        models.model_id,
        models.rmse,
        models.mse,
        metadata.run_time AS runtime
    FROM
        models
            JOIN
        metadata ON models.run_id = metadata.run_id
    ORDER BY rmse , mse
    LIMIT 10;
SELECT * FROM best_model;
```
Results:

| model_id                                  | rmse     | mse      | runtime |
|-------------------------------------------|----------|----------|---------|
| GBM_grid_1_AutoML_20190420_034740_model_3 | 5.02e-17 | 2.52e-33 |     400 |
| GBM_grid_1_AutoML_20190420_041549_model_4 | 5.79e-17 | 3.35e-33 |     600 |
| GBM_grid_1_AutoML_20190420_041549_model_3 | 7.13e-17 | 5.08e-33 |     600 |
| GBM_grid_1_AutoML_20190420_052704_model_1 | 8.23e-17 | 6.78e-33 |     800 |
| GBM_grid_1_AutoML_20190420_034740_model_2 | 9.95e-17 |  9.9e-33 |     400 |
| GBM_grid_1_AutoML_20190419_130933_model_3 | 1.12e-16 | 1.25e-32 |     200 |
| GBM_2_AutoML_20190420_055921              |  2.1e-16 |  4.4e-32 |    1000 |
| GBM_grid_1_AutoML_20190420_041549_model_5 | 4.17e-16 | 1.74e-31 |     600 |
| GBM_1_AutoML_20190420_055921              | 4.59e-16 | 2.11e-31 |    1000 |
| GBM_2_AutoML_20190420_052704              | 4.65e-16 | 2.16e-31 |     800 |

10 rows in set (0.00 sec)

### ***Case 2***

When choosing a algorithm, find the best model(s) and its(their) hyper parameters(Both default and actual). 

**Step 1.** Create temporary table to store hyper parameters of the best models for each category.
```mysql
CREATE TEMPORARY TABLE Best_DeepLearning AS
SELECT models.model_category,models.rmse,DeepLearning_model.*
FROM models JOIN DeepLearning_model
ON models.model_id = DeepLearning_model.DeepLearning_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
```mysql
CREATE TEMPORARY TABLE Best_DRF AS            
SELECT models.model_category,models.rmse,DRF_model.*
FROM models JOIN DRF_model
ON models.model_id = DRF_model.DRF_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
```mysql
CREATE TEMPORARY TABLE Best_GBM AS            
SELECT models.model_category,models.rmse,GBM_model.*
FROM models JOIN GBM_model
ON models.model_id = GBM_model.GBM_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
```mysql             
CREATE TEMPORARY TABLE Best_StackedEnsemble_AllModels AS            
SELECT models.model_category,models.rmse,StackedEnsemble_AllModels_model.*
FROM models JOIN StackedEnsemble_AllModels_model
ON models.model_id = StackedEnsemble_AllModels_model.StackedEnsemble_AllModels_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
```mysql
CREATE TEMPORARY TABLE Best_StackedEnsemble_BestOfFamily AS            
SELECT models.model_category,models.rmse,StackedEnsemble_BestOfFamily_model.*
FROM models JOIN StackedEnsemble_BestOfFamily_model
ON models.model_id = StackedEnsemble_BestOfFamily_model.StackedEnsemble_BestOfFamily_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
```mysql
CREATE TEMPORARY TABLE Best_XRT AS            
SELECT models.model_category,models.rmse,XRT_model.*
FROM models JOIN XRT_model
ON models.model_id = XRT_model.XRT_model_id
WHERE concat(model_category,rmse) IN (
               SELECT concat(model_category,min(rmse))
                 FROM models 
                GROUP BY model_category
             );
```
**Step 2** Create procedure to return hyper parameters of category we have chosen.
```mysql
SET GLOBAL log_bin_trust_function_creators = 1;

DROP PROCEDURE get_hyp;
DELIMITER //
CREATE PROCEDURE get_hyp(TableName Varchar(50))
#RETURNS TEXT
BEGIN 
	#SET @t_name = get_name(TableName);
    #set @val = idnumber;
    set @sql_text = concat('Select * from Best_', TableName);
    prepare statement from @sql_text;
    execute statement;
    deallocate prepare statement;
    
    #WHERE table_name = concat("Best_",model_category);
	#RETURN tablename;
END;
//
DELIMITER ;
```
**Step 3** Execute procedure
```mysql
CALL get_hyp('XRT');
```
Results:


| model_category | rmse        | XRT_model_id                 | actual_or_default | min_split_improvement | fold_column | col_sample_rate_per_tree | fold_assignment | score_tree_interval | sample_rate_per_class | seed                 | keep_cross_validation_predictions | binomial_double_trees | nfolds | keep_cross_validation_models | offset_column | categorical_encoding | checkpoint | stopping_tolerance | training_frame                                                         | max_runtime_secs | calibrate_model | export_checkpoints_dir | balance_classes | r2_stopping            | validation_frame | max_depth | custom_metric_func | response_column | build_tree_one_node | ntrees | ignored_columns | min_rows | mtries | max_confusion_matrix_size | score_each_iteration | nbins_top_level | max_after_balance_size | nbins | histogram_type | stopping_metric | weights_column | stopping_rounds | col_sample_rate_change_per_level | max_hit_ratio_k | nbins_cats | sample_rate | calibration_frame | distribution | class_sampling_factors | check_constant_response | ignore_const_cols | keep_cross_validation_fold_assignment |
|----------------|-------------|------------------------------|-------------------|-----------------------|-------------|--------------------------|-----------------|---------------------|-----------------------|----------------------|-----------------------------------|-----------------------|--------|------------------------------|---------------|----------------------|------------|--------------------|------------------------------------------------------------------------|------------------|-----------------|------------------------|-----------------|------------------------|------------------|-----------|--------------------|-----------------|---------------------|--------|-----------------|----------|--------|---------------------------|----------------------|-----------------|------------------------|-------|----------------|-----------------|----------------|-----------------|----------------------------------|-----------------|------------|-------------|-------------------|--------------|------------------------|-------------------------|-------------------|---------------------------------------|
| XRT            | 0.171061011 | XRT_1_AutoML_20190420_034740 | actual            |               0.00001 |             |                        1 | Modulo          |                   0 |                       | -2181650000000000000 | TRUE                              | FALSE                 |      5 | FALSE                        |               | AUTO                 |            |        0.011094687 | automl_training_Key_Frame__upload_8690c96acf38431d14ed72e27dea4966.hex |                0 | FALSE           |                        | FALSE           | 1.7976931348623157e308 |                  |        20 |                    | class           | FALSE               |      9 | []              |        1 |     -1 |                        20 | FALSE                |            1024 |                      5 |    20 | Random         | logloss         |                |               0 |                                1 |               0 |       1024 | 0.632000029 |                   | multinomial  |                        | TRUE                    | TRUE              | FALSE                                 |
| XRT            | 0.171061011 | XRT_1_AutoML_20190420_034740 | default           |               0.00001 |             |                        1 | AUTO            |                   0 |                       |                   -1 | FALSE                             | FALSE                 |      0 | TRUE                         |               | AUTO                 |            |              0.001 |                                                                        |                0 | FALSE           |                        | FALSE           | 1.7976931348623157e308 |                  |        20 |                    |                 | FALSE               |     50 |                 |        1 |     -1 |                        20 | FALSE                |            1024 |                      5 |    20 | AUTO           | AUTO            |                |               0 |                                1 |               0 |       1024 | 0.632000029 |                   | AUTO         |                        | TRUE                    | TRUE              | FALSE                                 |

2 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

### ***Case 3***

When input the dataset name, return the predictors that we use.

```mysql
DROP PROCEDURE find_predictors;
DELIMITER //
CREATE PROCEDURE find_predictors(dataset Varchar(50))
BEGIN 
	set @dataind = 0;
SELECT 
    dataset_id
FROM
    data_repository
WHERE
    dataset_name = dataset INTO @dataind;
SELECT 
    t.predictor_name AS 'predictor names'
FROM
    (SELECT 
        data_repository.dataset_name,
            predictors.predictor_name,
            predictors.dataset_id
    FROM
        data_repository
    JOIN predictors ON data_repository.dataset_id = predictors.dataset_id) t
WHERE
    t.dataset_id = @dataind;
END;
//
DELIMITER ;
```
```mysql
CALL find_predictors('mushroom');
```

| predictor names          |
|--------------------------|
| bruises                  |
| cap-color                |
| cap-shape                |
| cap-surface              |
| gill-attachment          |
| gill-color               |
| gill-size                |
| gill-spacing             |
| habitat                  |
| odor                     |
| population               |
| ring-number              |
| ring-type                |
| spore-prstring-color     |
| stalk-color-above-ring   |
| stalk-color-below-ring   |
| stalk-root               |
| stalk-shape              |
| stalk-surface-above-ring |
| stalk-surface-below-ring |
| veil-color               |
| veil-type                |
|--------------------------|
22 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)


### ***Case 4***

Sometimes, we have to minimize the run time by sacraficing accuracy, so it is important to find a best run time that both minimize the error and have relatively short run time. 
This case return the average and best performance of each runtime for a chosen dataset.
```mysql
DROP PROCEDURE best_time;
DELIMITER //
CREATE PROCEDURE best_time(dataset Varchar(50))
#RETURNS TEXT
BEGIN 
	set @dataind = 0;
SELECT 
    dataset_id
FROM
    data_repository
WHERE
    dataset_name = dataset INTO @dataind;
	SELECT 
    t.run_time, AVG(t.rmse), MIN(t.rmse), MAX(t.auc)
FROM
    (SELECT 
        models.*, metadata.run_time, metadata.dataset_id
    FROM
        models
    JOIN metadata ON models.run_id = metadata.run_id) t
WHERE
    t.dataset_id = @dataind
GROUP BY t.run_time
ORDER BY t.run_time;
END;
//
DELIMITER ;
```
```mysql
CALL best_time('mushroom');
```
Results:

| run time | AVG(rmse)         | min(rmse) | max(auc) |
|----------|---------------------|-------------|------------|
|      200 | 0.02419750178998679 |    1.12e-16 |          1 |
|      400 | 0.05775518490004715 |    5.02e-17 |          1 |
|      600 | 0.08628367447833506 |    5.79e-17 |          1 |
|      800 | 0.04891000658321349 |    8.23e-17 |          1 |
|     1000 | 0.08447084129975319 |     2.1e-16 |          1 |

5 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

### ***Case 5***
In this case, we will find the change of performance for each algorithm. If the change is not tramatic, we can choose the short runtime, if the change is big, we have to check which time is better. So this case will also show the deviation of a algorithm by its runtime.

This is the procedure to know change of performance for each algorithm of all time.
```mysql
DROP PROCEDURE change_signiificant;
DELIMITER //
CREATE PROCEDURE change_signiificant(dataset Varchar(50))
BEGIN
	set @dataind = 0;
    select dataset_id from data_repository where dataset_name =  dataset INTO @dataind;
    
	SELECT t.model_category,/*STD(t.auc) as 'accuracy deviation',*/STD(t.rmse) as 'rmse deviation', max(t.rmse) - min(t.rmse) as 'rmse gap'
	FROM
	(SELECT models.*,metadata.run_time,metadata.dataset_id
		FROM models
		JOIN metadata 
		ON models.run_id = metadata.run_id) t
	WHERE t.dataset_id = @dataind
	GROUP BY t.model_category
	ORDER BY STD(t.rmse) DESC;
END;
//
DELIMITER ;
```
This is the procedure to know change of performance for a algorithm by its runtime.
```mysql
DROP PROCEDURE change_by_time;
DELIMITER //
CREATE PROCEDURE change_by_time(dataset Varchar(50),model_category Varchar(50))
BEGIN
	set @dataind = 0;
SELECT 
    dataset_id
FROM
    data_repository
WHERE
    dataset_name = dataset INTO @dataind;
    
	SELECT 
    t.run_time,
    t.model_category,
    STD(t.auc) AS 'accuracy deviation',
    STD(t.rmse) AS 'rmse deviation',
    MAX(t.rmse) - MIN(t.rmse) AS 'rmse gap'
FROM
    (SELECT 
        models.*, metadata.run_time, metadata.dataset_id
    FROM
        models
    JOIN metadata ON models.run_id = metadata.run_id) t
WHERE
    t.model_category = (SELECT 
            t.model_category
        FROM
            (SELECT 
                models.*, metadata.run_time, metadata.dataset_id
            FROM
                models
            JOIN metadata ON models.run_id = metadata.run_id) t
        WHERE
            t.model_category = model_category
        GROUP BY t.model_category
        ORDER BY STD(t.rmse) DESC
        )
GROUP BY t.run_time , t.model_category
ORDER BY t.run_time;
END;
//
DELIMITER ;
```

```mysql
CALL change_signiificant('mushroom');
```

Results:

| model_category               | rmse deviation         | rmse gap               |
|------------------------------|------------------------|------------------------|
| GBM                          |    0.14115963219403407 |    0.49724433099999993 |
| DeepLearning                 |    0.06186019080986617 |             0.19954826 |
| XRT                          |    0.05494093456805064 |            0.141191198 |
| DRF                          |   0.005073231033352161 |   0.014260127999999999 |
| StackedEnsemble_AllModels    |  0.0002849904602021618 |  0.0007624579999999999 |
| StackedEnsemble_BestOfFamily | 0.00016089958252897993 | 0.00043716700000000024 |
| GLM                          |                      0 |                      0 |

7 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

**GBM changed a lot, GLM did not change at all, let's take a look at GBM.**

```mysql
CALL change_by_time('mushroom','GBM');
```

Results:

| run_time | model_category | accuracy deviation        | rmse deviation      | rmse gap             |
|----------|----------------|---------------------------|---------------------|----------------------|
|      200 | GBM            | 0.00000020039999999813912 | 0.00835874274435898 | 0.024534885999999888 |
|      400 | GBM            |      0.023765766348531395 | 0.15540871496304445 |  0.49724433099999993 |
|      600 | GBM            |     0.0006093275892166271 | 0.16485033246117756 |  0.47631623999999995 |
|      800 | GBM            |    0.00000486090000002363 | 0.02697416736120888 |  0.08991479299999992 |
|     1000 | GBM            |   0.000026509276091848646 | 0.19201546889025076 |   0.4748269919999998 |

5 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

**As we see, when runtime equal 400, performance of GBM changed a lot, so if we choose GBM as our algorithm, set runtime as 400 is better.**

## 8. Citations and References

Thanks to Mayuresh Deodhar for his hardwork, he built the model and got all the data we need.

Tutorial by Prof.Brown: [Link](https://github.com/nikbearbrown/INFO_6210)<br/>

Qi Jin: 50% of this project, including the usecase 1 to 5.

Dongyu Zhang: 50% of this project, including the usecase 6 to 10.

## 9. License

[License](https://github.com/INFO6105-Spring19/hyperparameter-db-project-db17/blob/master/LICENSE)

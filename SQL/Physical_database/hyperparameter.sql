create database if not exists hyperparameter;
use hyperparameter;
#

# a table store the id and the name of each dataset
drop table if exists data_repository;
create table if not exists data_repository(
	dataset_id int primary key auto_increment,
    dataset_name text not null
);

# for each predictor_id, we will have several predictors
drop table if exists predictors;
create table if not exists predictors(
	dataset_id int not null,
    predictor_name varchar(255) not null,
    /*`cap-shape` text,
	`cap-surface` text,
	`cap-color` text,
	`bruises` text,
	`odor` text,
	`gill-attachment` text,
	`gill-spacing` text,
	`gill-size` text,
	`gill-color` text,
	`stalk-shape` text,
	`stalk-root` text,
	`stalk-surface-above-ring` text,
	`stalk-surface-below-ring` text,
	`stalk-color-above-ring` text,
	`stalk-color-below-ring` text,
	`veil-type` text,
	`veil-color` text,
	`ring-number` text,
	`ring-type` text,
	`spore-prstring-color` text,
	`population` text,
	`habitat` text,*/
    
    constraint predictor_pk primary key (dataset_id,predictor_name),
    constraint predictor_fk foreign key (dataset_id) references data_repository(dataset_id)
);
# mid_table, to link runtime with model_id. each runtime have several models

# each dataset have a metadate file
drop table if exists metadata;
create table if not exists metadata(
	dataset_id int not null,
    #project_name text not null,
    #method text not null,
    run_id varchar(255) primary key,
    min_mem_size int not null,
    scale text not null,
    target text not null ,
    classification text not null,
    execution_time int not null,
    strat_time double not null,
    project text,
    end_time double not null,
    nthreads int not null,
    run_time int not null,
    max_models int not null,
    balance text not null,
    balance_threshold float not null,
    constraint metadata_fk foreign key (dataset_id) references data_repository(dataset_id)
);



# for each run_id, we will generate several models.

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
#ALTER TABLE models
#DROP foreign key models_fk;

# GBM

drop table if exists GBM_model;
CREATE TABLE IF NOT EXISTS GBM_model (
  GBM_model_id VARCHAR(255) NOT NULL,
  # True means actual, False means default
  actual_or_default varchar(25) default false,
  #model_category VARCHAR(45) NOT NULL,
  
  `learn_rate` DOUBLE NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `col_sample_rate_per_tree` DOUBLE NULL DEFAULT NULL,
  `learn_rate_annealing` DOUBLE NULL DEFAULT NULL,
  `score_tree_interval` INT(11) NULL DEFAULT NULL,
  `sample_rate_per_class` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
  #`model_id` TEXT NULL DEFAULT NULL,
  `nfolds` INT(11) NULL DEFAULT NULL,
  `max_abs_leafnode_pred` DOUBLE NULL DEFAULT NULL,
  `offset_column` TEXT NULL DEFAULT NULL,
  `categorical_encoding` TEXT NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `stopping_tolerance` DOUBLE NULL DEFAULT NULL,
  `monotone_constraints` TEXT NULL DEFAULT NULL,
  `fold_assignment` TEXT NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
  `calibrate_model` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_models` TEXT NULL DEFAULT NULL,
  `checkpoint` TEXT NULL DEFAULT NULL,
  `balance_classes` TEXT NULL DEFAULT NULL,
  `r2_stopping` DOUBLE NULL DEFAULT NULL,
  `pred_noise_bandwidth` DOUBLE NULL DEFAULT NULL,
  `max_depth` INT(11) NULL DEFAULT NULL,
  `custom_metric_func` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `build_tree_one_node` TEXT NULL DEFAULT NULL,
  `ntrees` INT(11) NULL DEFAULT NULL,
  `min_split_improvement` DOUBLE NULL DEFAULT NULL,
  `ignored_columns` text NULL DEFAULT NULL,
  `tweedie_power` DOUBLE NULL DEFAULT NULL,
  `calibration_frame` TEXT NULL DEFAULT NULL,
  `min_rows` DOUBLE NULL DEFAULT NULL,
  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
  `score_each_iteration` TEXT NULL DEFAULT NULL,
  `nbins_top_level` INT(11) NULL DEFAULT NULL,
  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
  `quantile_alpha` DOUBLE NULL DEFAULT NULL,
  `nbins` INT(11) NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `huber_alpha` DOUBLE NULL DEFAULT NULL,
  `col_sample_rate` DOUBLE NULL DEFAULT NULL,
  `stopping_metric` TEXT NULL DEFAULT NULL,
  `weights_column` TEXT NULL DEFAULT NULL,
  `stopping_rounds` INT(11) NULL DEFAULT NULL,
  `col_sample_rate_change_per_level` DOUBLE NULL DEFAULT NULL,
  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
  `nbins_cats` INT(11) NULL DEFAULT NULL,
  `sample_rate` DOUBLE NULL DEFAULT NULL,
  `histogram_type` TEXT NULL DEFAULT NULL,
  `distribution` TEXT NULL DEFAULT NULL,
  `class_sampling_factors` TEXT NULL DEFAULT NULL,
  `check_constant_response` TEXT NULL DEFAULT NULL,
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,

  PRIMARY KEY (GBM_model_id,actual_or_default),
  CONSTRAINT GBM_model_fk FOREIGN KEY (GBM_model_id) REFERENCES models (model_id)
);
# DRF
drop table if exists DRF_model;
CREATE TABLE IF NOT EXISTS DRF_model (
  DRF_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `min_split_improvement` DOUBLE NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `col_sample_rate_per_tree` DOUBLE NULL DEFAULT NULL,
  `fold_assignment` TEXT NULL DEFAULT NULL,
  `score_tree_interval` INT(11) NULL DEFAULT NULL,
  `sample_rate_per_class` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
  `binomial_double_trees` TEXT NULL DEFAULT NULL,
  #`model_id` TEXT NULL DEFAULT NULL,
  `nfolds` INT(11) NULL DEFAULT NULL,
  `keep_cross_validation_models` TEXT NULL DEFAULT NULL,
  `offset_column` TEXT NULL DEFAULT NULL,
  `categorical_encoding` TEXT NULL DEFAULT NULL,
  `checkpoint` TEXT NULL DEFAULT NULL,
  `stopping_tolerance` DOUBLE NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
  `calibrate_model` TEXT NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `balance_classes` TEXT NULL DEFAULT NULL,
  `r2_stopping` DOUBLE NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `max_depth` INT(11) NULL DEFAULT NULL,
  `custom_metric_func` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `build_tree_one_node` TEXT NULL DEFAULT NULL,
  `ntrees` INT(11) NULL DEFAULT NULL,
  `ignored_columns` text NULL DEFAULT NULL,
  `min_rows` DOUBLE NULL DEFAULT NULL,
  `mtries` INT(11) NULL DEFAULT NULL,
  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
  `score_each_iteration` TEXT NULL DEFAULT NULL,
  `nbins_top_level` INT(11) NULL DEFAULT NULL,
  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
  `nbins` INT(11) NULL DEFAULT NULL,
  `histogram_type` TEXT NULL DEFAULT NULL,
  `stopping_metric` TEXT NULL DEFAULT NULL,
  `weights_column` TEXT NULL DEFAULT NULL,
  `stopping_rounds` INT(11) NULL DEFAULT NULL,
  `col_sample_rate_change_per_level` DOUBLE NULL DEFAULT NULL,
  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
  `nbins_cats` INT(11) NULL DEFAULT NULL,
  `sample_rate` DOUBLE NULL DEFAULT NULL,
  `calibration_frame` TEXT NULL DEFAULT NULL,
  `distribution` TEXT NULL DEFAULT NULL,
  `class_sampling_factors` TEXT NULL DEFAULT NULL,
  `check_constant_response` TEXT NULL DEFAULT NULL,
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,
  
  PRIMARY KEY (DRF_model_id,actual_or_default),
  CONSTRAINT DRF_model_fk FOREIGN KEY (DRF_model_id) REFERENCES models (model_id)
);
# GLM
drop table if exists GLM_model;
CREATE TABLE IF NOT EXISTS GLM_model (
  GLM_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `objective_epsilon` DOUBLE NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `family` TEXT NULL DEFAULT NULL,

  `missing_values_handling` TEXT NULL DEFAULT NULL,
  `tweedie_link_power` DOUBLE NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
  `nfolds` INT(11) NULL DEFAULT NULL,
  `keep_cross_validation_models` TEXT NULL DEFAULT NULL,
  `beta_constraints` TEXT NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `prior` DOUBLE NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,
  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `balance_classes` TEXT NULL DEFAULT NULL,
  `theta` DOUBLE NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `offset_column` TEXT NULL DEFAULT NULL,
  `lambda_search` TEXT NULL DEFAULT NULL,
  `custom_metric_func` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `standardize` TEXT NULL DEFAULT NULL,
  `interactions` TEXT NULL DEFAULT NULL,
  `ignored_columns` text NULL DEFAULT NULL,
  `score_each_iteration` TEXT NULL DEFAULT NULL,
  `intercept` TEXT NULL DEFAULT NULL,
  `link` TEXT NULL DEFAULT NULL,
  `gradient_epsilon` DOUBLE NULL DEFAULT NULL,
  `alpha` text NULL DEFAULT NULL,
  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
  `non_negative` TEXT NULL DEFAULT NULL,
  `early_stopping` TEXT NULL DEFAULT NULL,
  `max_active_predictors` INT(11) NULL DEFAULT NULL,
  `compute_p_values` TEXT NULL DEFAULT NULL,
  `solver` TEXT NULL DEFAULT NULL,
  `beta_epsilon` DOUBLE NULL DEFAULT NULL,
  `nlambdas` INT(11) NULL DEFAULT NULL,
  `fold_assignment` TEXT NULL DEFAULT NULL,
  `tweedie_variance_power` DOUBLE NULL DEFAULT NULL,
  `weights_column` TEXT NULL DEFAULT NULL,
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
  `interaction_pairs` TEXT NULL DEFAULT NULL,
  `obj_reg` DOUBLE NULL DEFAULT NULL,
  `lambda_min_ratio` DOUBLE NULL DEFAULT NULL,
  `max_iterations` INT(11) NULL DEFAULT NULL,
  `class_sampling_factors` TEXT NULL DEFAULT NULL,
  `remove_collinear_columns` TEXT NULL DEFAULT NULL,
  `lambda` text NULL DEFAULT NULL,

  PRIMARY KEY (GLM_model_id,actual_or_default),
  CONSTRAINT GLM_model_fk FOREIGN KEY (GLM_model_id) REFERENCES models (model_id)
);
# DeepLearning
drop table if exists DeepLearning_model;
CREATE TABLE IF NOT EXISTS DeepLearning_model (
  DeepLearning_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `single_node_mode` TEXT NULL DEFAULT NULL,
  `overwrite_with_best_model` TEXT NULL DEFAULT NULL,
  `replicate_training_data` TEXT NULL DEFAULT NULL,
  `stopping_tolerance` DOUBLE NULL DEFAULT NULL,
  `quiet_mode` TEXT NULL DEFAULT NULL,
  `export_weights_and_biases` TEXT NULL DEFAULT NULL,
  `hidden` text NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `activation` TEXT NULL DEFAULT NULL,
  `score_each_iteration` TEXT NULL DEFAULT NULL,
  `loss` TEXT NULL DEFAULT NULL,
  `score_validation_samples` INT(11) NULL DEFAULT NULL,
  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
  `initial_biases` TEXT NULL DEFAULT NULL,
  `l2` DOUBLE NULL DEFAULT NULL,
  `sparse` TEXT NULL DEFAULT NULL,
  `l1` DOUBLE NULL DEFAULT NULL,
  `missing_values_handling` TEXT NULL DEFAULT NULL,
  `stopping_metric` TEXT NULL DEFAULT NULL,
  `force_load_balance` TEXT NULL DEFAULT NULL,
  `epochs` DOUBLE NULL DEFAULT NULL,
  `rate` DOUBLE NULL DEFAULT NULL,
  `classification_stop` DOUBLE NULL DEFAULT NULL,
  `max_categorical_features` INT(11) NULL DEFAULT NULL,
  `score_validation_sampling` TEXT NULL DEFAULT NULL,
  `offset_column` TEXT NULL DEFAULT NULL,
  `quantile_alpha` DOUBLE NULL DEFAULT NULL,
  `reproducible` TEXT NULL DEFAULT NULL,
  `train_samples_per_iteration` INT(11) NULL DEFAULT NULL,
  `tweedie_power` DOUBLE NULL DEFAULT NULL,
  `elastic_averaging_regularization` DOUBLE NULL DEFAULT NULL,
  `target_ratio_comm_to_comp` DOUBLE NULL DEFAULT NULL,
  `regression_stop` DOUBLE NULL DEFAULT NULL,
  `initial_weight_distribution` TEXT NULL DEFAULT NULL,
  `initial_weights` TEXT NULL DEFAULT NULL,
  `rate_decay` DOUBLE NULL DEFAULT NULL,
  `fold_assignment` TEXT NULL DEFAULT NULL,
  `momentum_stable` DOUBLE NULL DEFAULT NULL,
  `autoencoder` TEXT NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `average_activation` DOUBLE NULL DEFAULT NULL,
  `score_training_samples` INT(11) NULL DEFAULT NULL,
  `input_dropout_ratio` DOUBLE NULL DEFAULT NULL,
  `nfolds` INT(11) NULL DEFAULT NULL,
  `keep_cross_validation_models` TEXT NULL DEFAULT NULL,
  `categorical_encoding` TEXT NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `max_w2` DOUBLE NULL DEFAULT NULL,
  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
  `fast_mode` TEXT NULL DEFAULT NULL,
  `nesterov_accelerated_gradient` TEXT NULL DEFAULT NULL,
  `checkpoint` TEXT NULL DEFAULT NULL,
  `balance_classes` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `adaptive_rate` TEXT NULL DEFAULT NULL,
  `momentum_ramp` DOUBLE NULL DEFAULT NULL,
  `epsilon` DOUBLE NULL DEFAULT NULL,
  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
  `mini_batch_size` INT(11) NULL DEFAULT NULL,
  `score_interval` DOUBLE NULL DEFAULT NULL,
  `initial_weight_scale` DOUBLE NULL DEFAULT NULL,
  `hidden_dropout_ratios` text NULL DEFAULT NULL,
  `elastic_averaging_moving_rate` DOUBLE NULL DEFAULT NULL,
  `col_major` TEXT NULL DEFAULT NULL,
  `stopping_rounds` INT(11) NULL DEFAULT NULL,
  `distribution` TEXT NULL DEFAULT NULL,
  `class_sampling_factors` TEXT NULL DEFAULT NULL,
  `momentum_start` DOUBLE NULL DEFAULT NULL,
  `shuffle_training_data` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
  `use_all_factor_levels` TEXT NULL DEFAULT NULL,
  `variable_importances` TEXT NULL DEFAULT NULL,
  `rate_annealing` DOUBLE NULL DEFAULT NULL,
  `score_duty_cycle` DOUBLE NULL DEFAULT NULL,
  `huber_alpha` DOUBLE NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `pretrained_autoencoder` TEXT NULL DEFAULT NULL,
  `standardize` TEXT NULL DEFAULT NULL,
  `ignored_columns` text NULL DEFAULT NULL,
  `rho` DOUBLE NULL DEFAULT NULL,
  `sparsity_beta` DOUBLE NULL DEFAULT NULL,
  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
  `elastic_averaging` TEXT NULL DEFAULT NULL,
  `weights_column` TEXT NULL DEFAULT NULL,
  `diagnostics` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  
  PRIMARY KEY (DeepLearning_model_id,actual_or_default),
  CONSTRAINT DeepLearning_model_fk FOREIGN KEY (DeepLearning_model_id) REFERENCES models (model_id)
);

# XRT
drop table if exists XRT_model;
CREATE TABLE IF NOT EXISTS XRT_model (
  XRT_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `min_split_improvement` DOUBLE NULL DEFAULT NULL,
  `fold_column` TEXT NULL DEFAULT NULL,
  `col_sample_rate_per_tree` DOUBLE NULL DEFAULT NULL,
  `fold_assignment` TEXT NULL DEFAULT NULL,
  `score_tree_interval` INT(11) NULL DEFAULT NULL,
  `sample_rate_per_class` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
  `binomial_double_trees` TEXT NULL DEFAULT NULL,
  `nfolds` INT(11) NULL DEFAULT NULL,
  `keep_cross_validation_models` TEXT NULL DEFAULT NULL,
  `offset_column` TEXT NULL DEFAULT NULL,
  `categorical_encoding` TEXT NULL DEFAULT NULL,
  `checkpoint` TEXT NULL DEFAULT NULL,
  `stopping_tolerance` DOUBLE NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
  `calibrate_model` TEXT NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `balance_classes` TEXT NULL DEFAULT NULL,
  `r2_stopping` DOUBLE NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `max_depth` INT(11) NULL DEFAULT NULL,
  `custom_metric_func` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `build_tree_one_node` TEXT NULL DEFAULT NULL,
  `ntrees` INT(11) NULL DEFAULT NULL,
  `ignored_columns` text NULL DEFAULT NULL,
  `min_rows` DOUBLE NULL DEFAULT NULL,
  `mtries` INT(11) NULL DEFAULT NULL,
  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
  `score_each_iteration` TEXT NULL DEFAULT NULL,
  `nbins_top_level` INT(11) NULL DEFAULT NULL,
  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
  `nbins` INT(11) NULL DEFAULT NULL,
  `histogram_type` TEXT NULL DEFAULT NULL,
  `stopping_metric` TEXT NULL DEFAULT NULL,
  `weights_column` TEXT NULL DEFAULT NULL,
  `stopping_rounds` INT(11) NULL DEFAULT NULL,
  `col_sample_rate_change_per_level` DOUBLE NULL DEFAULT NULL,
  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
  `nbins_cats` INT(11) NULL DEFAULT NULL,
  `sample_rate` DOUBLE NULL DEFAULT NULL,
  `calibration_frame` TEXT NULL DEFAULT NULL,
  `distribution` TEXT NULL DEFAULT NULL,
  `class_sampling_factors` TEXT NULL DEFAULT NULL,
  `check_constant_response` TEXT NULL DEFAULT NULL,
  `ignore_const_cols` TEXT NULL DEFAULT NULL,
  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL,
  
  PRIMARY KEY (XRT_model_id,actual_or_default),
  CONSTRAINT XRT_model_fk FOREIGN KEY (XRT_model_id) REFERENCES models (model_id)
);
# StackedEnsemble_BestOfFamily
drop table if exists StackedEnsemble_BestOfFamily_model;
CREATE TABLE IF NOT EXISTS StackedEnsemble_BestOfFamily_model (
  StackedEnsemble_BestOfFamily_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `blending_frame` TEXT NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `metalearner_params` TEXT NULL DEFAULT NULL,
  `metalearner_algorithm` TEXT NULL DEFAULT NULL,
  `keep_levelone_frame` TEXT NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `base_models` TEXT NULL DEFAULT NULL,
  `metalearner_fold_column` TEXT NULL DEFAULT NULL,
  `metalearner_fold_assignment` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `metalearner_nfolds` INT(11) NULL DEFAULT NULL,
  
  PRIMARY KEY (StackedEnsemble_BestOfFamily_model_id,actual_or_default),
  CONSTRAINT StackedEnsemble_BestOfFamily_model_fk FOREIGN KEY (StackedEnsemble_BestOfFamily_model_id) REFERENCES models (model_id)
);
# StackedEnsemble_AllModels
drop table if exists StackedEnsemble_AllModels_model;
CREATE TABLE IF NOT EXISTS StackedEnsemble_AllModels_model (
  StackedEnsemble_AllModels_model_id VARCHAR(255) NOT NULL,
  #model_category VARCHAR(45) NOT NULL,
  actual_or_default varchar(25) default false,
  
  `blending_frame` TEXT NULL DEFAULT NULL,
  `validation_frame` TEXT NULL DEFAULT NULL,
  `training_frame` TEXT NULL DEFAULT NULL,
  `response_column` TEXT NULL DEFAULT NULL,
  `metalearner_params` TEXT NULL DEFAULT NULL,
  `metalearner_algorithm` TEXT NULL DEFAULT NULL,
  `keep_levelone_frame` TEXT NULL DEFAULT NULL,
  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
  `base_models` TEXT NULL DEFAULT NULL,
  `metalearner_fold_column` TEXT NULL DEFAULT NULL,
  `metalearner_fold_assignment` TEXT NULL DEFAULT NULL,
  `seed` BIGINT(20) NULL DEFAULT NULL,
  `metalearner_nfolds` INT(11) NULL DEFAULT NULL,
  
  PRIMARY KEY (StackedEnsemble_AllModels_model_id,actual_or_default),
  CONSTRAINT StackedEnsemble_AllModels_model_fk FOREIGN KEY (StackedEnsemble_AllModels_model_id) REFERENCES models (model_id)
);
# for each model, there are different hyper parameters.
# each hyper parameter has default value and actual value.
/*drop table if exists hyperparameters;
create table hyperparameters(
	model_id varchar(255) not null,
    # True means actual, False means default
    actual_or_default varchar(25) default false,
    # not sure what is it
    training_frame text default null, 
    validation_frame text default null, 
    nfolds int default null, 
    keep_cross_validation_models text default null,
    keep_cross_validation_predictions text default null,
    keep_cross_validation_fold_assignment text default null,
    score_each_iteration text default null,
    score_tree_interval int default null,
    fold_assignment text default null,
    fold_column text default null,
    response_column text default null,
    # ignored_columns is a list, might be another table
    ignored_columns text default null,
    ignore_const_cols text default null,
     # offset_column & weights_column  might be another table
    offset_column text default null,
    weights_column text default null,
    balance_classes text default null,
    class_sampling_factors text default null,
    max_after_balance_size float default 0.0,
    max_confusion_matrix_size int default 0,
    max_hit_ratio_k int default 0,
    ntrees int default 0,
    max_depth int default 0,
    min_rows float default 0.0,
    nbins int default 0,
    nbins_top_level int default 0,
    nbins_cats int default 0,
    r2_stopping double default 0.0,
    stopping_rounds int default 0,
    stopping_metric text default null,
    stopping_tolerance double default 0.0,
    max_runtime_secs double default 0.0,
    seed bigint default 0,
    build_tree_one_node text default null,
    mtries int default 0,
    sample_rate double default 0.0,
    sample_rate_per_class text default null,
    binomial_double_trees text default null,
    checkpoint text default null,
    col_sample_rate_change_per_level float default 0.0,
    col_sample_rate_per_tree float default 0.0,
    min_split_improvement double default 0.0,
    histogram_type text default null,
    categorical_encoding text default null,
    calibrate_model text default null,
    calibration_frame text default null,
    distribution text default null,
    custom_metric_func text default null,
    export_checkpoints_dir text default null,
    check_constant_response text default null,
    constraint hyper_pk primary key (model_id,actual_or_default),
    constraint hyper_fk foreign key (model_id) references models(model_id)
);*/

# each model has 


/*# create a table to store the measurement
drop table if exists leaderboard;
create table leaderboard(
	run_id varchar(255) not null,
    model_id varchar(255) NOT NULL,
    #measurement_value double not null,
	constraint leaderboard_pk primary key (model_id(255)),
    constraint leaderboard_fk foreign key (run_id) references models(run_id)
);*/


# create a table that seperate the models into several categories

/*drop table if exists run_models;
create table run_models(
	runtime_id int not null,
	model_id int not null,
    constraint run_models_pk primary key (runtime_id,model_id),
    constraint run_models_fk foreign key (model_id) references models(model_id)
);    */


# Create table to store each measurement for each model
# In my case, it is not necassery to store measurement in another table
# but if we do both classification and regression, the measure ments are different
# it is better to store in another table
/*drop table if exists leaderboard;
create table leaderboard(
	model_id varchar(255) not null,
    mrd double default null,
    rmse double default null,
    mse double default null,
    mae double default null,
    rmsle double default null,
    constraint leaderboard_pk primary key (model_id(255)),
    constraint leaderboard_fk foreign key (model_id) references models(model_id)
);*/

/*
#ALTER TABLE iteration2_500
#drop dataset_id;

ALTER TABLE iteration2_500
ADD dataset_id text;

UPDATE iteration2_500
SET dataset_id = 1;

select * from iteration2_500;
describe iteration2_500;
insert into models(model_name,mrd,rmse,mse,mae,rmsle,dataset_id)
select * from iteration2_500;
select * from models;
##*/



create database if not exists hyperparameter;
use hyperparameter;
#

# 
drop table if exists dataset_cat;
create table if not exists dataset_cat(
	dataset_id int primary key auto_increment,
    dataset_name text not null
);

#
drop table if exists hyperparameters;
drop table if exists models;
create table models(
	dataset_id int,
	model_id int primary key auto_increment,
    model_name text NOT NULL,
    mrd double default NULL,
    rmse double default NULL,
    mse double default NULL,
    mae double default NULL,
    rmsle double default NULL,
    #constraint fk_dataset_id foreign key(dataset_id) references dataset_cat(dataset_id),
	`histogram_type` TEXT NULL DEFAULT NULL,
	`learn_rate` DOUBLE NULL DEFAULT NULL,
	`fold_column` TEXT NULL DEFAULT NULL,
	`col_sample_rate_per_tree` DOUBLE NULL DEFAULT NULL,
	`learn_rate_annealing` DOUBLE NULL DEFAULT NULL,
	`score_tree_interval` INT(11) NULL DEFAULT NULL,
	`sample_rate_per_class` TEXT NULL DEFAULT NULL,
	`seed` BIGINT(20) NULL DEFAULT NULL,
	`weights_column` TEXT NULL DEFAULT NULL,
	`nfolds` INT(11) NULL DEFAULT NULL,
	`keep_cross_validation_models` TEXT NULL DEFAULT NULL,
	`offset_column` TEXT NULL DEFAULT NULL,
	`categorical_encoding` TEXT NULL DEFAULT NULL,
	`checkpoint` TEXT NULL DEFAULT NULL,
	  `stopping_tolerance` DOUBLE NULL DEFAULT NULL,
	  `monotone_constraints` TEXT NULL DEFAULT NULL,
	  `training_frame` TEXT NULL DEFAULT NULL,
	  `max_hit_ratio_k` INT(11) NULL DEFAULT NULL,
	  `max_runtime_secs` DOUBLE NULL DEFAULT NULL,
	  `calibrate_model` TEXT NULL DEFAULT NULL,
	  `max_abs_leafnode_pred` DOUBLE NULL DEFAULT NULL,
	  `export_checkpoints_dir` TEXT NULL DEFAULT NULL,
	  `balance_classes` TEXT NULL DEFAULT NULL,
	  `sample_rate` DOUBLE NULL DEFAULT NULL,
	  `pred_noise_bandwidth` DOUBLE NULL DEFAULT NULL,
	  `max_depth` INT(11) NULL DEFAULT NULL,
	  `custom_metric_func` TEXT NULL DEFAULT NULL,
	  #`model_id` TEXT NULL DEFAULT NULL,
	  `build_tree_one_node` TEXT NULL DEFAULT NULL,
	  `ntrees` INT(11) NULL DEFAULT NULL,
	  `min_split_improvement` DOUBLE NULL DEFAULT NULL,
	  `ignored_columns` JSON NULL DEFAULT NULL,
	  `tweedie_power` DOUBLE NULL DEFAULT NULL,
	  `min_rows` DOUBLE NULL DEFAULT NULL,
	  `max_after_balance_size` DOUBLE NULL DEFAULT NULL,
	  `score_each_iteration` TEXT NULL DEFAULT NULL,
	  `max_confusion_matrix_size` INT(11) NULL DEFAULT NULL,
	  `quantile_alpha` DOUBLE NULL DEFAULT NULL,
	  `col_sample_rate_change_per_level` DOUBLE NULL DEFAULT NULL,
	  `nbins` INT(11) NULL DEFAULT NULL,
	  `validation_frame` TEXT NULL DEFAULT NULL,
	  `huber_alpha` DOUBLE NULL DEFAULT NULL,
	  `col_sample_rate` DOUBLE NULL DEFAULT NULL,
	  `fold_assignment` TEXT NULL DEFAULT NULL,
	  `keep_cross_validation_predictions` TEXT NULL DEFAULT NULL,
	  `stopping_rounds` INT(11) NULL DEFAULT NULL,
	  `nbins_top_level` INT(11) NULL DEFAULT NULL,
	  `stopping_metric` TEXT NULL DEFAULT NULL,
	  `nbins_cats` INT(11) NULL DEFAULT NULL,
	  `r2_stopping` DOUBLE NULL DEFAULT NULL,
	  `calibration_frame` TEXT NULL DEFAULT NULL,
	  `distribution` TEXT NULL DEFAULT NULL,
	  `class_sampling_factors` TEXT NULL DEFAULT NULL,
	  `check_constant_response` TEXT NULL DEFAULT NULL,
	  `ignore_const_cols` TEXT NULL DEFAULT NULL,
	  `keep_cross_validation_fold_assignment` TEXT NULL DEFAULT NULL
);

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
##



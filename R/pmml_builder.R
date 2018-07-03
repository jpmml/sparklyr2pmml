library("sparklyr")

PMMLBuilder = function(sc, tbl_spark, ml_pipeline_model){
	java_tbl_spark = spark_jobj(spark_dataframe(tbl_spark))
	java_schema = invoke(java_tbl_spark, "schema")
	java_pipeline_model = spark_jobj(ml_pipeline_model)

	java_pmml_builder = invoke_new(sc, "org.jpmml.sparkml.PMMLBuilder", java_schema, java_pipeline_model)
	
	return (new("PMMLBuilder", sc = sc, java_pmml_builder = java_pmml_builder))
}

setClass("PMMLBuilder",
	slots = c(
		sc = "spark_connection",
		java_pmml_builder = "spark_jobj"
	)
)

setGeneric("build",
	def = function(pmml_builder){
		standardGeneric("build")
	}
)
setMethod("build",
	signature = c("PMMLBuilder"),
	definition = function(pmml_builder){
		return (invoke(pmml_builder@java_pmml_builder, "build"))
	}
)

setGeneric("buildByteArray",
	def = function(pmml_builder){
		standardGeneric("buildByteArray")
	}
)
setMethod("buildByteArray",
	signature = c("PMMLBuilder"),
	definition = function(pmml_builder){
		return (invoke(pmml_builder@java_pmml_builder, "buildByteArray"))
	}
)

setGeneric("buildFile",
	def = function(pmml_builder, path){
		standardGeneric("buildFile")
	}
)
setMethod("buildFile",
	signature = c("PMMLBuilder", "character"),
	definition = function(pmml_builder, path){
		file = invoke(pmml_builder@java_pmml_builder, "buildFile", invoke_new(pmml_builder@sc, "java.io.File", path))
	
		return (invoke(file, "getAbsolutePath"))
	}
)

setGeneric("putOption",
	def = function(pmml_builder, ml_pipeline_stage, key, value){
		standardGeneric("putOption")
	}
)
setMethod("putOption",
	#signature = c("PMMLBuilder", "ml_pipeline_stage", "character", "object"),
	definition = function(pmml_builder, ml_pipeline_stage, key, value){
		if(is.null(ml_pipeline_stage)){
			invoke(pmml_builder@java_pmml_builder, "putOption", key, value)
		} else
		
		{
			java_pipeline_stage = spark_jobj(ml_pipeline_stage)

			invoke(pmml_builder@java_pmml_builder, "putOption", java_pipeline_stage, key, value)
		}

		return (pmml_builder)
	}
)

setGeneric("verify",
	def = function(pmml_builder, tbl_spark){
		standardGeneric("verify")
	}
)
setMethod("verify",
	signature = c("PMMLBuilder", "tbl_spark"),
	definition = function(pmml_builder, tbl_spark){
		java_tbl_spark = spark_jobj(spark_dataframe(tbl_spark))
		
		invoke(pmml_builder@java_pmml_builder, "verify", java_tbl_spark)

		return (pmml_builder)
	}
)

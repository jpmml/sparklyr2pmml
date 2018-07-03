context("README")

library("dplyr")
library("sparklyr")

config = spark_config()
config[["sparklyr.jars.default"]] = Sys.getenv("JPMML_SPARKML_JAR")

sc = spark_connect(master = "local", config = config)

data(iris)

iris_df = copy_to(sc, iris)

iris_pipeline = ml_pipeline(sc) %>%
	ft_r_formula(Species ~ .) %>%
	ml_decision_tree_classifier()

iris_pipeline_model = ml_fit(iris_pipeline, iris_df)

pmmlBuilder = PMMLBuilder(sc, iris_df, iris_pipeline_model)

test_that("PMMLBuilder is S4 object", {
	expect_true(isS4(pmmlBuilder))
	expect_true(is(pmmlBuilder@java_pmml_builder, "spark_jobj"))
})

pmmlBuilder = verify(pmmlBuilder, sdf_sample(iris_df, 0.1, replacement = FALSE))

pmml = build(pmmlBuilder)

test_that("PMML is Spark Java object", {
	expect_true(is(pmml, "spark_jobj"))
})

pmmlByteArray = buildByteArray(pmmlBuilder)

test_that("PMML byte array is raw bytes", {
	expect_true(is(pmmlByteArray, "raw"))
})

pmmlString = rawToChar(pmmlByteArray)

test_that("PMML string is valid PMML markup", {
	expect_true(grepl("<PMML xmlns=\"http://www.dmg.org/PMML-4_3\" xmlns:data=\"http://jpmml.org/jpmml-model/InlineTable\" version=\"4.3\">", pmmlString))
	expect_true(grepl("<VerificationFields>", pmmlString))
})

pmmlBuilder = putOption(pmmlBuilder, NULL, "compact", FALSE)

nonCompactPmmlPath = buildFile(pmmlBuilder, tempfile(pattern = "sparklyr2pmml-", fileext = ".pmml"))

classifier = iris_pipeline_model$stages[[2]]

pmmlBuilder = putOption(pmmlBuilder, classifier, "compact", TRUE)

compactPmmlPath = buildFile(pmmlBuilder, tempfile(pattern = "sparklyr2pmml-", fileext = ".pmml"))

test_that("Decision tree compaction reduces the size of PMML markup", {
	expect_gt(file.size(nonCompactPmmlPath), file.size(compactPmmlPath) + 100)
})

spark_disconnect(sc)

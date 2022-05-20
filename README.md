Sparklyr2PMML
=============

R library for converting [Apache Spark ML](https://spark.apache.org/) pipelines to PMML.

# Features #

This package is a thin R wrapper for the [JPMML-SparkML](https://github.com/jpmml/jpmml-sparkml#features) library.

# Prerequisites #

* Apache Spark 2.0.X, 2.1.X, 2.2.X, 2.3.X, 2.4.X, 3.0.X, 3.1.X or 3.2.X.
* R 3.3 or newer.

# Installation #

Install from GitHub using the [`devtools`](https://cran.r-project.org/web/packages/devtools/) package:

```R
library("devtools")

install_github("jpmml/sparklyr2pmml")
```

# Configuration and usage #

Sparklyr2PMML must be paired with JPMML-SparkML based on the following compatibility matrix:

| Apache Spark version | JPMML-SparkML branch | Latest JPMML-SparkML version |
|----------------------|----------------------|------------------------------|
| 3.0.X | [`2.0.X`](https://github.com/jpmml/jpmml-sparkml/tree/2.0.X) | 2.0.0 |
| 3.1.X | [`2.1.X`](https://github.com/jpmml/jpmml-sparkml/tree/2.1.X) | 2.1.0 |
| 3.2.X | [`master`](https://github.com/jpmml/jpmml-sparkml/tree/master) | 2.2.0 |

Launch Sparklyr; use the `sparklyr.connect.packages` configuration option to specify the coordinates of relevant JPMML-SparkML modules:

* `org.jpmml:pmml-sparkml:${version}` - Core module.
* `org.jpmml:pmml-sparkml-lightgbm:${version}` - LightGBM via SynapseML extension module.
* `org.jpmml:pmml-sparkml-xgboost:${version}` - XGBoost via XGBoost4J-Spark extension module.

Launching core:

```R
library("sparklyr")

config = spark_config()
config[["sparklyr.connect.packages"]] = "org.jpmml:pmml-sparkml:${version}"

sc = spark_connect(master = "local", config = config)
```

Fitting a Spark ML pipeline:

```R
library("dplyr")
library("sparklyr")

data(iris)

iris_df = copy_to(sc, iris)

iris_pipeline = ml_pipeline(sc) %>%
	ft_r_formula(Species ~ .) %>%
	ml_decision_tree_classifier()

iris_pipeline_model = ml_fit(iris_pipeline, iris_df)
```

Exporting the fitted Spark ML pipeline to a PMML file:

```R
library("sparklyr2pmml")

pmmlBuilder = PMMLBuilder(sc, iris_df, iris_pipeline_model)

buildFile(pmmlBuilder, "DecisionTreeIris.pmml")
```

# License #

Sparklyr2PMML is licensed under the terms and conditions of the [GNU Affero General Public License, Version 3.0](https://www.gnu.org/licenses/agpl-3.0.html).

If you would like to use Sparklyr2PMML in a proprietary software project, then it is possible to enter into a licensing agreement which makes Sparklyr2PMML available under the terms and conditions of the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause) instead.

# Additional information #

Sparklyr2PMML is developed and maintained by Openscoring Ltd, Estonia.

Interested in using [Java PMML API](https://github.com/jpmml) software in your company? Please contact [info@openscoring.io](mailto:info@openscoring.io)

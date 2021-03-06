Sparklyr2PMML
=============

R library for converting Apache Spark ML pipelines to PMML.

# Features #

This package provides R wrapper classes and functions for the [JPMML-SparkML](https://github.com/jpmml/jpmml-sparkml) library. For the full list of supported Apache Spark ML Estimator and Transformer types, please refer to JPMML-SparkML documentation.

# Prerequisites #

* [Apache Spark](https://spark.apache.org/) 2.0.X, 2.1.X, 2.2.X, 2.3.X, 2.4.X or 3.0.X.
* R 3.3 or newer.

# Installation #

Install from GitHub using the [`devtools` package](https://cran.r-project.org/web/packages/devtools/):

```R
library("devtools")

install_git("git://github.com/jpmml/sparklyr2pmml.git")
```

# Configuration and usage #

Sparklyr2PMML must be paired with JPMML-SparkML based on the following compatibility matrix:

| Apache Spark version | JPMML-SparkML development branch | JPMML-SparkML uber-JAR file |
|----------------------|----------------------------------|-----------------------------|
| 2.0.X | `1.1.X` (Archived) | [1.1.23](https://github.com/jpmml/jpmml-sparkml/releases/download/1.1.23/jpmml-sparkml-executable-1.1.23.jar) |
| 2.1.X | `1.2.X` (Archived) | [1.2.15](https://github.com/jpmml/jpmml-sparkml/releases/download/1.2.15/jpmml-sparkml-executable-1.2.15.jar) |
| 2.2.X | `1.3.X` (Archived) | [1.3.15](https://github.com/jpmml/jpmml-sparkml/releases/download/1.3.15/jpmml-sparkml-executable-1.3.15.jar) |
| 2.3.X | `1.4.X` | [1.4.18](https://github.com/jpmml/jpmml-sparkml/releases/download/1.4.18/jpmml-sparkml-executable-1.4.18.jar) |
| 2.4.X | `1.5.X` | [1.5.11](https://github.com/jpmml/jpmml-sparkml/releases/download/1.5.11/jpmml-sparkml-executable-1.5.11.jar) |
| 3.0.X | `master` | [1.6.3](https://github.com/jpmml/jpmml-sparkml/releases/download/1.6.3/jpmml-sparkml-executable-1.6.3.jar) |

Adding the JPMML-SparkML uber-JAR file to Sparklyr execution environment:

```R
library("sparklyr")

config = spark_config()
config[["sparklyr.jars.default"]] = "/path/to/jpmml-sparkml-executable-${version}.jar"

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

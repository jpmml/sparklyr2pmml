Sparklyr2PMML
=============

R library for converting Apache Spark ML pipelines to PMML.

# Features #

This package provides R wrapper classes and functions for the [JPMML-SparkML](https://github.com/jpmml/jpmml-sparkml) library. For the full list of supported Apache Spark ML Estimator and Transformer types, please refer to JPMML-SparkML documentation.

# Prerequisites #

* [Apache Spark](http://spark.apache.org/) 2.0.X, 2.1.X, 2.2.X or 2.3.X.
* R 3.3 or newer.

# Installation #

Install from GitHub using the [`devtools` package](http://cran.r-project.org/web/packages/devtools/):

```R
library("devtools")

install_git("git://github.com/jpmml/sparklyr2pmml.git")
```

# Configuration and usage #

Sparklyr2PMML must be paired with JPMML-SparkML based on the following compatibility matrix:

| Apache Spark version | JPMML-SparkML development branch | JPMML-SparkML uber-JAR file |
|----------------------|----------------------------------|-----------------------------|
| 2.0.X | `1.1.X` | [1.1.20](https://github.com/jpmml/jpmml-sparkml/releases/download/1.1.20/jpmml-sparkml-executable-1.1.20.jar) |
| 2.1.X | `1.2.X` | [1.2.12](https://github.com/jpmml/jpmml-sparkml/releases/download/1.2.12/jpmml-sparkml-executable-1.2.12.jar) |
| 2.2.X | `1.3.X` | [1.3.8](https://github.com/jpmml/jpmml-sparkml/releases/download/1.3.8/jpmml-sparkml-executable-1.3.8.jar) |
| 2.3.X | `master` | [1.4.5](https://github.com/jpmml/jpmml-sparkml/releases/download/1.4.5/jpmml-sparkml-executable-1.4.5.jar) |

Adding the JPMML-SparkML uber-JAR file to Sparklyr execution environment:

```R
library("sparklyr")

config = spark_config()
config[["sparklyr.jars.default"]] = "/path/to/jpmml-sparkml-executable-${version}.jar"

sc = spark_connect(master = "local", config = config)
```

Fitting an example pipeline model:

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

Exporting the fitted example pipeline model to a PMML file:

```R
library("sparklyr2pmml")

pmmlBuilder = PMMLBuilder(sc, iris_df, iris_pipeline_model)

buildFile(pmmlBuilder, "DecisionTreeIris.pmml")
```

# License #

Sparklyr2PMML is dual-licensed under the [GNU Affero General Public License (AGPL) version 3.0](http://www.gnu.org/licenses/agpl-3.0.html), and a commercial license.

# Additional information #

Sparklyr2PMML is developed and maintained by Openscoring Ltd, Estonia.

Interested in using JPMML software in your application? Please contact [info@openscoring.io](mailto:info@openscoring.io)

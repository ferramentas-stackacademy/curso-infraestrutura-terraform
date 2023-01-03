import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, TimestampType, FloatType
from pyspark.sql.window import Window
from pyspark.sql.functions import col, row_number
from pyspark.sql.functions import *
from delta import *

builder = pyspark.sql.SparkSession.builder.appName("MyApp") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")\

spark = configure_spark_with_delta_pip(builder).getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

# config
people_path = "s3a://data-platform-bronze-prod/people_table"
emp_path = "s3a://data-platform-bronze-prod/emp"
dep_path = "s3a://data-platform-bronze-prod/dep"
dim_path = "s3a://data-platform-bronze-prod/dimension"

# printing table
def show_table(table_path):
    print("\n Show the table:")
    df = spark.read.format("delta").load(table_path)
    df.show()


def generate_Data(table_path, table_path2, table_path3):
    
    print("\n creating table:")
    employees = [(1, "James", "", "Smith", "36636", "M", 5000, 1,222),
                 (2, "Michael", "Rose", "", "40288", "M", 4000, 2,333),
                 (3, "Robert", "", "Williams", "42114", "M", 3500, 3,444),
                 (4, "Maria", "Anne", "Jones", "39192", "F", 3800, 3,555),
                 (5, "Jen", "Mary", "Brown", "", "F", -1, 3,666)]

    schema_emp = StructType([
        StructField("id", IntegerType(), True),
        StructField("firstname", StringType(), True),
        StructField("middlename", StringType(), True),
        StructField("lastname", StringType(), True),
        StructField("cod_entry", StringType(), True),
        StructField("gender", StringType(), True),
        StructField("salary", StringType(), True),
        StructField("DepID", IntegerType(), True),
        StructField("CostCenter", StringType(), True)
    ])

    df_dep = [(1, "IT"),
              (2, "Marketing"),
              (3, "Human Resources"),
              (4, "Sales")]

    schema_dep = StructType([
        StructField("id", IntegerType(), True),
        StructField("Department", StringType(), True),
    ])

    df_emp = spark.createDataFrame(data=employees, schema=schema_emp)
    df_dep = spark.createDataFrame(data=df_dep, schema=schema_dep)

    print("saving delta tables..\n")
    df_emp.write.format("delta")\
        .option("overwriteSchema", "true")\
        .mode("overwrite")\
        .save(table_path)
    
    df_dep.write.format("delta")\
        .option("overwriteSchema", "true")\
        .mode("overwrite")\
        .save(table_path2)

    print("loading delta tables..\n")
    df_emp = spark.read.format("delta").load(table_path)
    df_dep = spark.read.format("delta").load(table_path2)

    df_emp.show()
    df_dep.show()

    print("creating delta views..\n")
    df_emp.createOrReplaceTempView('employees')
    df_dep.createOrReplaceTempView('departments')

    print("dimension table..\n")
    query = spark.sql('''select e.id,
                         e.firstname, 
                         e.middlename,
                         e.salary,
                         d.Department 
                         from employees e inner join departments d 
                         on e.id = d.id''')
    query.show()

    print("saving delta table for dimension table...")
    query.write.format("delta")\
        .mode("overwrite")\
        .save(table_path3)

generate_Data(emp_path, dep_path, dim_path)
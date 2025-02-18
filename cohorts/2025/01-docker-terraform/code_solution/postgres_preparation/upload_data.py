from sqlalchemy import create_engine
import pandas as pd

green_trips_df = pd.read_csv("data/green_tripdata_2019-10.csv", low_memory=False)
taxi_zones_map = pd.read_csv("data/taxi_zone_lookup.csv")

# initialize a SQLAlchemy Engine object that points to the Postgres DB in a Docker container
engine = create_engine("postgresql://postgres:root@localhost:5433/ny_taxi")

# Create columns in a new table in database "ny_taxi", based on data frame taxi_zones_map 
taxi_zones_map.head(0).to_sql("taxi_zones", engine, if_exists="replace")

# Write all the values of data frame "taxi_zones_map" to the Postgres table "taxi_zones"
taxi_zones_map.to_sql("taxi_zones", engine, if_exists="append")

green_trips_df.head(0).to_sql("green_taxi_data", engine, if_exists="replace")

# may need to pass in the ?? argument, an iterable, of pd.read_csv() to divide a large
# data set into smaller chunks during the read process
green_trips_df.to_sql("green_taxi_data", engine, chunksize=100000, if_exists="append")
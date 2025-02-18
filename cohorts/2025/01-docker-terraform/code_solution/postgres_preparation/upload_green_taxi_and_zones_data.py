"""
02/11/2025
Practice uploading the two csv files to a PostgreSQL database in a container

Steps:
1. Read csv file in a Pandas data frame, invoking the chunksize parameter to handle 
the read and write of big data set.
2. Use a sqlalchemy Engine instance to establish connection with the ny_taxi db 
in a PostgreSQL container. 
"""

import pandas as pd
from sqlalchemy import create_engine, text
import os

from dotenv import load_dotenv
load_dotenv()
postgres_user = os.getenv("PGUSER")
postgres_password = os.getenv("PGPASSWORD")

# read csv file "green_tripdata" into a Pandas data frame
green_trips = pd.read_csv("./data/green_tripdata_2019-10.csv")

# create a sqlalchemy Engine instance, for the database write operation
engine = create_engine(f"postgresql+psycopg2://{postgres_user}:{postgres_password}@localhost:5433/ny_taxi")

with engine.connect() as connection:
    # Check existing tables in the ny_taxi database
    result = connection.execute(text("""
        SELECT tablename 
        FROM pg_catalog.pg_tables 
        WHERE schemaname = 'public';
    """))
    
    # Print the table names
    for row in result:
        print(row[0])

# Create table structure with an empty data frame
green_trips.head(0).to_sql("green_taxi_data", con=engine, if_exists="replace")

# Write the entire data frame to the database in chunks
green_trips.to_sql(
    "green_taxi_data", 
    con=engine, 
    if_exists="append",
    chunksize=100000
)

# Read the "service zones" csv file into a Pandas data frame
service_zones_df = pd.read_csv("https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv")

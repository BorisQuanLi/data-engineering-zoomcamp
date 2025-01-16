"""
01/05/2025
After watching and, in the Jupyter Notebook upload-data.ipynb, following along with the YouTube lecture,
practice in this Python script implementing loading the downloaded dataset, in Parquet, onto the 
PostgreSQL database in the docker container.
"""

import pyarrow.parquet as pq
from sqlalchemy import create_engine

yellow_trips_parquest_table = pq.read_table('ny_taxi_postgres_data/yellow_tripdata_2024-10.parquet')

df = yellow_trips_parquest_table.to_pandas()

engine = create_engine("postgresql://postgres:root@localhost:5433/ny_taxi")

# create a SQL table schema whose columns are based on the pandas dataframe's columns
# 2:25, https://www.youtube.com/watch?v=B1WwATwf-vY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=9
df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')

# populate the SQL table with the rows of data of the Pandas data frame
df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')

import pandas as pd

try:
    df = pd.read_csv('D:\\Projects\\Taxi-Trip-Data-NYC-Kaggle\\taxi_tripdata.csv')
    print("File 'taxi_tripdata.csv' loaded successfully.")
    print(f"Dataset shape: {df.shape}")

    
    # --- 1. Null Value Handling ---
    print("\n--- Checking for Null Values ---")
    null_counts = df.isnull().sum()
    null_cols = null_counts[null_counts > 0]
    if not null_cols.empty:
        print("Null values found in the following columns:")
        print(null_cols)
    else:
        print("No null values found in any columns.")

    # --- 2. Data Inconsistency Checks ---
    print("\n--- Checking for Data Inconsistencies ---")

    # Check for zero-distance trips with a fare
    zero_dist_trips = df[(df['trip_distance'] == 0) & (df['fare_amount'] > 0)]
    print(f"\nNumber of trips with zero distance but a positive fare: {len(zero_dist_trips)}")

    # Check passenger count distribution
    print("\nPassenger count distribution:")
    print(df['passenger_count'].value_counts().sort_index())

    # Check for negative fare amounts
    negative_fare = df[df['fare_amount'] < 0]
    print(f"\nNumber of trips with negative fare_amount: {len(negative_fare)}")

    # --- 3. Standardization Checks ---
    print("\n--- Checking for Standardization Needs ---")

    # Check unique values for store_and_fwd_flag
    print("\nUnique values for 'store_and_fwd_flag':")
    print(df['store_and_fwd_flag'].value_counts())

    # Check unique values for payment_type
    print("\nUnique values for 'payment_type' (numeric codes):")
    print(df['payment_type'].value_counts().sort_index())

except FileNotFoundError:
    print("Error: 'taxi_tripdata.csv' not found.")
except Exception as e:
    print(f"An error occurred: {e}")
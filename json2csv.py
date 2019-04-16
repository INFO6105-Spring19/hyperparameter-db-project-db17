import json
import pandas as pd
from collections import defaultdict

with open("jsonfile") as file:
    data = json.load(file)
    
df = defaultdict(list)
for col in data:
    df[col] = list(data[col].values())

df = pd.DataFrame(df)

df.to_csv()

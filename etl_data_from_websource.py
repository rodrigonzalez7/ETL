# -*- coding: utf-8 -*-
"""ETL - Data from Websource.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1z2-UkcBj2fEeVa7ib9fOUYPMW9IYmUn4
"""

import sqlite3
import json
import requests
import pandas as pd
from sodapy import Socrata

#Connect to the database; if the database doesn't exists, it is created
conn = sqlite3.connect('Database.db')
#Connect to the data source
client = Socrata("www.datos.gov.co", None)
#Get filtered results from specific dataset in json format
results = client.get("w9zh-vetq",where = "fecha_corte >= '2024-01-01T00:00:00.000' and fecha_corte <= '2024-01-31T00:00:00.000' and tipo_de_cr_dito = 'Consumo' and producto_de_cr_dito = 'Tarjeta de crédito para ingresos hasta 2 SMMLV'", limit=9999999)

# Convert results to pandas DataFrame
results_df = pd.DataFrame.from_records(results)

#rename columns
results_df = results_df.rename(columns={'tama_o_de_empresa': 'tamano_de_empresa', 'tipo_de_cr_dito': 'tipo_de_credito' \
                       ,'tipo_de_garant_a': 'tipo_de_garantia', 'producto_de_cr_dito': 'producto_de_credito'\
                       ,'plazo_de_cr_dito': 'plazo_de_credito', 'margen_adicional_a_la': 'margen_adicional'} )

#Conver numeric fields
results_df['montos_desembolsados'] = results_df['montos_desembolsados'].astype(float)
results_df['codigo_entidad'] = results_df['codigo_entidad'].astype(int)
results_df['tipo_entidad'] = results_df['tipo_entidad'].astype(int)
results_df['tasa_efectiva_promedio'] = results_df['tasa_efectiva_promedio'].astype(float)
results_df['numero_de_creditos'] = results_df['numero_de_creditos'].astype(int)
results_df['margen_adicional'] = results_df['margen_adicional'].astype(float)

#Clean special characters
results_df = results_df.replace('ñ','n', regex=True)
results_df = results_df.replace('Ñ','N', regex=True)
results_df = results_df.replace('á','a', regex=True)
results_df = results_df.replace('Á','A', regex=True)
results_df = results_df.replace('é','e', regex=True)
results_df = results_df.replace('É','E', regex=True)
results_df = results_df.replace('í','i', regex=True)
results_df = results_df.replace('Í','I', regex=True)
results_df = results_df.replace('ó','o', regex=True)
results_df = results_df.replace('Ó','O', regex=True)
results_df = results_df.replace('ú','u', regex=True)
results_df = results_df.replace('Ú','U', regex=True)

#Create calculated column
results_df['Montos_desembolsados_USD'] = results_df['montos_desembolsados']/4000

#Convert field to date format
results_df['fecha_corte'] = results_df['fecha_corte'].astype(str).str[:10]

#round amount fields to 2 decimals
results_df = results_df.round({'Montos_desembolsados_USD': 2, 'montos_desembolsados': 2})

#convert pandas to database table and save table in the database defined in the connection
results_df.to_sql('tasasInteresCredito', conn, if_exists='replace')

#Save transaccion
conn.commit()
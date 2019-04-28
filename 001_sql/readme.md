SQL directories for each DB schema.

001_source:     
  - schema for source data

002_stage:      
  - stageing area for interfaces

003_raw_vault:  
  - persistent raw data vault schema

004_betting_vault:
  - partly virtualized betting data vault
  - variable calculations
  - model calculations

005_betting_mart:
  - reporting schema
  
006_meta:
  - meta data for data processing
  
007_dq_mart:
  - data quality reports & checks
  
008_configuration:
  - db configuration scripts

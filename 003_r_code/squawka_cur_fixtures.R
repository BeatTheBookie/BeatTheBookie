library(rvest)
library(XML)
library(exasol)

Sys.setlocale("LC_TIME", "C")

#Connect to exasol
con <- dbConnect("exa", exahost = "192.168.164.130:8563",
                 uid = "sys", pwd = "exasol", schema = "meta")

#read coonfig
data_config <- exa.readData(con, 
"
SELECT
  DIVISION, 
  URL, 
  NUM_MATCHES
FROM
  META.SQUAWKA_CUR_FIXTURES_CONFIG
")

#read team name mapping
team_mapping <- exa.readData(con,
"
SELECT
  FOOTBALL_DATA, 
  SQUAWKA
FROM
  STAGE.TEAM_MAPPING
")


#loop all config entries
for (i in 1:nrow(data_config)) {
  
  
  url <- data_config[i,"URL"]
  num_games <- data_config[i,"NUM_MATCHES"]
  
  #read html table
  html_table_data <- url %>%
  read_html() %>%
    html_nodes(xpath='//*[@id="upcoming-fixtures"]/center/center/div/table') %>%
    html_table(fill = TRUE)
  
  #only needed columns & rows
  fixtures_temp <- html_table_data[[1]] 
  fixtures_temp <- fixtures_temp[,c(2,4,7)]
  fixtures_temp <- na.omit(fixtures_temp)
  fixtures_temp <- fixtures_temp[2:(num_games+1),]
  
  #add division
  fixtures_temp$DIVISION <- data_config[i,"DIVISION"]
  
  #add date
  fixtures_temp$DATE <- gsub("(st|nd|rd|th) "," ",fixtures_temp[,c(3)])
  fixtures_temp$DATE <- as.Date(fixtures_temp$DATE, format = "%H:%M on %d %B %Y")
  
  #drop old date column
  fixtures_temp <- fixtures_temp[,-c(3)]
  
  #lookup home team name
  colnames(fixtures_temp)[1] <- "SQUAWKA"
  fixtures_temp <- merge(fixtures_temp,team_mapping,by=c("SQUAWKA"))
  colnames(fixtures_temp)[5] <- "TEAM_HOME"
  fixtures_temp <- fixtures_temp[,-c(1)]
  
  #lookup away team name
  colnames(fixtures_temp)[1] <- "SQUAWKA"
  fixtures_temp <- merge(fixtures_temp,team_mapping,by=c("SQUAWKA"))
  colnames(fixtures_temp)[5] <- "TEAM_AWAY"
  fixtures_temp <- fixtures_temp[,-c(1)]
  
  #save in finale fixtures data frame
  if (i==1) {
    fixtures <- fixtures_temp
  } else {
    fixtures <- rbind(fixtures, fixtures_temp)  
  }
  

}


#write to stage table
EXAWriteTable(con = con, schema = 'STAGE', tbl_name = 'SQUAWKA_CUR_FIXTURES',
              overwrite = 'TRUE', data = fixtures)





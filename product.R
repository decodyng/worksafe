require(memisc)
require(dplyr)
require(reshape)
require(lubridate)
require(forecast)
require(stringr)
accident <- readRDS('accident.Rds')
    
clean <- accident %>% mutate(fatality = ifelse(fatality=='X',1,0)) %>% subset(year(event_date) < 2012 & year(event_date) > 1984) %>%
    mutate(sic=as.numeric(substr(sic_list,1,2)))

clean2 <- clean %>% mutate(industry = cases(
    "Agriculture" = sic < 8,
    "Forestry and Fishing" = sic < 10,
    "Metal Mining" = sic == 10,
    "Coal Mining" = sic == 12,
    "Oil and Gas Extraction" = sic == 13,
    "Other Mining" = sic == 14,
    "Building Construction" = sic == 15,
    "Heavy Construction" = sic == 16,
    "Construction Special Trace Contractors" = sic == 17,
    "Manufacturing" = sic < 40,
    "Transportation" = sic < 48,
    "Communications" = sic == 48,
    "Electric, Gas, and Sanitary Services" = sic == 49,
    "Wholesale Trade" = sic < 52,
    "Retail Trade" = sic < 60,
    "Finance, Insurance, and Real Estate" = sic < 68,
    "Lodging Services" = sic == 70,
    "Business Services" = sic %in% c(72,73,81),
    "Auto and Other Repairs" = sic %in% c(75,76),
    "Entertainment and Recreational Services" = sic %in% c(78, 79, 84),
    "Health Services" = sic == 80,
    "Social Services" = sic == 83,
    "Membership Organizations" = sic == 86,
    "Private Households" = sic == 88,
    "Misc Services" = sic == 89,
    "Public Administration" = sic >= 90,
    "Other" = T
    ))


fatal <- subset(clean2, fatality==1)
non_fatal <- subset(clean2, fatality==0)

fatal.setup <- fatal %>% group_by(year(event_date)) %>%
    summarize(n())
names(fatal.setup) <- c("year","deaths")
date_seq <- seq(from=min(fatal.setup$year),to=max(fatal.setup$year),by=1) %>% as.data.frame   
names(date_seq) <- 'year'
fatal.setup <- left_join(date_seq,fatal.setup,by='year') 
fatal.setup[is.na(fatal.setup$deaths),2] <- 0
fatal.ts <- ts(fatal.setup$deaths,frequency=1,start=min(fatal.setup$year))

non_fatal.setup <- non_fatal %>% group_by(year(event_date)) %>%
    summarize(n())
names(non_fatal.setup) <- c("year","injuries")
date_seq <- seq(from=min(non_fatal.setup$year),to=max(non_fatal.setup$year),by=1) %>% as.data.frame   
names(date_seq) <- 'year'
non_fatal.setup <- left_join(date_seq,non_fatal.setup,by='year') 
non_fatal.setup[is.na(non_fatal.setup$injuries),2] <- 0
non_fatal.ts <- ts(non_fatal.setup$injuries,frequency=1,start=min(non_fatal.setup$year))

total.ts <- fatal.ts + non_fatal.ts

all.ts <- list(fatal.ts,non_fatal.ts,total.ts)

fatal_keys <- strsplit(fatal$event_keyword,',') %>% unlist
fatal_key_table <- table(fatal_keys) %>% as.data.frame
tot <- dim(fatal)[1]
fatal_key_table$perc <- fatal_key_table$Freq/tot

non_fatal_keys <- strsplit(non_fatal$event_keyword,',') %>% unlist
non_fatal_key_table <- table(non_fatal_keys) %>% as.data.frame
tot <- dim(non_fatal)[1]
non_fatal_key_table$perc <- non_fatal_key_table$Freq/tot

all_keys <- strsplit(clean2$event_keyword,',') %>% unlist
all_key_table <- table(all_keys) %>% as.data.frame
tot <- dim(clean2)[1]
all_key_table$perc <- all_keys_table$Freq/tot

full_list <- list(fatal_key_table,non_fatal_key_table,all_key_table)


by.industry <- function(ind) {
    if(ind=='All'){
        return(all.ts)
    } else{
    
    die <- subset(fatal, industry==ind) %>% group_by(year(event_date)) %>%
        summarize(n())
    names(die) <- c("year","deaths")
    date_seq <- seq(from=min(die$year),to=max(die$year),by=1) %>% as.data.frame   
    names(date_seq) <- 'year'
    die <- left_join(date_seq,die,by='year') 
    die[is.na(die$deaths),2] <- 0
    die.ts <- ts(die$deaths,frequency=1,start=min(die$year))
    
    hurt <- subset(non_fatal, industry==ind) %>% group_by(year(event_date)) %>%
        summarize(n())
    names(hurt) <- c("year","injuries")
    date_seq <- seq(from=min(hurt$year),to=max(hurt$year),by=1) %>% as.data.frame   
    names(date_seq) <- 'year'
    hurt <- left_join(date_seq,hurt,by='year') 
    hurt[is.na(hurt$injuries),2] <- 0
    hurt.ts <- ts(hurt$injuries,frequency=1,start=min(hurt$year))
    
    total.ts <- die.ts + hurt.ts
    
    return(list(die.ts,hurt.ts,total.ts))
    }
}


keys <- function(ind) {
    if(ind=='All'){
        return(full_list)
    } else{
    
    die <- subset(fatal, industry==ind)
    fatal_keys <- strsplit(die$event_keyword,',') %>% unlist
    die_table <- table(fatal_keys) %>% as.data.frame
    tot <- dim(die)[1]
    die_table$perc <- die_table$Freq/tot
    
    hurt <- subset(non_fatal, industry==ind)
    non_fatal_keys <- strsplit(hurt$event_keyword,',') %>% unlist
    hurt_table <- table(non_fatal_keys) %>% as.data.frame
    tot <- dim(hurt)[1]
    hurt_table$perc <- hurt_table$Freq/tot
    
    all <- subset(clean2, industry==ind)
    all_keys <- strsplit(all$event_keyword,',') %>% unlist
    all_table <- table(all_keys) %>% as.data.frame
    tot <- dim(all)[1]
    all_table$perc <- all_table$Freq/tot
    
    return(list(die_table,hurt_table,all_table))
    }
}

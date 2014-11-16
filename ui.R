shinyUI(fluidPage(theme="style.css",
                  
                  fluidRow(
                    column(6,
                           fluidRow(h4("Industry", id="indLabel"),
                                    h4("Accident Severity", id="sevLabel")),
                           fluidRow(div(id="navSelect",
                                        selectInput("industry",label=h4("Industry:"),
                                                    choices = list("All",
                                                                   "Agriculture", "Forestry and Fishing",
                                                                   "Metal Mining", "Coal Mining", "Oil and Gas Extraction",
                                                                   "Other Mining", "Building Construction", "Heavy Construction",
                                                                   "Construction Special Trace Contractors","Manufacturing",
                                                                   "Transportation", "Communications","Electric, Gas, and Sanitary Services",
                                                                   "Wholesale Trade","Retail Trade", "Finance, Insurance, and Real Estate",
                                                                   "Lodging Services","Business Services", "Auto and Other Repairs",
                                                                   "Entertainment and Recreational Services","Health Services",
                                                                   "Social Services","Membership Organizations",
                                                                   "Private Households","Misc Services",
                                                                   "Public Administration",
                                                                   "Other"),selected="All"),
                                        
                                        radioButtons("severity",
                                                     label = h4("Severity:"),
                                                     choices=list("All","Fatal","Non-Fatal"))
                           ))
                           ),
                    column(6,
                           h2("Work Safe", id="titleID")
                           )),
                  hr(),
                  fluidRow(
                    column(6, 
                           div(id="words", 
                               h3("What to Watch Out For", id="wordTitle"),
                               h5("words most uniquely associated with accidents in this industry", id="wordSubtitle"),
                               hr(),
                               br(),
                               textOutput('v1'),                               
                               textOutput('v2'),                                
                               textOutput('v3'),                           
                               textOutput('v4'),                                
                               textOutput('v5'),                               
                               textOutput('v6'),                               
                               textOutput('v7'),                           
                               textOutput('v8'),                               
                               textOutput('v9'),                              
                               textOutput('v10')
                               
                           )
                           ),
            
                    column(6,
                           fluidRow(div(id="timeseries",
                                        h3("Where Are Things Headed?", id="tsTitle"),
                                        h5("number of this accident in this industry, 1985-2013", id="tsSubtitle"),
                                        hr(),
                                        plotOutput('ts'))),
                           fluidRow(div(id="attribution",
                                      img(src="osha.jpg", id="oshaLogo"), img(src="bayeshack.jpg", id="bayeshack"), 
                                    a(href="https://twitter.com/crodiggly", "@crodiggly", class="follow"), a(href="https://twitter.com/decodyng", "@decodyng", class="follow"))
                           
                           )
                    )               
                  )))
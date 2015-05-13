shinyUI(fluidPage(
        titlePanel(h1('Estimated GFR using Cystatin C', align = "center", style = "color:red")),
        sidebarPanel(
                numericInput('cysc', 'Cystatin C (mg/L)', 0, min = 0, max = 3.0, step = 0.1),
                numericInput('crt', 'Creatinine (umol/L)', 0, min = 0, max = 300, step = 5),
                numericInput('urea', 'Urea (mmol/L', 0, min = 0, max = 25, step = 0.5),
                numericInput('height', 'Height (cm)', 0, min = 0, max = 210, step = 5),
                textInput('sex', 'Sex (M/F)'),
                actionButton('goButton', 'Calculate')
                ),
        mainPanel(
                br(),
                br(),
                h2('Calculations', align = "center"),
                br(),
                h3('Filler formula'),
                textOutput("filler"),
                h3('CKID formula'),
                textOutput("CKID"),
                h3('RCH formula'),
                textOutput("newform"),
                br(),
                h2('Recommendation', align = "center"),
                h4(textOutput("recommendation"), align = "center", style = "color:red"),
                img(src = "RCH.png", height = 100, width = 100, align = "right"),
                br(),
                br(),
                a(href="https://github.com/ajdodgshun/Cystatin/blob/master/README.md", "Click here for help with this app")
        )
))

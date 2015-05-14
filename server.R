library(shiny)

CKIDform <- function(sex, height, creatinine, cystatin, urea){
        39.1*(1.099^sex)*(((height/100)/(creatinine*0.0113))^0.516)*((1.8/cystatin)^0.294)*((30/(2.8011*urea))^0.169)*((height/140)^0.188)
}

NEWform <- function(cystatin, height, creatinine){
        ((242229.1/cystatin)^0.3304218)*((height/creatinine)^0.3665145)
}

FILLERform <- function(cystatin) exp(1.962 + (1.123*(log(10/cystatin))))

shinyServer(function(input, output) {
        numericsex <- reactive({
                if(input$sex %in% c("M", "m")) nsex <- "1"
                else if(input$sex %in% c("F", "f")) nsex <- "0"
                else nsex <- "NA"
                as.numeric(nsex)
        })
        output$filler <- renderText({
                if(input$goButton == 0) ""
                else FILLERform(input$cysc)})
        output$CKID <- renderText({
                if(input$goButton == 0) ""
                else CKIDform(numericsex(), input$height, input$crt, input$cysc, input$urea)})
        output$newform <- renderText({
                if(input$goButton == 0) ""
                else NEWform(input$cysc, input$height, input$crt)})
        
recommend <- reactive({
        recnewform <- NEWform(input$cysc, input$height, input$crt)
        recfiller <- FILLERform(input$cysc)
        recCKID <- CKIDform(numericsex(), input$height, input$crt, input$cysc, input$urea)
        
        if(recCKID < 20 || recCKID > 250){
                rec <- "Error in inputs, please check values and units carefully"
        }else if(recCKID < 100 && recnewform < 100){
                rec <- "Recommend formal isotopic GFR, reasonable likelihood GFR is less than 90"
        } else if(recCKID < 100 && recnewform >=100) {
                rec <- "Disagreement between formulae, consider formal GFR if clinically appropriate"
        } else if(recCKID >= 100 && recnewform < 100) {
                rec <- "Disagreement between formulae, consider formal GFR if clinically appropriate"
        } else if(recCKID >= 100 && recnewform >= 100) {
                rec <- "GFR is likely to be greater than 90mL/min/1.73m2"
        } else rec <- ""
        return(rec)
})
output$recommendation <- renderText({
        if(input$goButton == 0) ""
        else recommend()})
}
)

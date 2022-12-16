################################
### Calls necessary packages ###
################################

require(ggplot2)

#########################
### Defines functions ###
#########################

# Checks if an integer is of 0 length
is.integer0 <- function(x){
  is.integer(x) && length(x) == 0L
}

# Cleans and summarizes the read data
read_summary <- function(x){
  
  options(stringsAsFactors = F)
  
  dat <- read.table(x, sep = "\t", header = F, skip = 1, col.names = paste0("V",seq_len(100)), fill = TRUE)
  #dat <- read.table("summary_BLAST_Medaka_barcode12_concatenated.txt", sep = "\t", header = F, skip = 1, col.names = paste0("V",seq_len(100)), fill = TRUE)
  
  check <- grep("TRUE", is.na(dat$V1))
  
  if(is.integer0(check) == TRUE){
    sdat <- dat[,c(1, 4, 8, 11, 12)]
    }else{
      dat <- dat[-c(grep("TRUE", is.na(dat$V1))),]
      sdat <- dat[,c(1, 4, 8, 11, 12)]
    }
  
  #sdat <- dat[,c(1, 4, 8, 11, 12)]
  names(sdat) <- c("reads", "percent_id", "e_value", "genus", "species")
  sdat$percent_id[grep("TRUE", is.na(sdat$percent_id))] <- 0
  
  totalreads <- sum(sdat$reads)
  
  idat <- sdat[grep("TRUE", sdat$percent_id > 95),]
  
  idat$gensp <- paste(idat$genus, idat$species, sep = "_")
  
  gensp <- unique(idat$gensp)
  output <- data.frame()
  
  for(i in gensp){
    gensp_reads <- idat[grep(i, idat$gensp),]
    reads <- sum(gensp_reads$reads)
    read_gensp <- c(i, reads)
    output <- rbind(output, read_gensp)
  }
  
  names(output) <- c("gensp", "reads")
  output <- transform(output, reads = as.numeric(reads))
  
  other <- totalreads - sum(output$reads)
  other <- c("Unclassified", other)
  output <- rbind(output, other)
  totalreads <- c("Total_Reads", totalreads)
  output <- rbind(output, totalreads)
  
  output <- transform(output, reads = as.numeric(reads))
  output$read_percentage <- cbind(output$reads/output$reads[length(output$reads)]*100)
  output <- transform(output, read_percentage = as.numeric(read_percentage))
  return(output)
}

# Plots the summarized read data
edna_plots<- function(x){
  
  #x <- b2
  #index <- grep("TRUE", x$gensp == "Pseudorca_crassidens")
  #x <- x[-c(index),]
  index <- grep("TRUE", x$gensp == "Unclassified")
  x <- x[-c(index),]
  index <- grep("TRUE", x$gensp == "Total_Reads")
  x <- x[-c(index),]
  x$read_percentage <- round(x$read_percentage, 2)
  x$read_percentage <- paste(x$read_percentage, "%", sep = "")
  
  
  ggplot(x, aes(x="", y=reads, fill=gensp)) +
    geom_bar(stat="identity", width=1, color="white") +
    coord_polar("y") +
    #geom_text(aes(label = reads), position = position_stack(vjust = 0.5), size = 4) +
    theme_void() 
}


####################
### Process data ###
####################

# Finds blast summary results in current wd and strips .txt
blast <- list.files(pattern = "summary_BLAST_Medaka_barcode.._concatenated.txt")
nout <- sub(".txt", "", blast)

# Loops through files to generate summary csv and piechart to view
for(i in nout){
  dat <- read_summary(paste0(i, ".txt"))
  write.csv(dat, file = paste0("condensed_", i, ".csv"), row.names = FALSE)
  viz <- edna_plots(dat) + ggtitle(i)
  pdf(paste0("pie_", i, ".pdf"), height = 5, width= 7)
      print(viz)
  dev.off()
}

q(save = "no")
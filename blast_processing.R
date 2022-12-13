library(stringr)
library(ggplot2)

options(stringsAsFactors = FALSE)

# x <- "all_medaka_fastas_barcode03_concatenated_fasta_out.tsv"

# Read in the data
read_summary <- function(x) {
    dat <- read.table(x, sep = "\t", header = FALSE)
    dat <- dat[, c(1:8)]
    names(dat) <- c("id", "piden", "qlen", "mismat", "gap", "eval", "bits", "metad")
    dat$metad <- sub(" ", "_", dat$metad)

    # Cleans and extracts gensp, cluster size, target
    dat$gensp <- str_extract(dat$metad, "(\\w+_+\\w+)")
    dat$clusts <- str_extract(dat$id, "-\\d+-")
    dat$clusts <- str_remove_all(dat$clusts, "-")
    dat$clusts <- as.numeric(dat$clusts)
    dat$locus <- str_extract(dat$metad, "\\(\\w+\\)")

    # Makes clean dataframe
    cdat <- data.frame(dat$id, dat$gensp, dat$clusts, dat$piden)
    names(cdat) <- c("id", "gensp", "clusts", "piden")

    # Loops through the dataframe to sum reads
    gensp <- unique(cdat$gensp)
    output <- data.frame()

    for (i in gensp){
        gensp_reads <- cdat[grep(i, cdat$gensp), ]
        reads <- sum(gensp_reads$clusts)
        read_gensp <- c(i, reads)
        output <- rbind(output, read_gensp)
    }

    names(output) <- c("gensp", "reads")
    output <- transform(output, reads = as.numeric(reads))

    # Adds total reads classified as the final row
    totalreads <- sum(output$reads)
    total_reads <- c("Total_Reads", totalreads)
    output <- rbind(output, total_reads)

    output <- transform(output, reads = as.numeric(reads))
    output$read_percentage <- cbind(output$reads / output$reads[length(output$reads)] * 100)
    output <- transform(output, read_percentage = as.numeric(read_percentage))
    return(output)
}

# Plots BLAST summary
blast_plots <- function(x) {
  index <- grep("TRUE", x$gensp == "Total_Reads")
  x <- x[-c(index), ]
  x$read_percentage <- round(x$read_percentage, 2)
  x$read_percentage <- paste(x$read_percentage, "%", sep = "")
  ggplot(x, aes(x = "", y = reads, fill = gensp)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y") +
    theme_void()
}

# Excecutes the code
blast <- list.files(pattern = "*.tsv")
nout <- sub(".tsv", "", blast)

for (i in nout) {
  bdat <- read_summary(paste0(i, ".tsv"))
  write.csv(bdat, file = paste0("condensed_", i, ".csv"), row.names = FALSE)
  viz <- blast_plots(bdat) + ggtitle(i)
  pdf(paste0("pie_", i, ".pdf"), height = 5, width = 7)
      print(viz)
  dev.off()
}

q(save = "no")
# remote_blast
This is sample data to accompany the remote_blast docker image that can be retrieved here:
```
docker pull ethill/remote_blast:latest
```

Here is a sample command for remote blast:
```
blastn -query sample_2_blast.fasta -db nt -remote -outfmt "6 qseqid pident length mismatch gapopen evalue bitscore salltitles sallseqid" -max_target_seqs 1 >remote_blast_test_out.txt
```

Automated data processing has also been added to the suite of tools to summarize the BLAST results and reads per unique organism. Use this command from the directory where the blast results are stored (this script has already been integrated into the dockerized version).
```
Rscript /bin/blast_processing.R
```


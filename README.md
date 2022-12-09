# remote_blast
This is sample data to accompany the remote_blast docker image that can be retrieved here:
```
docker pull ethill/remote_blast:latest
```

Here is a sample command for remote blast:
```
blastn -query sample_2_blast.fasta -db nt -remote -outfmt "6 qseqid pident length mismatch gapopen evalue bitscore salltitles sallseqid" -max_target_seqs 1 >remote_blast_test_out.txt

```

# Decona_plus
Decona_plus contains 3 modified pipelines based on Decona (Oosterbroek et al., preprint; https://github.com/Saskia-Oosterbroek/decona) and 2 standalone executable file for classifying ONT amplicon sequence data. These different pipelines and executables are intended to be used based on the research question you are trying to investigate.

This pipeline has been containerized and is available here:
```
docker pull ethill/decona_plus:latest
```

# Pipelines
## Decona

-Cluster generation, consensus polishing and BLAST-ing of sequences

-BLAST can only be run against a local database

-Use this if you know what organisms you want to look for and have compiled them into a local database

### Example Decona command if you are not using a local database:
```
decona -f -l 170 -m 300 -q 10 -c 0.95 -n 5 -M -k 10 -T 32
```
### Example Decona command if you are using a local database:
```
decona -f -l 170 -m 300 -q 10 -c 0.95 -n 5 -M -k 10 -T 32 -B db.fasta
```

## Decona_pro

-Cluster generation, consensus polishing and BLAST-ing of sequences

-BLAST can only be run against a local database

-Automatically generates results summary at the end of the pipeline

-Use this if you know what organisms you want to look for and have compiled them into a local database

### Example Decona_pro command using a local database:
```
decona_pro -f -l 170 -m 300 -q 10 -c 0.95 -n 5 -M -k 10 -T 32 -B db.fasta
```

## Decona_remote_pro

-Cluster generation, consensus polishing and BLAST-ing of sequences

-BLAST against Genbank using the NCBI Genbank API

-Automatically generates results summary at the end of the pipeline

-Use this if you HAVE NOT compiled a local database because you don't know what you are looking for.

### Example Decona_remote_pro command:
```
decona_remote_pro -f -l 170 -m 300 -q 10 -c 0.95 -n 5 -M -k 10 -T 32
```

# Standalone remote BLAST for Decona

## Decona_remote_blast

-Standalone BLAST tool that can re-BLAST results generated from ANY of the Decona pipelines 

-BLAST against GenBANK using NCBI API

-Automatically generates results summary at the end of the BLAST search

### Example Decona_remote_blast command:

```
decona_remote_blast -g yes
```

## Decona_local_blast

-Standalone BLAST tool that can re-BLAST results generated from ANY of the Decona pipelines 

-BLAST against a local database generated from a .fasta file

-Automatically generates results summary at the end of the BLAST search

### Example Decona_remote_blast command:

```
decona_local_blast -B my_db.fasta -T 8 -g yes 
```

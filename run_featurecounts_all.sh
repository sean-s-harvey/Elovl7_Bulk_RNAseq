#!/bin/bash
#SBATCH -J featureCounts_all
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --mem=50G
#SBATCH -t 02:00:00
#SBATCH -p hotel
#SBATCH -q hotel
#SBATCH -A htl158
#SBATCH -o featureCounts_all_%j.out
#SBATCH -e featureCounts_all_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=ssharvey@health.ucsd.edu

module purge
module load slurm
module load cpu

source ~/.bashrc
conda activate r4-base

BAM_DIR="/tscc/nfs/home/ssharvey/scratch_2.0_new/fat14_aging_RNAseq/star_output"
GTF="/tscc/nfs/home/ssharvey/genomes/refdata-gex-mm10-2020-A/genes/genes.gtf"
OUT_FILE="/tscc/nfs/home/ssharvey/scratch_2.0_new/fat14_aging_RNAseq/featurecounts_output_gene_name_250630.txt"

echo "[`date`] Starting featureCounts"

featureCounts -T 8 -p -B -C -s 2 \
  -a $GTF -t exon -g gene_name \
  -o $OUT_FILE \
  $BAM_DIR/*.bam

echo "[`date`] Finished featureCounts"

conda deactivate


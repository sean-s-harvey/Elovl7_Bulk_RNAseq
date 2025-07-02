#!/bin/bash
#SBATCH -J STAR_genomeGenerate
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --mem=100G
#SBATCH -t 08:00:00
#SBATCH -p hotel
#SBATCH -q hotel
#SBATCH -A htl158
#SBATCH -o genomeGenerate_%j.out
#SBATCH -e genomeGenerate_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=ssharvey@health.ucsd.edu

module purge
module load slurm
module load cpu
export OMP_NUM_THREADS=20
source ~/.bashrc
source ~/.bash_profile

# STAR path (from your conda package)
STAR_EXEC=/tscc/nfs/home/ssharvey/miniconda3/pkgs/star-2.7.10a-h9ee0642_0/bin/STAR

# Input files
FASTA=/tscc/nfs/home/ssharvey/genomes/refdata-gex-mm10-2020-A/fasta/genome.fa
GTF=/tscc/nfs/home/ssharvey/genomes/refdata-gex-mm10-2020-A/genes/genes.gtf

# Output directory
OUTDIR=/tscc/nfs/home/ssharvey/genomes/mm10_STAR_2.7.10a
mkdir -p $OUTDIR

echo "[`date`] Starting STAR genomeGenerate"

$STAR_EXEC --runThreadN 20 \
           --runMode genomeGenerate \
           --genomeDir $OUTDIR \
           --genomeFastaFiles $FASTA \
           --sjdbGTFfile $GTF \
           --sjdbOverhang 99

echo "[`date`] Finished STAR genomeGenerate"


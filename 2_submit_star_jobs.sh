#!/bin/bash

FASTQ_DIR="/tscc/nfs/home/ssharvey/project-storage/fat14_aging_RNAseq/fastqs"
JOB_DIR="/tscc/nfs/home/ssharvey/scratch_2.0_new/fat14_aging_RNAseq/star_jobs"
LOG_DIR="/tscc/nfs/home/ssharvey/scratch_2.0_new/fat14_aging_RNAseq/logs"

mkdir -p "$JOB_DIR"
mkdir -p "$LOG_DIR"

for R1 in ${FASTQ_DIR}/*_R1_001.fastq.gz
do
    SAMPLE=$(basename "$R1" _R1_001.fastq.gz)
    R2="${FASTQ_DIR}/${SAMPLE}_R2_001.fastq.gz"

    if [[ ! -f "$R2" ]]; then
        echo "Warning: Missing R2 file for $SAMPLE, skipping."
        continue
    fi

    JOB_FILE="${JOB_DIR}/${SAMPLE}_star_job.sh"

    cat > "$JOB_FILE" <<EOF
#!/bin/bash
#SBATCH -J STAR_${SAMPLE}
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH -t 12:00:00
#SBATCH --mem=50G
#SBATCH -p hotel
#SBATCH -q hotel
#SBATCH -A htl158
#SBATCH -o ${LOG_DIR}/${SAMPLE}_%j.out
#SBATCH -e ${LOG_DIR}/${SAMPLE}_%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=ssharvey@health.ucsd.edu

module purge
module load slurm
module load cpu
export OMP_NUM_THREADS=20
source ~/.bashrc
source ~/.bash_profile

# add Conda STAR to path
export PATH=/tscc/nfs/home/ssharvey/miniconda3/pkgs/star-2.7.10a-h9ee0642_0/bin:$PATH

GENOME_DIR="/tscc/nfs/home/ssharvey/genomes/mm10_STAR_2.7.10a"
OUT_DIR="/tscc/nfs/home/ssharvey/scratch_2.0_new/fat14_aging_RNAseq/star_output"

mkdir -p "\$OUT_DIR"

echo "[\$(date)] Starting STAR for ${SAMPLE}"

STAR --runThreadN 20 \\
     --genomeDir "\$GENOME_DIR" \\
     --readFilesIn "${R1}" "${R2}" \\
     --readFilesCommand zcat \\
     --outFileNamePrefix "\$OUT_DIR/${SAMPLE}." \\
     --outSAMtype BAM SortedByCoordinate \\
     --outReadsUnmapped Fastx \\
     --outSAMstrandField intronMotif \\
     --outBAMsortingThreadN 20 \\
     --outWigType bedGraph \\
     --outWigStrand Stranded \\
     --outWigNorm RPM \\
     > "${LOG_DIR}/${SAMPLE}_STAR.log" 2>&1

echo "[\$(date)] Finished STAR for ${SAMPLE}"
EOF

    JOBID=$(sbatch "$JOB_FILE")
    echo "$JOBID submitted for sample $SAMPLE"
done


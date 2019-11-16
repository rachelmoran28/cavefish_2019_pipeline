This is a repository for scripts used by Rachel Moran to process raw cavefish genomic data for use in populations genomic analyses in Summer 2019.


Re-started pipeline from raw reads for Caballo Moro, Jineo, Escondido, and new samples from Josh Gross and UMGC ("June2019" samples).

Used Adam’s pipeline and Adam's alignments for all other individuals (https://github.umn.edu/aherman/cavefish_RIS).


########################################################################

Step 1: FastQC, adapter removal and quality trimming 


All raw reads were quality checked with FastQC and processed with cutadapt-1.2.1 and trimmomatic-0.30.

Samples from BGI (Jineo, Escondido, and all other samples from JG) had unknown barcodes (kept private by BGI), so they were processed with cutadapt using the following Illumina TruSeq adapters and NNNs in place of the individual barcode on R1 (need to supply wildcard flag to cutadapt for this to work):
R1: GATCGGAAGAGCACACGTCTGAACTCCAGTCACNNNNNNATCTCGTATGCCGTCTTCTGCTTG
R2: AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT

See the following scripts for examples of how reads were processed: 
par_fastqc.sh,
par_Gross_samples_cutadapt.sh,
par_Gross_samples_trimmomatic.sh

Caballo Moro samples had the same adapters as BGI samples, but barcodes on R1 were known for each individual and supplied to cutadapt. Cutadapt version 1.2.1 and the newest version (2.3.0) both had issues processing these samples (kept resulting in corrupt fastqs with extra lines), so trimmomatic-0.30 was used to do the adapter clipping and quality trimming for these samples (see par_CabMoro_trimmomatic.sh).

After processing with cutadapt and/or trimmomatic, unpaired reads from R1 and R2 files need to be combined into one fastq file (see par_combine_unpair.sh).

Reads are then ready to align.


########################################################################

Step 2: Alignment to surface and cave genomes


For each sample, processed reads were aligned to both the cavefish (v1) and the surface fish (v2) genomes.

Rather than using parallel used array jobs for alignments, which is more efficient. 

The script make_align_jobs_all_raw.sh will generate jobs (a list of commands, one for each sample) that can be specified in the array script array_map.sh. Run the following command to get the list of commands written to the file raw_bwa_commands_cavefish.txt (can modify make_align_jobs_all_raw.sh for alignment to cave or sruface genome):

./make_align_jobs_all_raw.sh > raw_bwa_commands_cavefish.txt

Then need to edit array_map.sh to point to raw_bwa_commands_cavefish.txt. To submit the array job, use the following command:

qsub -t 1-N array_map.sh 

where N is equal to the number of jobs in the array (i.e. the number of lines in the commands .txt file generated by make_align_jobs_all_raw.sh).


Files produced in this step will all end in *_raw.bam.



########################################################################

Step 3: Mark duplicates and add read groups


For each raw bam file generated in Step 2, use picard to mark duplicates and add read group (i.e. sample name).

Again need to generate a list of commands to feed into an array script:

./make_picard_cavefish_commands.sh > picard_cavefish_commands.txt
./make_picard_surface_commands.sh > picard_surface_commands.txt

Then, edit array_picard.sh to include the .txt file with the commands you want to submit as an array job.

I've included the job array PBS flag (i.e. #PBS t 1-N) in array_picard.sh, so it can just be editted to reflect the number of jobs and submitted with "qsub array_picard.sh".

Files produced in this step will all end in *_dupsmarked_rgadd.bam.

There will also be a set of intermedeiate files ending in *_dupsmarked.bam, which can be deleted.


Can calcualte depth of coverage for each sample using get_cov_depth.sh (can be edited for use with files aligned to cave or surface genome).


########################################################################

Step 4: Split bams into mapped and unmapped reads


Use samtools view to split bams from Step 3 (dups marked and read groups added)into mapped and unmapped reads. We will use the  bams with mapped reads only in the next step.

At the end of this step, all mapped-reads-only bam files will end in *_mapped.bam and all unmapped-reads-only bam files will end in *_unmapped.bam.

Mapped bams need to be indexed using samtools index before moving on to the next step (can use par_index.sh).



########################################################################

Step 5: Haplotype calling

Used mapped bams for gatk haplotype caller.

haplotypecaller.sh can be modified for use with cave or surface aligned bams.



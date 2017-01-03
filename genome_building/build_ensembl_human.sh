#!/bin/bash

echo ""
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Starting..."
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"

# ---------------------------------------------------- Basic Setup ----------------------------------------------------


#	Ensembl version
ENSEMBL_VERSION='87'

#
#	Local Directory Targets
#
PROJECT_BASE_DIR='/biorg/references/human/ensembl'

#
#	Local Directory Targets
#

#	DNA for chromosomes
DNA_DIR=$PROJECT_BASE_DIR'/'$ENSEMBL_VERSION'/dna'
mkdir -p $DNA_DIR

#	Annotations as GTF
GTF_DIR=$PROJECT_BASE_DIR'/'$ENSEMBL_VERSION'/gtf'
mkdir -p $GTF_DIR

#	CDNA for Known Transcripts
CDNA_DIR=$PROJECT_BASE_DIR'/'$ENSEMBL_VERSION'/cdna'
mkdir -p $CDNA_DIR

#	Non-coding RNAs
NCRNA_DIR=$PROJECT_BASE_DIR'/'$ENSEMBL_VERSION'/ncrna'
mkdir -p $NCRNA_DIR


# ------------------------------------------------------- URLs --------------------------------------------------------

GTF_FILE_NAME='Homo_sapiens.GRCh38.'$ENSEMBL_VERSION'.gtf'
GTF_FILE_NAME_COMPRESSED=$GTF_FILE_NAME'.gz'
URL_FOR_GTF='ftp://ftp.ensembl.org//pub/release-'$ENSEMBL_VERSION'/gtf/homo_sapiens/'$GTF_FILE_NAME_COMPRESSED

CDNA_FILE_NAME='Homo_sapiens.GRCh38.cdna.all.fa'
CDNA_FILE_NAME_COMPRESSED=$CDNA_FILE_NAME'.gz'
URL_FOR_CDNA='ftp://ftp.ensembl.org//pub/release-'$ENSEMBL_VERSION'/fasta/homo_sapiens/cdna/'$CDNA_FILE_NAME_COMPRESSED

NCRNA_FILE_NAME='Homo_sapiens.GRCh38.ncrna.fa'
NCRNA_FILE_NAME_COMPRESSED=$NCRNA_FILE_NAME'.gz'
URL_FOR_NCRNA='ftp://ftp.ensembl.org//pub/release-'$ENSEMBL_VERSION'/fasta/homo_sapiens/ncrna/'$NCRNA_FILE_NAME_COMPRESSED


# ----------------------------------------------------- Download ------------------------------------------------------
#
#	Download and extract the sequences
#

#	Download the GTF
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Downloading GTF..."
wget --directory-prefix=$GTF_DIR $URL_FOR_GTF
cd $GTF_DIR
gunzip $GTF_FILE_NAME_COMPRESSED

#	Download the CDNA
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Downloading CDNA..."
wget --directory-prefix=$CDNA_DIR $URL_FOR_CDNA
cd $CDNA_DIR
gunzip $CDNA_FILE_NAME_COMPRESSED

#	Download the NCRNA
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Downloading NCRNA..."
wget --directory-prefix=$NCRNA_DIR $URL_FOR_NCRNA
cd $NCRNA_DIR
gunzip $NCRNA_FILE_NAME_COMPRESSED


#
#	The DNA needs a little bit more work
#
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Downloading Chromosomes..."
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"

CHROMOSOMES=( '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' 'X' 'Y' 'MT' )

cd $DNA_DIR

#
#	Concatenated File that will contain all the chromosomes
#	This file is so that we can index all the chromosomes at once
#
FASTA_FILE_NAME_DNA='Homo_sapiens.GRCh38.dna'
FASTA_FILE_DNA=$DNA_DIR'/'$FASTA_FILE_NAME_DNA'.fa'

#	Remove any previous versions of the DNA file as we'll be concatenating into it
rm -fR $FASTA_FILE_DNA

#	Re-create the DNA file so that we have a pointer to it
touch $FASTA_FILE_DNA

#
#	Start the download
#
for aCHROMOSOME in "${CHROMOSOMES[@]}"
{
	echo "[" `date '+%m/%d/%y %H:%M:%S'` "]  Downloading Chromosome "$aCHROMOSOME
	
	FILE_NAME_FOR_CHR='Homo_sapiens.GRCh38.dna.chromosome.'$aCHROMOSOME'.fa'
	GZIP_FILE_NAME_FOR_CHR='Homo_sapiens.GRCh38.dna.chromosome.'$aCHROMOSOME'.fa.gz'
	
	URL_FOR_CHR='ftp://ftp.ensembl.org//pub/release-'$ENSEMBL_VERSION'/fasta/homo_sapiens/dna/'$GZIP_FILE_NAME_FOR_CHR
	
	wget --directory-prefix=$DNA_DIR $URL_FOR_CHR
	
	gunzip $GZIP_FILE_NAME_FOR_CHR
	
	cat $FILE_NAME_FOR_CHR >> $FASTA_FILE_DNA

}

echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Download Complete."
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"


# --------------------------------------------------- Bowtie2 Index ---------------------------------------------------
#
#	Build the Bowtie2 index with the new DNA Fasta file
#
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Starting Bowtie2 indexing..."
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"

bowtie2-build -f $FASTA_FILE_DNA $FASTA_FILE_NAME_DNA

echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Indexing Complete."

echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo "[" `date '+%m/%d/%y %H:%M:%S'` "] Done."
echo "[" `date '+%m/%d/%y %H:%M:%S'` "]"
echo ""





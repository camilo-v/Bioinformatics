
## ---------------------------------------------------------------------------------------------------------------------
#
#                                        Bioinformatics Research Group
#										   http://biorg.cis.fiu.edu/
#                             			Florida International University
#
#   This software is a "Camilo Valdes Work" under the terms of the United States Copyright Act.
#   Please cite the author(s) in any work or product based on this material.
#
#   OBJECTIVE:
#	The purpose of this program is to transform a text input matrix in "wide form" into "long form" format.  Note
#	that this script is focused on expression data in which the first column (in wide format) is the gene_id and
#	subsequent columns are samples that hold expression units (TPMs, FPKMs, Read Counts, etc.) for a given gene.
#
#
#   NOTES:
#   Please see the dependencies section below for the required libraries (if any).
#
#   DEPENDENCIES:
#
#       • ggplot2
#		• RColorBrewer
#		• reshape2
#
#   The above libraries & modules are required.
#
#   AUTHOR:	Camilo Valdes (cvalde03@fiu.edu)
#			Bioinformatics Research Group,
#			School of Computing and Information Sciences,
#			Florida International University (FIU)
#
#
# ---------------------------------------------------------------------------------------------------------------------


#
# 	Import any necessary system or 3rd-party libraries & frameworks here
#
library(ggplot2)
library(RColorBrewer)
library(reshape2)


# 	Set some options to alter the default behavior of the REPL.
options( width=256, digits=15, warn=1, echo=FALSE )


# ------------------------------------------------- Project Setup -----------------------------------------------------

print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] R Starting... ", sep="") )
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )


working_directory="/path/to/working/directory"
setwd( file.path( working_directory ) )

figures_base_dir=paste(working_directory, "/figures" , sep="")
png_output_dir=paste( figures_base_dir, "/png", sep="" )
dir.create( file.path( png_output_dir ), showWarnings=FALSE, recursive=TRUE )



# ------------------------------------------------------ Main ---------------------------------------------------------

#	File in "wide format"
fileToProcess = paste( working_directory, "/path/to/input/file/human_expression.txt", sep="" )

print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] Input File:", sep="") )
print(fileToProcess)

#	Read-in the file
countsTable = read.delim( fileToProcess, header=TRUE, sep="\t", check.names=FALSE )
numberOfRows = nrow(countsTable)

print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] Number of Rows: ", numberOfRows, sep="") )
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )

print(head(countsTable, n=10))
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )

#
#	Convert to "long form" using the 'melt' function of the 'reshape2' package.
#
locationIDVariable = 1
meltedLongDataFrame = melt( countsTable, id.vars=locationIDVariable)

print(head(meltedLongDataFrame, n=10))
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )


#
#	Output
#
outputFile = paste(working_directory, "/path/to/output/file/human_expression-long.txt", sep="" )
write.table( meltedLongDataFrame, file=outputFile, sep="\t")


# ------------------------------------------------------ END ---------------------------------------------------------

print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] Done.", sep="") )
print( paste( "[", format(Sys.time(), "%m/%d/%y %H:%M:%S"),"] ", sep="") )

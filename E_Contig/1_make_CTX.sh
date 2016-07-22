# Create CTX configuration files for tigra-sv based on Pindel RP BPR data
#
# Creating tigra-sv CTX files from Pindel is undocumented.  This workflow 
# based on /gscuser/mwyczalk/projects/Virus/Virus_2013.9a/preliminary/reanalyze/breakdancer/BA-4077.ctx, analysis of 
# tigra-sv code, and discussion with Kai Ye.
#
# One line from Pindel BPR is one line of tigra CTX input.  Use average from Pindel positions for CTX position.
#   Note that we could use Pindel RP directly, but will read BPR file since that performs filtering and normalization of breakpoints

source ./Contig.config
#OUT="$OUTD/TCGA_Virus.Pindel_RP.dat"
BIN="$BPS_CORE/src/analysis/TigraCTXMaker.R"


LIST="$BPS_DATA/A_Project/dat/TCGA_Virus.samples.dat"
PIND="$BPS_DATA/C_PindelRP/dat"    # Pindel data directory

mkdir -p $OUTD/CTX

while read l; do  # iterate over all rows of TCGA_Virus.samples.dat 

# Skip comments and header
[[ $l = \#* ]] && continue
[[ $l = barcode* ]] && continue

# assume RP file exists for all samples.  Can create test to make sure this is true, skip if not.
BAR=`echo $l | awk '{print $1}'`

DAT="$PIND/$BAR.PindelRP.BPR.dat"
OUT="$OUTD/CTX/${BAR}.ctx"

Rscript $BIN -b $DAT $OUT

done < $LIST
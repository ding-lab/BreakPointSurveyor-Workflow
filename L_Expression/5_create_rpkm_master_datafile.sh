# For each disease, combine expression of all controls into one master file.  The
# master file has a format similar to that obtained from firehose RSEM data, with
# columns representing case samples and rows representing exons.  
# First our columns of output data are, chrom, start, end, gene

source ./BPS_Stage.config
BIN="$BPS_CORE/src/analysis/RPKM_Joiner.R"

# Make a list of RPKM file locations as generated by step 4_.  This is used by the joiner script.
function make_barcode_list {
    RNA_SAMPLE_LIST=$EXPRESSION_LIST
    rm -f $OUTD/*_barcodes.dat


    while read l
    do
        #barcode    disease BAM_path
        [[ $l = \#* ]] && continue
        [[ $l = barcode* ]] && continue

        # extract sample names
        BAR=`echo "$l" | cut -f 1`
        DIS=`echo "$l" | cut -f 2`     

        OUT="$OUTD/${DIS}_barcodes.dat"
        DAT="$OUTD/RPKM/$BAR.rpkm"

        printf "$BAR\t$DAT\n" >> $OUT

    done < $RNA_SAMPLE_LIST
}

function process {
    DAT=$1
    OUT=$2

    Rscript $BIN $DAT $OUT
}

echo Creating Barcode List
make_barcode_list
echo Written to $OUTD/*_barcodes.dat

#process $OUTD/BLCA_barcodes.dat $OUTD/BLCA_RPKM.dat
process $OUTD/HNSC_barcodes.dat $OUTD/HNSC_RPKM.dat

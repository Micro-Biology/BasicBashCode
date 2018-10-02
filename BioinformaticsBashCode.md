# BioinformaticsBashCode
Basic BASH code for bioinformatics

For loop example:

    for f in *.R1.fastq.gz.trimmed.fastq.gz ; do
    
        r=$(sed -e "s/.R1./.R2./" <<< "$f")
        s=$(sed -e "s/.R1.fastq.gz.trimmed.fastq.gz/""/" <<< "$f")
    
        echo
        echo ====================================
        echo Processing sample $s
        echo ====================================
    
        Command to be run for every sample \
            --inF $f \
            --inR $r \
            --out $s.analysed.fastq.gz
    done

Calculate mean sequence length in fastq file:

    awk 'NR%4==2{sum+=length($0)}END{print sum/(NR/4)}' input.fastq

Fastq to Fasta:

    for samples in *.fastq; do awk 'NR%4==1 || NR%4==2' "$samples" > "$samples.fasta"; done

Rename files (bit more elegent than move) when used in for loops:

    rename "s/.oldprefix/.newprefix/g" *
    

Change fasta header to sequence number in that sample:

    for samples in *.fasta ; do
	    cat $samples | perl -ane 'if(/\>/){$a++;print ">_$a\n"}else{print;}' > "$samples.ordered"
    done

    rm *.fasta

    rename "s/.fasta.ordered/.fasta/g" *

    for samples in *.fasta ; do
    	awk '/>/{sub(">","&"FILENAME"");sub(/\.fasta/,x)}1' $samples > "$samples.named"
    done

    rm *.fasta
    rename "s/.named/.fasta/g" *

Combining Sequences for clustering:

    cat *.fasta > allsamples.fasta

Folding fasta file for qiime clustering pipeline:

    fold -w 60 allsamples.fasta > readyForClustering.allsamples.fasta

Running code in parallel that doesnt have the option to do so: (DO NOT USE FOR CLUSTERING DE NOVO)

    ls *.fastq.gz | parallel -j 4 --no-notice 'cutadapt -e 0.1 -b ATGCGTTGGAGAGARCGTTTC -b GATCACCTTCTAATTTACCWACAACTG -o {}.trimmed.fastq.gz {}'

Another way of doing the above that works better with blast

    cat repset.fasta | parallel --block 100k --recstart '>' --gnu --pipe blastn -db diatoms -task blastn -max_target_seqs 1 -outfmt 6 -evalue 0.01 -query - > repset.diatoms.blastn

Retain just sequences from in.fastq

    awk '{if(NR%4==2) print $0}' in.fastq > out.txt

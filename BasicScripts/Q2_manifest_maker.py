#!/usr/bin/env python3


#Q2ManifestMaker
#Here I present my tutorial for making a QIIME2 ‘Manifest.csv’ automatically using Python3, to be used to import data according to the " “Fastq manifest” formats" part of the Importing data tutorial, on the QIIME2 website. 

#I wrote this script because we intended on running a lot of analyses through QIIME2 and I did not want to manually make a manifest file to import samples every time.  This guide assumes you have a version of conda installed or a valid python 3 environment.
#At the moment files can tbe in 2 formats:
#          Standard Illumina MiSeq format (and potentially other illumina instruments)
#          samplename.R1.fastq.gz for forward reads and samplename.R2.fastq.gz for reverse reads



# 'Install' Instructions:

#If you already happen to have a (conda) python3 environment with these packages installed then you can skip this step.

    #conda create -n py37 python=3.7

    #conda activate py37

    #pip install Send2Trash (probably not the best way to do this...)


#Information and potentially support available here: pending...

#To use script:

#Install by saving this file and adding to your $PATH or just keep it somewhere easy like ~/scripts

#navigate to your working directory, add the fastq.gz files to a directory, and activate your python3 environment:

    #conda activate py37

#Run the script:

    #python3 ~/scripts/Q2_manifest_maker.py --input_dir <fastq_directory>

#Actual Script

import argparse
import glob
import os
import send2trash

#Use:

#Put file in path and navigate to your working directory
#python ./Q2_Man.py --input_dir <data_directory>


#Class Objects

class FormatError(Exception):
    '''Formating of file names is incompatioble with this program.'''
    pass

class Fasta_File_Meta:

    '''A class used to store metadata for fasta files, for importing into qiime2.'''

    def __init__(self, file_path):
        self.absolute_path = file_path

        path,file_name = os.path.split(file_path)
        self.filename = file_name

        file_parts = file_name.split(".")
        self.sample_id = file_parts[0]


        if file_parts[1][0] is "S":
            self.format = "Illumina"
        else:
            if file_parts[1][0] is "R":
                self.format = "Basic"
            else:
                self.format = "Unknown"
        
        
        if self.format == "Basic":
            if file_parts[1] == "R1":
                self.direction = "forward"
            else:
                if file_parts[1] == "R2":
                    self.direction = "reverse"
                else:
                    raise FormatError("Files do not follow Illumina or Basic filename conventions.")
        if self.format == "Illumina":
            if file_parts[3] == "R1":
                self.direction = "forward"
            else:
                if file_parts[3] == "R2":
                    self.direction = "reverse"
                else:
                    raise FormatError("Files do not follow Illumina or Basic filename conventions.")
        if self.format == "Unknown":
            raise FormatError("Files do not follow Illumina or Basic filename conventions.")

#Global functions

def delete_file(file_in):
    file_exists = os.path.isfile(file_in)
    if file_exists == True:
        send2trash.send2trash(file_in)

def save_manifest_file(fasta_list):
    writer_name = "Manifest.csv"
    delete_file(writer_name)
    writer = open(writer_name, "w")
    header = "sample-id,absolute-filepath,direction\n"
    writer.write(header)
    for fasta in fasta_list:
        line =  str(fasta.sample_id) + "," + str(fasta.absolute_path) + "," + str(fasta.direction) + "\n"
        writer.write(line)
    writer.close()

def assign_fasta_2_class(file_paths):
    fasta_meta_list = []
    for path in file_paths:
        info = Fasta_File_Meta(path)
        fasta_meta_list.append(info)
    return fasta_meta_list

def get_file_list(directory):
    dir_abs = os.path.abspath(directory)
    print("Making manifest file for fastq.gz files in " + dir_abs + "/*.fastq.gz")
    file_paths_rel = glob.glob(dir_abs + "/*.fastq.gz")
    file_paths_abs = []
    for path in file_paths_rel:
        path_abs = os.path.abspath(path)
        file_paths_abs.append(path_abs)
    return file_paths_abs

def get_args():
    parser = argparse.ArgumentParser(description="Makes a manifest file for importin into qiime2.")
    parser.add_argument("--input_dir", help="Essential: Input directory for samples.", default="info.xlsx", required=True)
    args = parser.parse_args()
    return args


def main():
    options = get_args()

    file_paths = get_file_list(options.input_dir)
    
    fasta_class_list = assign_fasta_2_class(file_paths)

    save_manifest_file(fasta_class_list)

main()

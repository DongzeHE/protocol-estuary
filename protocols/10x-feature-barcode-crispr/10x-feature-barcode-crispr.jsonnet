
// 10x feature barcoding has two parts
// 1. Gene Expression
// 2. CRISPR screen
// One example dataset can be found at https://www.10xgenomics.com/resources/datasets/5-k-a-549-lung-carcinoma-cells-no-treatment-transduced-with-a-crispr-pool-3-1-standard-6-0-0
#############################################################################
# README:

# *IMPORTANT*: For most user, the fields in section "Recommended Configuration" are the only things to complete (replacing the nulls with your values).

# To modify an argument, please replace the Right hand side of each field (separated by `:`) with your value **wrapped in quotes**.
# For example, you can replace `"output": null` in the meta_info section with `"output": "/path/to/output/dir"`, and `"threads": null` with `"threads": "16"`

# All fields that are null, empty array ([]), and empty dictionary ({}) will be pruned (ignored).

# NOTE: You can pass optional simpleaf arguments specified in the "Optional Configuration" section.

#############################################################################

local workflow = {

    // Meta information
    "meta_info": {
        "template_name":  "10x Chromium 3' Feature Barcode CRISPR (TotalSeq-B)",
        "template_id": "10x-feature-barcode-crispr_totalseq-b",
        "template_version": "0.0.1",

        // This value will be assigned to all simpleaf commands that have no --threads arg specified
        // Optional: commands will use their default setting if this is null.
        "threads": null, // "threads": "16",

        // The parent directory of all simpleaf command output folders.
        // If this is leaved as null, you have to specify `--output` when running `simpleaf workflow`
        "output": null, // "output": "/path/to/output",
    },

######################################################################################################################
// *Recommended* Configuration: 
//  For MOST users, the fields listed in the "Recommended Configuration" section are the only fields
//  that needs to be filled. You should replace all null values with valid values, 
//  as described in the comment lines (those start with double slashes `//`) .

//  For advanced users, you can check other simpleaf arguments listed in the "Optional Configurtion" section.
######################################################################################################################
    
    // **For most users**, ONLY the information in the "Recommended Configuration" section needs to be completed.
    // For advanced usage, please check the "Optional Configuration" field.
    "Recommended Configuration": {

        // Information needed to process gene expression reads
        "gene_expression": {
            // Arguments for running `simpleaf index`
            "simpleaf_index": {
                // these two fields are required for all command records.
                "Step": 1,
                "Program Name": "simpleaf index",

                // Recommeneded Reference: spliced + intronic transcriptome (splici) 
                // https://pyroe.readthedocs.io/en/latest/building_splici_index.html#preparing-a-spliced-intronic-transcriptome-reference
                // You can find other reference options in the "Optional Configuration" field. You must choose one type of reference
                "spliced+intronic (splici) reference": {
                    // genome fasta file of the studied species
                    "--fasta": null,
                    // gene annotation gtf file of the studied species
                    "--gtf": null,
                    // read length, usually it is "91" for 10xv3 datasets.
                    // Please check the description of your experiment to make sure
                    "--rlen": "91",
                },
            },

            // Arguments for running `simpleaf quant`
            "simpleaf_quant": {
                "Step": 2,
                "Program Name": "simpleaf quant",
                // Recommended Mapping Option: Mapping reads against the splici reference generated by the simpleaf index command above.
                // Other mapping options can be found in the "Optional Configuration" section
                "Recommended Mapping option": {
                    "Mapping Reads FASTQ Files": {
                        // read1 (technical reads) files separated by comma (,)
                        // have all your reads in a directory? try the following bash command to get their name (Don't forget to quote them!) 
                        // $ find -L your/fastq/absolute/path -name "*_R1_*" -type f | sort | paste -sd, -
                        // Change "*_R1_*" to the file name pattern of your files if it dosn't fit
                        "--reads1": null,

                        // read2 (biological reads) files separated by comma (,)
                        // have all your reads in a directory? try the following bash command to get their name (Don't forget to quote them!) 
                        // $ find -L your/fastq/absolute/path -name "*_R2_*" -type f | sort | paste -sd, -
                        // Change "*_R1_*" to the file name pattern of your files if it dosn't fit
                        "--reads2": null,
                    },
                },
            }
        },

        // This field contains all the information for analyzing CRISPR feature barcoding reads
        // Only required information are listed here. 
        // For optional arguments, Please check the "Optional Arguments" field.
        "crispr_screen": {
            // Arguments used for running `simpleaf index`
            // This is required UNLESS you have an existing salmon index. In that case, you can change the Step of this "simpleaf index" command in the "Optional Configuration" to a quoted negative integer.
            "simpleaf_index": {
                "Step": 8,
                "Program Name": "simpleaf index",
                
                // The path to the feature reference molecule structure and the corresponding reference barcode sequence.
                // Details can be found at https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/feature-bc-analysis#feature-ref 
                "Feature Reference CSV": null,
            },

            // arguments for running `simpleaf quant`
            "simpleaf_quant": {
                "Step": 9,
                "Program Name": "simpleaf quant",
                // Map sequencing reads against the reference index generated by simpleaf index call
                "Recommended Mapping Option": {
                        // read1 (technical reads) files separated by comma (,)
                        // have all your reads in a directory? try the following bash command to get their name (Don't forget to quote them!)
                        // $ find -L your/fastq/absolute/path -name "*_R1_*" -type f | sort | paste -sd, -
                        // Change "*_R1_*" to the file name pattern of your files if it dosn't fit
                        "--reads1": null,

                        // read2 (biological reads) files separated by comma (,)
                        // have all your reads in a directory? try the following bash command to get their name (Don't forget to quote them!)
                        // $ find -L your/fastq/absolute/path -name "*_R2_*" -type f | sort | paste -sd, -
                        // Change "*_R1_*" to the file name pattern of your files if it dosn't fit
                        "--reads2": null,
                    },
            },
        },
    },
##########################################################################################################
// OPTIONAL : The configuration options below are optional, and may be of most interest to advanced users

# If you want tyo skip invoking some commands, for example, when the exactly same command had been run before, 
# you can also change their "Active" to false (the boolean, no need to quote it).
# Simpleaf will ignore all commands with a negative “Step”. 
# Alternatively, you can set the `--skip-step` flag when running simpleaf workflow using comma-separated step numbers.  

#########################################################################################################

    "Optional Configuration": {
        // Optional arguments for processing RNA reads
        "gene_expression": {
            // Optioanal arguments for running `simpleaf index`
            "simpleaf_index": {
                // The required fields
                "Step": 1,
                "Program Name": "simpleaf index",

                // simpleaf workflow will ignore all commands with "Active": false
                "Active": true,

                "Other Reference Options": {
                    // spliced + unspliced transcriptome
                    // https://pyroe.readthedocs.io/en/latest/building_splici_index.html#preparing-a-spliced-unspliced-transcriptome-reference
                    "1. spliced+unspliced (spliceu)": {
                        // specify reference type as spliced+unspliced (spliceu)
                        "--ref-type": null, // "--ref-type": "spliced+unspliced",
                        // The path to the genome FASTA file
                        "--fasta": null,
                        // The path to the gene annotation GTF file
                        "--gtf": null,
                    },

                    // Direct Reference
                    // If the species doesn"t have its genome available,
                    // you can pass the reference sequence FASTA file as `--ref-seq`.
                    // simpleaf will build index directly using the given file 
                    "2. Direct Reference": {
                        // The path to the reference sequence FASTA file
                        "--ref-seq": null,
                    },
                },
                // If null, this argument will be automatically completed by the template.
                "--output": null,
                "--spliced": null,
                "--unspliced": null,
                "--threads": null,
                "--dedup": null,
                "--sparse": null,
                "--kmer-length": null,
                "--overwrite": null,
                "--use-piscem": null,
                "--minimizer-length": null,
                "--keep-duplicates": null,
            },
            // arguments for running `simpleaf quant`
            "simpleaf_quant": {
                // The required fields first 
                "Step": 2,
                "Program Name": "simpleaf quant",

                // simpleaf workflow will ignore all commands with "Active": false
                "Active": true,

                // the transcript name to gene name mapping TSV file.
                // Simpleaf will find the correct t2g map file for splici and spliceu reference.
                // This is required ONLY if `--ref-seq` is specified in the corresponding simpleaf index command. 
                "--t2g-map": null,

                "Other Mapping Options": {
                    // Option 1:
                    // If you have built the reference index already, 
                    // you can change the Step of the simpleaf index call above to a quoted negative integer,
                    // and specify the path to the index here  
                    "1. Mapping Reads FASTQ Files against an existing index": {
                        // read1 (technical reads) files separated by comma (,)
                        "--reads1": null,

                        // read2 (biological reads) files separated by comma (,)
                        "--reads2": null,

                        // the path to an EXISTING salmon/piscem reference index
                        "--index": null
                    },

                    // Option 2:
                    // Choose only if you have an existing mapping directory and don"t want to rerun mapping
                    "2. Existing Mapping Directory": {
                        // the path to an existing salmon/piscem mapping result directory
                        "--map-dir": null,
                    },
                },

                "Cell Filtering Options": {
                    // No cell filtering, but correct cell barcodes according to a permitlist file
                    // If you would like to use other cell filtering options, please change this field to null,
                    // and select one cell filtering strategy listed in the "Optional Configuration section"
                    // DEFAULT
                    "--unfiltered-pl": "", // or "--unfiltered-pl": null 

                    // 2. knee finding cell filtering. If choosing this, change the value from null to "".
                    "--knee": null, // or "--knee": "",

                    // 3. A hard threshold. If choosing this, change the value from null to an integer
                    "--forced-cells": null, // or "--forced-cells": "INT", for example, "--forced-cells": "3000"

                    // 4. A soft threshold. If choosing this, change the null to an integer
                    "--expect-cells": null, //or "--expect-cells": "INT", for example, "--expect-cells": "3000"

                    // 5. filter cells using an explicit whitelist. Only use when you know exactly the 
                    // true barcodes. 
                    // If choosing this, change the null to the path to the whitelist file. 
                    "--explicit-pl": null, // or "--explicit-pl": "/path/to/pl",
                },
                
                "--chemistry": "10xv3",

                "--resolution": "cr-like",
                "--expected-ori": "fw",

                // If null, this argument will be automatically completed by the template.
                "--output": null,

                // If "--threads" is null but the "threads" meta info field is not,
                // "threads" meta data will be used to complete this "--threads".
                "--threads": null,

                "--min-reads": null,
                "--use-piscem": null,
                "--use-selective-alignment": null,

            }
        },
        "crispr_screen": {
            // arguments used for running `simpleaf index`
            "simpleaf_index": {
                // The required fields first
                "Step": 8,
                "Program Name": "simpleaf index",
                // simpleaf workflow will ignore all commands with "Active": false
                "Active": true,

                // The path to the reference sequence FASTA file
                // Only change this if the tag barcode reference file is in the FASTA format
                "--ref-seq": null,

                "--kmer-length": "7",
                "--output": null,
                "--threads": null,
                "--sparse": null,
                "--overwrite": null,
                "--use-piscem": null,
                "--minimizer-length": null,
                "--keep-duplicates": null,
            },

            // Optional arguments for running `simpleaf quant`
            "simpleaf_quant": {
                // The Step of this experiment
                "Step": 9,
                "Program Name": "simpleaf quant",
                // simpleaf workflow will ignore all commands with "Active": false
                "Active": true,

                // the transcript name to gene name mapping TSV file
                // This is required if `--ref-seq` is specified in the corresponding simpleaf index command. 
                "--t2g-map": null,

                "Other Mapping Options": {
                    // Option 1:
                    // If you have built the reference index already, 
                    // you can leave the simpleaf index section unchanged
                    // and specify the path to the index here  
                    "1. Mapping Reads FASTQ Files against an existing index": {
                        // read1 (technical reads) files separated by comma (,)
                        "--reads1": null,

                        // read2 (biological reads) files separated by comma (,)
                        "--reads2": null,

                        // the path to an existing salmon/piscem reference index
                        "--index": null
                    },

                    // Option 2:
                    // Choose only if you have an existing mapping directory and don"t want to rerun mapping
                    "2. Existing Mapping Directory": {
                        // the path to an existing salmon/piscem mapping result directory
                        "--map-dir": null,
                    },
                },

                // By default, the workflow will use the reported cell barcodes in the gene count matrix
                // obtained from processing RNA reads as the explicit permit list for feature barcoding reads.
                // If you want to choose another cell fitlering option, please specify one of the followings.
                "Other Cell Filtering Options": {
                    // 1. No cell filtering, but correct cell barcodes according to a permitlist file
                    //    if you don"t want to use this, change the value from "" to null. 
                    // *RECOMMENDED*
                    "--unfiltered-pl": null, // or "--unfiltered-pl": "" 

                    // 2. knee finding cell filtering. If choosing this, change the value from null to "".
                    "--knee": null, // or "--knee": null,

                    // 3. A hard threshold. If choosing this, change the value from null to an integer
                    "--forced-cells": null, // or "--forced-cells": "INT", for example, "--forced-cells": "3000"

                    // 4. A soft threshold. If choosing this, change the null to an integer
                    "--expect-cells": null, //or "--expect-cells": "INT", for example, "--expect-cells": "3000"

                    // 5. filter cells using an explicit whitelist. Only use when you know exactly the 
                    // true barcodes. 
                    // If choosing this, change the null to the path to the whitelist file. 
                    "--explicit-pl": null, // or "--explicit-pl": "/path/to/pl",
                },
                // details can be found at https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/feature-bc-analysis#crispr-cap
                "--chemistry": "1{b[16]u[12]}2{x:r[20]f[GTTTAAGAGCTAAGCTGGAA]x:}",
                "--resolution": "cr-like",
                "--expected-ori": "fw",

                // If null, this argument will be automatically completed by the template.
                "--output": null,
                "--threads": null,
                "--min-reads": null,
                "--index": null,
                "--use-piscem": null,
                "--use-selective-alignment": null,
            },
        },
    },

##########################################################################################################
// External Commands: The external linux commands that will be run during the execution of the workflow
// README:
// This section records the shell commands that will be called during the execution of the workflow.
// Each subfield should have an unique name and contain the complete information for involing a linux command.
// All shell command fields should match the following format:
//      1. There should be a "Program Name" field that records the path to the program. 
//          For programs in your PATH env varible, for example, `awk`, this can just be the program name.
//          For local programs, you need to specify the path to the executable of that program, for example, 
//          if you have a local compile of bedtools, you need to say "path/to/bedtools"
//      2. There should be a "Step" field that indicates the Step of the command. 
//          Commands with a negative "Step" will be ignored by simpleaf and will not be executed. 
//          Simpleaf workflow will sort all simpleaf commands and external program commands defined in a workflow
//          by their Step to decide the final Step. 
//      3. All rest fields should be named by a quoted integer, for example, "1", "15". 
//          The number indicates the order of the argument in the complete command.
//          Simpleaf will sort the numbers and complete the program call using that order.
//          For example, 
//              {
//               "Program Name": "ls",
//               "Step": 1,
//               "Arguments": ["-lh", "/path/to/dir"]
//              }
//          will be interpreted as `ls -lh /path/to/dir` and will be executed 
//          before any (simpleaf or external program) commands with an Step larger than 1.
#########################################################################################################


    "External Commands": {
        // This function download barcode translation from cell ranger github repo
        "barcode translation file fetch": {
            "Step": 3,
            "Program Name": "wget",
            "Active": true,
            "Arguments": ["-O","TBD", "https://github.com/10XGenomics/cellranger/raw/master/lib/python/cellranger/barcodes/translation/3M-february-2018.txt.gz"],
        },

        // This file gunzip downloaded barcode translation file
        "barcode translation file gunzip": {
            "Step": 4,
            "Program Name": "gunzip",
            "Active": true,
            "Arguments": ["-c","TBD",">","TBD"],
        },

        // Translate RNA barcode to feature barcode
        "barcode translation": {
            "Step": 5,
            "Program Name": "awk",
            "Active": true,
            "Arguments": ["'FNR==NR {dict[$1]=$2; next} {$1=($1 in dict) ? dict[$1] : $1}1'", "TBD","TBD"],
        },

        // This command is used for converting the 
        // reference feature barcodes' TSV file into FASTA file
        // before building the index
        "CRISPR reference CSV to t2g": {
            "Step": 6,
            "Program Name": "awk",
            "Active": true,
            "Arguments": ["-F","','","'NR>1 {sub(/ /,\"_\",$1);print $1\"\\t\"$1}'","TBD",">","TBD"],
        },
        
        // This command is used for converting the 
        // reference feature barcodes' TSV file into FASTA file
        // before building the index
        "CRISPR reference CSV to FASTA": {
            "Step": 7,
            "Program Name": "awk",
            "Active": true,

            "Arguments": ["-F","','","'NR>1 {sub(/ /,\"_\",$1);print \">\"$1\"\\n\"$5}'","TBD",">","TBD"]
        },
    },
};

##########################################################################################################
// PLEASE DO NOT CHANGE ANYTHING BELOW THIS LINE
// The content below is used for parsing the config file in simpleaf internally.
#########################################################################################################

local utils = std.extVar("utils");
local output = std.extVar("output");

// This function replaces the TBD place holders in external commands with the actual values.
local activate_ext_calls(workflow, output_path, fb_ref_path) = 
    // check the existence of cell surface protein barcoding experiment
    local adt = utils.get(workflow, "crispr_screen", use_default = true);
    // check the existence of simpleaf index command
    local adt_index = utils.get(adt, "simpleaf_index", use_default = true);
    local adt_quant = utils.get(adt, "simpleaf_quant", use_default = true);
    // check the existence of `--ref-seq`
    local adt_index_refseq = utils.get(adt, "--ref-seq", use_default = true);
    local adt_quant_t2g = utils.get(adt, "--t2g-map", use_default = true);
    local adt_fasta_path = output_path + "/crispr_feature_reference_barcode.fasta";
    local adt_t2g_path = output_path + "/crispr_feature_t2g.tsv";

    local adt_fasta_path = output_path + "/crispr_feature_reference_barcode.fasta";

    // get bc translation related files
    local bt_file_gz = output_path + "/3M-february-2018.txt.gz";
    local bt_file = output_path + "/3M-february-2018.txt";

    local rna = utils.get(workflow, "gene_expression", use_default = true);
    local rna_quant = utils.get(rna, "simpleaf_quant", use_default = true);
    local rna_quant_output = utils.get(rna_quant, "--output", use_default = true);
    local rna_quant_bc_file = if rna_quant_output == null then null else rna_quant_output + "/af_quant/alevin/quants_mat_rows.txt";

    {
        // Update ADT ref-seq as the output of awk command
        [if adt != null then "crispr_screen"] +: {
            [if adt_index != null then "simpleaf_index"]+: {
                [if adt_index_refseq == null then "--ref-seq"]: adt_fasta_path,
            },

            [if adt_quant != null then "simpleaf_quant"]+: {
                [if adt_quant_t2g == null then "--t2g-map"]: adt_t2g_path,
            }
        },

        // Add output file to awk commands.
        "External Commands" +: {
            "barcode translation file fetch"+: {
                "Arguments": [
                    "-O",
                    bt_file_gz, 
                    "https://github.com/10XGenomics/cellranger/raw/master/lib/python/cellranger/barcodes/translation/3M-february-2018.txt.gz"],
            },

            // This file gunzip downloaded barcode translation file
            "barcode translation file gunzip"+: {
                "Arguments": [
                    "-c",
                    bt_file_gz,
                    ">",
                    bt_file
                ],
            },

            "barcode translation"+: {
                "Arguments": [
                    "'FNR==NR {dict[$1]=$2; next} {$1=($1 in dict) ? dict[$1] : $1}1'", 
                    bt_file,
                    rna_quant_bc_file,
                    ">",
                    rna_quant_bc_file
                ],
            },

            // This command is used for converting the 
            // reference feature barcodes' TSV file into FASTA file
            // before building the index
            "CRISPR reference CSV to t2g" +: {
                [if adt_index_refseq != null then "Active"]: false,
                "Arguments": [
                    "-F",
                    "','",
                    "'NR>1 {sub(/ /,\"_\",$1);print $1\"\\t\"$1}'",
                    fb_ref_path.adt,
                    ">",
                    adt_t2g_path],
            },

            // This command is used for converting the 
            // reference feature barcodes' TSV file into FASTA file
            // before building the index
            "CRISPR reference CSV to FASTA" +: {
                [if adt_index_refseq != null then "Active"]: false,
                "Arguments": [
                    "-F",
                    "','",
                    "'NR>1 {sub(/ /,\"_\",$1);print \">\"$1\"\\n\"$5}'",
                    fb_ref_path.adt,
                    ">",
                    adt_fasta_path],
            },
        },
    };

// This function get the feature reference csv file, that will be used later
local get_fb_ref_path(workflow) = 
    // check the existence of cell surface barcoding experiment
    local adt = utils.get(workflow["Recommended Configuration"], "crispr_screen", use_default = true);
    // check the existence of simpleaf index command
    local adt_index = utils.get(adt, "simpleaf_index", use_default = true);
    // check the existence of reference file
    local adt_ref_path = utils.get(adt_index, "Feature Reference CSV", use_default = true);

    {
        "adt": adt_ref_path
    }
;

// This function assigns the cell barcde list (rownames) reporeted in the gene expression count matrix
// generated using RNA reads as the explicit permitlist for surface protein reads.
// This function will not return the whole object, so the returned object needs to be added to the original object.
local add_explicit_pl(o) =
    // check the existence of cell surface protein barcoding experiment
    local adt = utils.get(o, "crispr_screen", use_default = true);
    // check the existence of simpleaf index command
    local adt_quant = utils.get(adt, "simpleaf_quant", use_default = true);

    local rna = utils.get(o, "gene_expression", use_default = true);
    local rna_quant = utils.get(rna, "simpleaf_quant", use_default = true);
    local rna_quant_output = utils.get(rna_quant, "--output", use_default = true);
    local rna_quant_bc_file = if rna_quant_output == null then null else rna_quant_output + "/af_quant/alevin/quants_mat_rows.txt";
    {
        // assign explicit pl for CRISPR screening
        [
            if adt_quant != null && rna_quant_bc_file != null then
                if !std.objectHas(adt_quant, "--knee") &&
                    !std.objectHas(adt_quant, "--explicit-pl") &&
                    !std.objectHas(adt_quant, "--unfiltered-pl") &&
                    !std.objectHas(adt_quant, "--forced-cells") &&
                    !std.objectHas(adt_quant, "--expect-cells")
                then
                    "crispr_screen"
                else
                    null
            else
                null
        ]+: 
        {
            "simpleaf_quant"+: {
                "--explicit-pl": rna_quant_bc_file
            }
        },
    };

// 1. we process some fields to get required information
local valid_output = utils.get_output(output, workflow);
local fb_ref_path = get_fb_ref_path(workflow);

local workflow1 = utils.combine_main_sections(workflow);
local workflow2 = utils.add_outdir(workflow1, valid_output);
local workflow3 = utils.add_threads(workflow2) + add_explicit_pl(workflow2);

// post processing. 
// decide if running external program calls.
local workflow4 = workflow3 + activate_ext_calls(workflow3, valid_output, fb_ref_path);
local workflow5 = utils.add_index_dir_for_simpleaf_index_quant_combo(workflow4);
workflow5
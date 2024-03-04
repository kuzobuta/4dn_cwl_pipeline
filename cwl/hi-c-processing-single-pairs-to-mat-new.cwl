---
  class: "Workflow"
  cwlVersion: "v1.0"
  label: A single pairs file to .hic & .mcool format
  doc: Original cwl file is from hi-c-processing-pairs.cwl and using new version of cooler. Not performing mergeing pairs, fragment assignment.
  inputs: 
    - 
      fdn_format: "pairs"
      id: "#input_single_pairs"
      type: 
        - "File"
      secondaryFiles:
        - ".px2"
    - 
      fdn_format: "chromsize"
      id: "#chromsizes"
      type: 
        - "File"
    - 
      id: "#outprefix"
      default: "out"
      type:
        - "string"
    - 
      default: 8
      id: "#nthreads"
      type: 
        - "int"
    - 
      default: 1000
      id: "#min_res"
      type: 
        - "int"
    - 
      default: "14g"
      id: "#maxmem"
      type: 
        - "string"
    - 
      default: false
      id: "#higlass"
      type: 
        - "boolean"
    - 
      default: false
      id: "#juicer_res"
      type: 
        - "boolean"
    - 
      default: "1000,2000,5000,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000,10000000"
      id: "#custom_res"
      type: 
        - "string"
    - 
      default: 13
      id: "#nres"
      type: 
        - "int"
    - 
      default: 10000000
      id: "#chunksize"
      type: 
        - "int"
    - 
      default: 0
      id: "#mapqfilter_juicer"
      type: 
        - "int"
    - 
      default: 2
      id: "#max_split_cooler"
      type: 
        - "int"
    - 
      default: false
      id: "#no_balance"
      type: 
        - "boolean"
  outputs: 
    - 
      fdn_format: "hic"
      fdn_output_type: "processed"
      id: "#hic"
      outputSource: "#pairs2hic/hic"
      type: 
        - "File"
    - 
      fdn_format: "mcool"
      fdn_output_type: "processed"
      id: "#mcool"
      #outputSource: "#add-hic-normvector-to-mcool/mcool_with_hicnorm"
      outputSource: "change_file_name/output_file"
      type: 
        - "File"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
    - 
      class: "StepInputExpressionRequirement"
  steps: 
    -
      id: "#cooler"
      in: 
        - 
          arg_name: "pairs"
          fdn_cardinality: "single"
          fdn_format: "pairs"
          fdn_type: "data file"
          id: "#cooler/pairs"
          source: "#input_single_pairs"
        - 
          arg_name: "chrsizes"
          fdn_cardinality: "single"
          fdn_format: "chromsizes"
          fdn_type: "reference file"
          id: "#cooler/chrsizes"
          source: "#chromsizes"
        - 
          arg_name: "binsize"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cooler/binsize"
          source: "#min_res"
        - 
          arg_name: "ncores"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cooler/ncores"
          source: "#nthreads"
        - 
          arg_name: "max_split"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cooler/max_split"
          source: "#max_split_cooler"
      out: 
        - 
          arg_name: "cool"
          fdn_cardinality: "single"
          fdn_format: "cool"
          fdn_type: "data file"
          id: "#cooler/cool"
      run: "cooler_new.cwl"
    - 
      fdn_step_meta: 
        analysis_step_types: 
          - "aggregation"
          - "normalization"
        description: "Merged Pairs file is processed using Juicebox"
        software_used: 
          - "juicer_tools_1.8.9-cuda8"
      id: "#pairs2hic"
      in: 
        - 
          arg_name: "input_pairs"
          fdn_cardinality: "single"
          fdn_format: "pairs"
          fdn_type: "data file"
          id: "#pairs2hic/input_pairs"
          source: "#input_single_pairs"
        - 
          arg_name: "chromsizes"
          fdn_cardinality: "single"
          fdn_format: "chromsizes"
          fdn_type: "reference file"
          id: "#pairs2hic/chromsizes"
          source: "#chromsizes"
        - 
          arg_name: "min_res"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/min_res"
          source: "#min_res"
        - 
          arg_name: "higlass"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/higlass"
          source: "#higlass"
        - 
          arg_name: "custom_res"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/custom_res"
          source: "#custom_res"
        - 
          arg_name: "maxmem"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/maxmem"
          source: "#maxmem"
        - 
          arg_name: "mapqfilter"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/mapqfilter"
          source: "#mapqfilter_juicer"
        - 
          arg_name: "no_balance"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#pairs2hic/no_balance"
          source: "#no_balance"
        - 
          id: "#pairs2hic/output_prefix"
          source: "outprefix"
      out: 
        - 
          arg_name: "hic"
          id: "#pairs2hic/hic"
      run: "pairs2hic.cwl"
    - 
      fdn_step_meta: 
        analysis_step_types: 
          - "aggregation"
          - "normalization"
          - "file format conversion"
        description: "Cooler file is converted to mcool"
        software_used: 
          - "cooler_0.9.3"
      id: "#cool2mcool"
      in: 
        - 
          arg_name: "input_cool"
          fdn_cardinality: "single"
          fdn_format: "cool"
          fdn_type: "data file"
          id: "#cool2mcool/input_cool"
          source: "#cooler/cool"
        - 
          arg_name: "ncores"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cool2mcool/ncores"
          source: "#nthreads"
        - 
          arg_name: "chunksize"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cool2mcool/chunksize"
          source: "#chunksize"
        - 
          arg_name: "juicer_res"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cool2mcool/juicer_res"
          source: "#juicer_res"
        - 
          arg_name: "custom_res"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cool2mcool/custom_res"
          source: "#custom_res"
        - 
          arg_name: "no_balance"
          fdn_cardinality: "single"
          fdn_type: "parameter"
          id: "#cool2mcool/no_balance"
          source: "#no_balance"
      out: 
        - 
          arg_name: "mcool"
          fdn_cardinality: "single"
          fdn_format: "mcool"
          fdn_type: "data file"
          id: "#cool2mcool/mcool"
      run: "cool2mcool_new.cwl"
    - 
      fdn_step_meta: 
        analysis_step_types: 
          - "file format conversion"
        description: "HiC normalization vector is added to mcooler"
        software_used: 
          - "hic2cool_0.5.1"
      id: "#add-hic-normvector-to-mcool"
      in: 
        - 
          arg_name: "input_mcool"
          fdn_cardinality: "single"
          fdn_format: "mcool"
          fdn_type: "data file"
          id: "#add-hic-normvector-to-mcool/input_mcool"
          source: "#cool2mcool/mcool"
        - 
          arg_name: "input_hic"
          fdn_cardinality: "single"
          fdn_format: "hic"
          fdn_type: "data file"
          id: "#add-hic-normvector-to-mcool/input_hic"
          source: "#pairs2hic/hic"
      out: 
        - 
          arg_name: "mcool_with_hicnorm"
          fdn_cardinality: "single"
          fdn_format: "mcool"
          fdn_type: "data file"
          id: "#add-hic-normvector-to-mcool/mcool_with_hicnorm"
      run: "add-hic-normvector-to-mcool.cwl"
    -
      id: "#change_file_name"
      run: "change-file-name.cwl"
      in:
        -
          id: "#change_file_name/input_file"
          source: "#add-hic-normvector-to-mcool/mcool_with_hicnorm"
        -
          id: "#change_file_name/new_filename"
          source: "#outprefix"
          valueFrom: "$(self).mcool"
      out:
        -
          id: "#change_file_name/output_file"

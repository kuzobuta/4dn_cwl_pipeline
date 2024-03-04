---
  class: "Workflow"
  cwlVersion: "v1.0"
  fdn_meta: 
    category: "filter"
    data_types: 
      - "Hi-C"
    description: "This is a subworkflow of the Hi-C data processing pipeline. It takes a bam file as input and performs parsing, sorting, filtering and deduping. It produces a single output file, a filtered pairs (contact list) file with user specified name. Compared with original hi-c-processing-bam.cwl, it did not produce a lossless, filter-annotated bam file."
    name: "hi-c-processing-bam-eco"
    title: "Hi-C Post-alignment Processing"
    workflow_type: "Hi-C data analysis"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
    - 
      class: "ScatterFeatureRequirement"

  inputs: 
    - 
      fdn_format: "bam"
      id: "#input_bams"
      type: 
        - 
          items: "File"
          type: "array"
    
    - 
      id: "#outprefix"
      default: "out"
      type:
        - "string"
    - 
      fdn_format: "chromsizes"
      id: "#chromsize"
      type: 
        - "File"
    - 
      default: 8
      id: "#nthreads_parse_sort"
      type: 
        - "int"
    - 
      default: 8
      id: "#nthreads_merge"
      type: 
        - "int"
  outputs: 
    - 
      fdn_format: "pairs"
      fdn_output_type: "processed"
      fdn_secondary_file_formats: 
        - "pairs_px2"
      id: "#filtered_pairs"
      outputSource: "#pairs-filter/filtered_pairs"
      type: 
        - "File"
    - 
      id: "#dupmarked_pairs"
      outputSource: "#pairs-markasdup/dupmarked_pairs"
      type:
        - "File"

  steps: 
    - 
      id: "#pairs-parse-sort"
      run: "pairs-parse-sort-eco.cwl"
      scatter: "#pairs-parse-sort/bam"
      fdn_step_meta: 
        analysis_step_types: 
          - "annotation"
          - "sorting"
        description: "Parsing and sorting bam file eco"
        software_used: 
          - "pairtools_0.2.2"
      in: 
        - 
          arg_name: "bam"
          fdn_format: "bam"
          id: "#pairs-parse-sort/bam"
          source: "#input_bams"
        - 
          arg_name: "chromsize"
          fdn_format: "chromsize"
          id: "#pairs-parse-sort/chromsize"
          source: "#chromsize"
        - 
          arg_name: "Threads"
          id: "#pairs-parse-sort/Threads"
          source: "#nthreads_parse_sort"
      out: 
        - 
          arg_name: "sorted_pairs"
          fdn_format: "pairsam"
          id: "#pairs-parse-sort/sorted_pairs"
    - 
      id: "#pairs-merge"
      run: "pairs-merge-eco.cwl"
      fdn_step_meta: 
        analysis_step_types: 
          - "merging"
        description: "Merging pairs files"
        software_used: 
          - "pairtools_0.2.2"
      in: 
        - 
          id: "#pairs-merge/input_pairs"
          arg_name: "input_pairs"
          fdn_format: "pairs"
          source: "#pairs-parse-sort/sorted_pairs"
        - 
          arg_name: "nThreads"
          id: "#pairs-merge/nThreads"
          source: "#nthreads_merge"
      out: 
        - 
          arg_name: "merged_pairs"
          fdn_format: "pairs"
          id: "#pairs-merge/merged_pairs"
    - 
      id: "#pairs-markasdup"
      run: "pairs-markasdup-eco.cwl"
      fdn_step_meta: 
        analysis_step_types: 
          - "filter"
        description: "Marking duplicates to pairs file"
        software_used: 
          - "pairtools_0.2.2"
      in: 
        - 
          arg_name: "input_pairs"
          fdn_format: "pairsam"
          id: "#pairs-markasdup/input_pairsam"
          source: "#pairs-merge/merged_pairs"
        -
          id: "#pairs-merge/outprefix"
          source: "#outprefix"
      out: 
        - 
          arg_name: "dupmarked_pairs"
          fdn_format: "pairsam"
          id: "#pairs-markasdup/dupmarked_pairs"
    - 
      id: "#pairs-filter"
      run: "pairs-filter-eco.cwl"
      fdn_step_meta: 
        analysis_step_types: 
          - "filter"
          - "file format conversion"
        description: "Filtering duplicate and invalid reads"
        software_used: 
          - "pairtools_0.2.2"
      in: 
        - 
          arg_name: "input_pairsam"
          fdn_format: "pairsam"
          id: "#pairs-filter/input_pairsam"
          source: "#pairs-markasdup/dupmarked_pairs"
        - 
          arg_name: "chromsize"
          fdn_format: "chromsize"
          id: "#pairs-filter/chromsize"
          source: "#chromsize"
        - 
          id: "#pairs-filter/outprefix"
          source: "#outprefix"
      out:
        - 
          arg_name: "filtered_pairs"
          fdn_format: "pairs"
          id: "#pairs-filter/filtered_pairs"


class: "Workflow"
cwlVersion: "v1.0"

requirements: 
    - 
      class: "InlineJavascriptRequirement"
    - 
      class: "ScatterFeatureRequirement"


inputs: 
    - 
      id: "#input_fastq1_files"
      type: 
        - 
          items: "File"
          type: "array" 
    - 
      id: "#input_fastq2_files"
      type:
        -
          items: "File"
          type: "array"
    -
      id: "#prefix_list"
      type:
        - 
          items: "string"
          type: "array"
    - 
      id: "#bwa_index"
      type:
        - "File"
      secondaryFiles:
        - .amb
        - .ann
        - .bwt
        - .pac
        - .sa
    - 
      id: "#nThreads"
      default: 4
      type:
        - "int"
    
outputs: 
    - 
      id: "#out_bams"
      outputSource: "#bwa-mem-no-decomp/out_bam"
      type:
        - 
          items: "File"
          type: "array"

steps: 
    - 
      id: "#bwa-mem-no-decomp"
      run: "bwa-mem-no-decomp.cwl"
      scatter: 
        - "#bwa-mem-no-decomp/fastq1"
        - "#bwa-mem-no-decomp/fastq2"
        - "#bwa-mem-no-decomp/prefix"
      scatterMethod: dotproduct
      in: 
        - 
          id: "#bwa-mem-no-decomp/fastq1"
          source: "#input_fastq1_files"
        - 
          id: "#bwa-mem-no-decomp/fastq2"
          source: "#input_fastq2_files"
        -
          id: "#bwa-mem-no-decomp/prefix"
          source: "#prefix_list"
        -
          id: "#bwa-mem-no-decomp/bwa_index"
          source: "#bwa_index"
        - 
          id: "#bwa-mem-no-decomp/nThreads"
          source: "#nThreads"
      out: 
        - 
          id: "#bwa-mem-no-decomp/out_bam" 

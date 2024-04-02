---
  cwlVersion: "v1.0"
  hints: 
    - 
      dockerPull: "kuzobuta/4dn-hic:v43"
      class: "DockerRequirement"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
  class: "CommandLineTool"
  baseCommand:
    - "run-bwa-mem-no-decomp.sh"
  arguments: []
  inputs:
    - 
      type: 
        - "File"
      id: "#fastq1"
      inputBinding: 
        position: 1
        separate: true
    - 
      type: 
        - "File"
      id: "#fastq2"
      inputBinding: 
        position: 2
        separate: true
    - 
      type: 
        - "File"
      id: "#bwa_index"
      secondaryFiles:
        - .amb
        - .ann
        - .bwt
        - .pac
        - .sa
      inputBinding: 
        position: 3
        separate: true
    - 
      type: 
        - "int"
      id: "#nThreads"
      inputBinding: 
        position: 6
        separate: true
      default: 4
    - 
      type: 
        - "null"
        - "string"
      id: "#prefix"
      inputBinding: 
        position: 5
        separate: true
      default: "out"
    - 
      type:
        - "null"
        - "string"
      id: "#outdir"
      inputBinding: 
        position: 4
        separate: true
      default: "."
  outputs: 
    - 
      id: "#out_bam"
      type:
        - "File"
      outputBinding:
        glob: "$(inputs.outdir)/*.bam"
  

---
  cwlVersion: "v1.0"
  hints: 
    - 
      class: "DockerRequirement"
      dockerPull: "kuzobuta/4dn-hic:v43"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
  class: "CommandLineTool"
  baseCommand: 
    - "run-pairs-filter-samefrag-MAPQ.sh"
  arguments: []
  inputs: 
    - 
      id: "#input_pairs"
      type: 
        - "File"
      inputBinding: 
        separate: true
        prefix: '-i'
        position: 1
    - 
      id: "#mapq"
      type: 
        - "int"
      default: 10
      inputBinding: 
        separate: true
        prefix: '-q'
        position: 2
    - 
      id: "#outprefix"
      type:
        - "string"
      default: "out"
      inputBinding: 
        separate: true
        prefix: '-o'
        position: 3 
    -
      id: "#disable_fragment_filter"
      type:
        - "boolean"
      default: false
      inputBinding: 
        separate: true
        prefix: '-f'
        position: 4
    - 
      id: "#no_frag_info"
      type:
        - "boolean"
      default: false 
      inputBinding: 
        separate: true
        prefix: '-R'
        position: 5
  outputs: 
    - 
      id: "#mapq_fragment_filtered_pairs"
      outputBinding:
        glob: "$(inputs.outprefix)*.MAPQ$(inputs.mapq).pairs.gz"
      type: 
        - "null"
        - "File"
      secondaryFiles: 
        - ".px2"
    - 
      id: "#samefrag_mapq_n_pairs"
      outputBinding:
        glob: "*.txt"
      type:
        - "File"

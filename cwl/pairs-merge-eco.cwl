---
  baseCommand: 
    - "run-pairs-merge-eco.sh"
  label: output file as .merged.pairs.gz
  inputs: 
    - 
      default: "out"
      type: 
        - "null"
        - "string"
      inputBinding: 
        separate: true
        position: 1
      id: "#outprefix"
    - 
      type: 
        - "int"
      id: "#nThreads"
      inputBinding: 
        position: 2
        separate: true
      default: 8
    - 
      id: "#input_pairs"
      inputBinding: 
        itemSeparator: " "
        position: 3
        separate: true
      type: 
        - "null"
        - 
          items: "File"
          type: "array"
  outputs: 
    - 
      outputBinding: 
        glob: "$(inputs.outprefix + '.merged.pairs.gz')"
      type: 
        - "null"
        - "File"
      id: "#merged_pairs"
  cwlVersion: "v1.0"
  hints: 
    - 
      dockerPull: "duplexa/4dn-hic:v43"
      class: "DockerRequirement"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
  arguments: []
  class: "CommandLineTool"


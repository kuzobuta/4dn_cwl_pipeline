---
  baseCommand: 
    - "run-pairs-markasdup-eco.sh"
  label: output dupmarked pairs file w/o sam info
  inputs: 
    - 
      type: 
        - "null"
        - "File"
      inputBinding: 
        separate: true
        position: 1
      id: "#input_pairsam"
    - 
      default: "out"
      type: 
        - "null"
        - "string"
      inputBinding: 
        separate: true
        position: 2
      id: "#outprefix"
  outputs: 
    - 
      outputBinding: 
        glob: "$(inputs.outprefix + '.marked.pairs.gz')"
      type: 
        - "null"
        - "File"
      secondaryFiles: 
        - ".px2"
      id: "#dupmarked_pairs"
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


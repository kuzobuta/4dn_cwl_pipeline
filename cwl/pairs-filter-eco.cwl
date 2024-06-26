---
  baseCommand: 
    - "run-pairs-filter-eco.sh"
  label: pairs file filtering not generating unmapped pairs file & not exporting lossless bam file 
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
    - 
      type: 
        - "null"
        - "File"
      inputBinding: 
        separate: true
        position: 3
      id: "#chromsize"
  outputs: 
    - 
      outputBinding: 
        glob: "$(inputs.outprefix + '.dedup.pairs.gz')"
      type: 
        - "null"
        - "File"
      secondaryFiles: 
        - ".px2"
      id: "#filtered_pairs"
  cwlVersion: "v1.0"
  hints: 
    - 
      dockerPull: "kuzobuta/4dn-hic:v43"
      class: "DockerRequirement"
  requirements: 
    - 
      class: "InlineJavascriptRequirement"
  arguments: []
  class: "CommandLineTool"


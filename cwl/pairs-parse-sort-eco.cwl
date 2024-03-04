---
  baseCommand: 
    - "run-pairs-parse-sort-eco.sh"
  label: parse bam file to pairs file w/o sam info 
  inputs: 
    - 
      type: 
        - "null"
        - "File"
      inputBinding: 
        separate: true
        position: 1
      id: "#bam"
    - 
      type: 
        - "null"
        - "File"
      inputBinding: 
        separate: true
        position: 2
      id: "#chromsize"
    - 
      default: "."
      type: 
        - "null"
        - "string"
      inputBinding: 
        separate: true
        position: 3
      id: "#outdir"
    - 
      default: "out"
      type: 
        - "null"
        - "string"
      inputBinding: 
        separate: true
        position: 4
      id: "#outprefix"
    - 
      type: 
        - "int"
      id: "#Threads"
      inputBinding: 
        position: 5
        separate: true
      default: 8
    - 
      default: "lz4c"
      type: 
        - "null"
        - "string"
      inputBinding: 
        separate: true
        position: 6
      id: "#compress_programm"
  outputs: 
    - 
      outputBinding: 
        glob: "$(inputs.outprefix + '.pairs.gz')"
      type: 
        - "null"
        - "File"
      id: "#sorted_pairs"
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


---
  cwlVersion: "v1.0"
  label: v240302 pairtools stats commands for single pairs file
  hints:
    -
      class: "DockerRequirement"
      dockerPull: "duplexa/4dn-hic:v43"
  
  class: "CommandLineTool"
  
  baseCommand: [pairtools, stats]
  
  requirements:
    -
      class: "InlineJavascriptRequirement"
    -
      class: "ShellCommandRequirement" 
     
  arguments:
    - 
      position: 1000
      shellQuote: false
      valueFrom: ' && mv $(inputs.out_stats_file) $(inputs.outprefix).stats.txt'
  
  inputs: 
    - 
      id: "#outprefix"
      default: "out"
      type:
        - "string"
    - 
      id: "#out_stats_file"
      default: out.stats.txt
      type:
        - "null"
        - "string"
      inputBinding:
        separate: true
        position: 1
        prefix: "-o"
    -
      id: "#nproc_in"
      default: 1
      type:
        - "int"
      inputBinding:
        separate: true
        position: 2
        prefix: "--nproc-in"
    -
      id: "#nproc_out"
      default: 8
      type:
        - "int"
      inputBinding:
        separate: true
        position: 3
        prefix: "--nproc-out"
    -
      id: "#input_pairs"
      type: 
        - "File"
      inputBinding:
        separate: true
        position: 4
   
  outputs: 
    - 
      id: "#pairs_stats"
      type:
        - "File"
      outputBinding: 
        glob: "*.txt" 

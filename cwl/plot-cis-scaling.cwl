cwlVersion: "v1.0"
label: v240229 plot scaling from pairs file
hints:
  -
    class: "DockerRequirement"
    dockerPull: "kuzobuta/4dn-hic-pairtools:v1.0.3"

class: "CommandLineTool"
baseCommand: ["run-plot-scaling-cis.sh"]
  
requirements:
  -
    class: "InlineJavascriptRequirement"
 
arguments: []

inputs: 
  - 
    id: "#input_pairs"
    type:
      - "File"
    inputBinding:
       separate: true
       position: 1
  -
    id: "#outprefix"
    default: "out"
    type:
      - "string"
    inputBinding:
      separate: true
      position: 2
outputs: 
  - 
    id: "#plot_cis_scaling"
    type:
      - "File"
    outputBinding: 
      glob: "*.pdf"
  - 
    id: "#cis_scaling_trans_levels"
    type:
      - "File"
    outputBinding:
      glob: "*.txt"

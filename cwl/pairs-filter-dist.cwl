cwlVersion: "v1.0"
label: v240227 pairtools dist filtering for single pairs file
hints:
  -
    class: "DockerRequirement"
    dockerPull: "kuzobuta/4dn-hic:v43.1"

class: "CommandLineTool"
baseCommand:
  - "run-pairs-filter-dist.sh"

requirements:
  -
    class: "InlineJavascriptRequirement"
   
arguments: []

inputs:
  - 
    id: "#input_single_pairs"
    inputBinding:
        separate: true
        prefix: "-i"
        position: 1
    type:
      - "File"
  -
    id: "#dist"
    default: "2000"
    inputBinding:
        separate: true
        prefix: "-d"
        position: 2
    type:
      - "string"
  - 
    id: "#outprefix"
    default: "out"
    inputBinding:
        separate: true
        prefix: "-o"
        position: 3
    type:
      - "string"

outputs: 
    - 
      id: "#dist_filtered_pairs"
      outputBinding: 
        glob: "*pairs.gz"
      type: 
        - "null"
        - "File"
      secondaryFiles: 
        - ".px2"
    - 
      id: "#dist_n_pairs"
      outputBinding:
        glob: "*.txt"
      type:
        - "File"

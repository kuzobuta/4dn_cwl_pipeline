cwlVersion: "v1.0"
label: v240229 change file name
hints:
  -
    class: "DockerRequirement"
    dockerPull: "duplexa/4dn-hic:v43"

class: "CommandLineTool"
baseCommand: ["mv"]
  
requirements:
  -
    class: "InlineJavascriptRequirement"
 
arguments: []

inputs: 
  - 
    id: "#input_file"
    type:
      - "File"
    inputBinding:
       separate: true
       position: 1
  -
    id: "#new_filename"
    type:
      - "string"
    inputBinding:
      separate: true
      position: 2

outputs: 
  - 
    id: "#output_file"
    type:
      - "File"
    outputBinding: 
      glob: "*"

class: "Workflow"
cwlVersion: "v1.0"
label: Merge filtered pairs + add fragment info
requirements: 
  - 
    class: "ScatterFeatureRequirement"
  - 
    class: "InlineJavascriptRequirement"
  - 
    class: "StepInputExpressionRequirement"

inputs: 
  - 
    id: "#input_pairs"
    type: 
      - "null"
      - 
        items: "File"
        type: "array"
  - 
    id: "#chromsizes"
    type: 
      - "File"
  - 
    id: "#outprefix"
    default: "out"
    type:
      - "string"
  - 
    id: "#restriction_file"
    type: 
      - "null"
      - "File"

outputs: 
  - 
    id: "merged_pairs_with_frags"
    outputSource: "#addfragtopairs/pairs_with_frags"
    type: 
      - "File"

steps: 
  - 
    id: "#merge-pairs"
    in: 
      - 
        id: "#merge-pairs/input_pairs"
        source: "#input_pairs"
    out: 
      - 
        id: "#merge-pairs/merged_pairs"
    run: "merge-pairs.cwl"
  - 
    id: "#addfragtopairs"
    in: 
      - 
        id: "#addfragtopairs/input_pairs"
        source: "#merge-pairs/merged_pairs"
      - 
        id: "#addfragtopairs/restriction_file"
        source: "#restriction_file"
      - 
        id: "#addfragtopairs/outprefix"
        source: "#outprefix"
    out: 
      - 
        id: "#addfragtopairs/pairs_with_frags"
    run: "addfragtopairs.cwl"

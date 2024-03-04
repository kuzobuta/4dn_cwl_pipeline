class: "Workflow"
cwlVersion: "v1.0"
requirements: 
    - 
      class: "InlineJavascriptRequirement"
    - 
      class: "ScatterFeatureRequirement"

inputs: 
    - 
      id: "#input_pairs_files"
      type: 
        - 
          items: "File"
          type: "array" 
    -
      id: "#prefix_list"
      type:
        - 
          items: "string"
          type: "array"
    - 
      id: "#nproc_in"
      default: 1
      type: 
        - "null"
        - "int"
    - 
      id: "#nproc_out"
      default: 8
      type: 
        - "null"
        - "int"

outputs: 
    - 
      id: "#pairs_stats"
      outputSource: "#pairs-stats-single/pairs_stats"
      type:
        - 
          items: "File"
          type: "array"

steps: 
    - 
      id: "#pairs-stats-single"
      run: "pairs-stats-single.cwl"
      scatter: 
        - "#pairs-stats-single/input_pairs"
        - "#pairs-stats-single/outprefix"
      scatterMethod: dotproduct
      in: 
        - 
          id: "#pairs-stats-single/input_pairs"
          source: "#input_pairs_files"
        - 
          id: "#pairs-stats-single/outprefix"
          source: "#prefix_list"
        -
          id: "#pairs-stats-single/nproc_in"
          source: "#nproc_in"
        -
          id: "#pairs-stats-single/nproc_out"
          source: "#nproc_out"
      out: 
        - 
          id: "#pairs-stats-single/pairs_stats" 

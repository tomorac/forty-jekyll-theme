#!/usr/bin/env bash

set -euo pipefail

mkdir -p _data

if [[ ! -d photos ]]; then
  printf '{}\n' > _data/image_descriptions.yml
  exit 0
fi

exiftool -json -r -ImageDescription photos | ruby -rjson -ryaml -e '
  descriptions = {}
  JSON.parse(STDIN.read).each do |image|
    description = image["ImageDescription"]
    next if description.nil? || description.empty?

    path = image["SourceFile"].sub(%r{\Aphotos/}, "")
    descriptions[path] = description
  end

  File.write("_data/image_descriptions.yml", descriptions.to_yaml)
'
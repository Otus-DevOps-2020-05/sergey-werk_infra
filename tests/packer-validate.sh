#!/usr/bin/env bash
FILES="app.json db.json"

echo "Validate packer files:" $FILES
for file in $FILES ; do
    packer validate -var-file=packer/variables.json.example packer/$file && echo $file - ok
done

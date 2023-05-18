#!/bin/bash
# Security directories builder

function mksecdir() {
        if [  "$1" ]; then
                mkdir $1 $1/{content,exploit,nmaps,payloads,scripts};
                touch $1/content/how_to_do.md;
                echo 'Subdir created called: ' $1;
        else
                mkdir {content,exploit,nmaps,payloads,scripts};
                touch content/how_to_do.md;
        fi
        echo 'Creating security directories';
}

ParentDir=$1
mksecdir $ParentDir

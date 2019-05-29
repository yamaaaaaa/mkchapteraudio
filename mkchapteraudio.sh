#!/bin/sh

if [ $# -ne 3 ];then
    echo "Usage: mkchapteraudio {TargetFile} {AlbumName} {ArtistName}";
    exit 1
fi
 
if [ ! -e $1 ]; then
  echo "File Not Found.($1)"
  exit 1
fi

mkvmerge -o $2.mkv --split chapters:all $1
mkdir $2
find . -type f -name "$2*" | xargs -I VAR ffmpeg -i VAR -vn -acodec copy ./$2/VAR.m4a
find ./$2 -type f -name "$2*" | gsed 's/.mkv.m4a//' | xargs -I {} mv {}.mkv.m4a {}.m4a

find ./$2 -type f -name "$2*" | gsed 's/.mkv.m4a//' | xargs -I {} mv {}.mkv.m4a {}.m4a

rm tmp.m4v
find . -depth 1 -type f | grep './*mkv' | xargs rm

find ./$2 -type f -name "$2*" | xargs -I {} mp4tags -A "$2" -a "$3" -albumartist "$3" {}
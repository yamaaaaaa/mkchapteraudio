#!/bin/sh

if [ $# -ne 3 ];then
    echo "Usage: mkchapteraudio {TargetFile} {AlbumName} {ArtistName}";
    exit 1
fi
 
if [ ! -e $1 ]; then
  echo "File Not Found.($1)"
  exit 1
fi

ffmpeg -i $1 -vn -acodec copy tmp.mp4
mkvmerge -o $2.mkv --split chapters:all tmp.mp4
mkdir $2
find . -type f -name "$2*" | xargs -I VAR ffmpeg -i VAR -vn -ab 480k -ac 2 ./$2/VAR.m4a
find ./$2 -type f -name "$2*" | gsed 's/.mkv.m4a//' | xargs -I {} mv {}.mkv.m4a {}.m4a
rm tmp.mp4
find . -depth 1 -type f | grep './*mkv' | xargs rm

count=0
files=`find ./$2 -type f -name "$2*" | sort`
for f in $files; do
	count=`expr $count + 1`	
	mp4tags -A "$2" -a "$3" -t $count -albumartist "$3" $f
done
#!/bin/bash
style=$2
framerateS2=60
resolutionS1=2160
resolutionS2=1080
audioRateS2=44100
if [[ -z "$1" ]]
then
	printf "input file empty\n"
	exit
elif [[ -z "$2" ]]
then
	printf "style not chosen, falling back to default (style 1)\n"
	style=1
elif ! [[ "$2" =~ ^[0-9]+$ ]]
then
	printf "style can only be an integer number\n"
	exit
fi
if [[ $style -eq 1 ]]
then
	ffmpeg -fflags nobuffer -f rawvideo -pixel_format rgb32 -video_size 32x32 -framerate 10.766666 -i "$1" -f u8 -ar 44100 -ac 1 -i "$1" -sws_flags neighbor -s "$resolutionS1"x"$resolutionS1" "$1".mkv
elif [[ $style -eq 2 ]]
then
	ffmpeg -fflags nobuffer -f u8 -ac 2 -ar $audioRateS2 -i "$1" -filter_complex "[0:a]avectorscope=mode=lissajous_xy:mirror=y:draw=line:rc=30:gc=160:bc=40:af=50:s='$resolutionS2'x'$resolutionS2':rate='$FramerateS2':zoom=1[v];color=black:rate='$FramerateS2',format=rgb24[c];[c][v]scale2ref[c][i];[c][i]overlay=format=yuv420:shortest=1[v]" -map "[v]" -map "0:a" -aspect 1 -crf 23 -c:v libx264 -movflags isml+frag_keyframe "$1".mkv
else
	printf "invalid style number\n"
	exit
fi
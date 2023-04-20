#!/bin/bash

genre="$1"
if [ -z "$genre" ];then
echo "error : genre not specified. Usage: $0 <genre>"
exit 1
fi

if [ ! -d "Movies" -o ! -d "directors" -o "genres" -o ! -d "years" -o ! -d "country" ]; then
echo "error : data folder structure does not exist. Aborting"
exit 1
fi

genre_dir=$(find "genres" -maxdepth 1 -type d -name "*$genre*" -print)

if [ -z "$genre_dir" ]; then
echo "no films found for genre '$genre'."
exit 0
fi

for dir in $genre_dir; do
film_name=$(basename "$dir")
echo "deleting '$film_name'..."
rm -rf "Movies/$film_name"

for subdir in "directors" "years" "country"; do
sublink="$subdir/$(readlink "$subdir/$film_name")"
if [ -L "$sublink" ]; then
echo "removing '$sublink'..."
rm -f "$sublink"
fi
done
done

echo "deleting genre directory '$genre_dir'..."
rm -rf "$genre_dir"
echo "Done."

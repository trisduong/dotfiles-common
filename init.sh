#! /usr/bin/bash
echo "Initializing..."
echo "Creating symlinks..."
for dir in $(ls -d $(pwd)/config/*/); do
    dir_name=$(basename ${dir})
    ln -sf $(pwd)/config/${dir_name} ~/.config/
done

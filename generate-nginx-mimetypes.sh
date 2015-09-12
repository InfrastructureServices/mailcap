#!/bin/sh

echo "types {"
sed -e 's/#.*//' -e 's/$/;/' -ne '/[^[:space:]][[:space:]]\{1,\}[^[:space:]]/p'
echo "}"

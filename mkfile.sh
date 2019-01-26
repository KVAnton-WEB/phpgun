#!/bin/bash
echo "Start..."

echo "Будет создано $1 файлов..."

for ((n = 0; n < $1; n++))
do
	touch "./test/test_$n.log";
done

echo "End..."


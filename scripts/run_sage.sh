#! /bin/sh
#
# run_sage.sh
# Copyright (C) 2021 gins <gins@ginsSlim7>
#
# Distributed under terms of the MIT license.
#


for num in {1..10}
do
	echo "------------"
	sage ./scripts/test.sage $num 16 16 16
done
exit 0

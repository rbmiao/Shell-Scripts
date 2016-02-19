#!/bin/bash
for X in *.sh
do
		grep -L '<UL>' "$X"
done

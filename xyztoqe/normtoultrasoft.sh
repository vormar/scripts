#!/bin/bash
sed -i 's/Si.pbe-rrkj.UPF/Si.pbe-n-van.UPF/' $1
sed -i 's/O.pbe-mt.UPF/O.pbe-rrkjus.UPF/' $1
sed -i 's/H.pbe-vbc.UPF/H.pbe-rrkjus.UPF/' $1



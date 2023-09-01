#!/bin/bash
clear

python="/mnt/host/c/Anaconda3/python.exe"
freefem="/mnt/host/c/Users/ugo.pelissier/FreeFem++/FreeFem++.exe"
gmsh="/mnt/host/c/Users/ugo.pelissier/gmsh/gmsh.exe"
mmg3d="/mnt/host/c/Users/ugo.pelissier/mmg/mmg3d_O3.exe"

for arg in "$@"
do
   key=$(echo $arg | cut -f1 -d=)

   key_length=${#key}
   value="${arg:$key_length+1}"

   export "$key"="$value"
done

if [ $data -lt 10 ]
  then
    data=00$data
    elif [ $data -lt 100 ]
        then
        data=0$data
fi

echo $data >> data.txt

data_dir=data/cad_$data

mkdir -p $data_dir/sol/
mkdir -p $data_dir/adapt/

rm adapt.log

echo "Generating geo file (python)"
$python geo.py -d $data >> adapt.log

echo "Converting msh (gmsh) to mesh (INRIA)"
$gmsh convert.geo >> adapt.log

echo "Computing adaptation metric (FreeFem++)"
$freefem metric.edp >> adapt.log

rm data.txt

echo "Adapting mesh (MMG) to real solution"
$mmg3d $data_dir/mesh/cad_$data.mesh -sol $data_dir/sol/cad_$data.sol >> adapt.log
mv $data_dir/mesh/cad_$data.o.mesh $data_dir/adapt/cad_${data}.o.mesh

echo "Adapting mesh (MMG) to predicted solution"
$mmg3d $data_dir/mesh/cad_$data.mesh -sol $data_dir/sol/cad_${data}_pred.sol >> adapt.log
mv $data_dir/mesh/cad_$data.o.mesh $data_dir/adapt/cad_${data}_pred.o.mesh

rm $data_dir/mesh/cad_$data.o.sol

echo "Done writting adapted meshes to $data_dir/adapt/"
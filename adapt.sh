#!/bin/bash
clear

python="/mnt/host/c/Anaconda3/python.exe"
freefem="/mnt/host/c/Users/ugo.pelissier/FreeFem++/FreeFem++.exe"
gmsh="/mnt/host/c/Users/ugo.pelissier/gmsh/gmsh.exe"
mmg3d="/mnt/host/c/Users/ugo.pelissier/mmg/mmg3d_O3.exe"

if [ "$1" == "-h" ]; then
    echo "Usage: ./adapt.sh -d <data>"
    echo "data: number of the data to adapt"
    echo "step: test or predict"
    exit 0
fi

while getopts d:s: flag
do
    case "${flag}" in
        d) data=${OPTARG};;
        s) step=${OPTARG};;
    esac
done

if [ $data -lt 10 ]
  then
    data=00$data
    elif [ $data -lt 100 ]
        then
        data=0$data
fi

echo $data >> src/data.txt
echo $step >> src/step.txt

data_dir=src/data/cad_$data

mkdir -p $data_dir/sol/
mkdir -p $data_dir/adapt/

rm src/adapt.log

echo "Generating geo file (python)"
$python src/geo.py -d $data >> src/adapt.log

echo "Converting msh (gmsh) to mesh (INRIA)"
$gmsh src/convert.geo - >> src/adapt.log

echo "Computing adaptation metric (FreeFem++)"
$freefem src/metric.edp >> src/adapt.log

rm src/data.txt
rm src/step.txt

if [ '$step' = 'test' ]
then
    echo "Adapting mesh (MMG) to real solution"
    $mmg3d $data_dir/mesh/cad_$data.mesh -sol $data_dir/sol/cad_$data.sol >> src/adapt.log
    mv $data_dir/mesh/cad_$data.o.mesh $data_dir/adapt/cad_${data}.o.mesh
fi

echo "Adapting mesh (MMG) to predicted solution"
$mmg3d $data_dir/mesh/cad_$data.mesh -sol $data_dir/sol/cad_${data}_pred.sol >> src/adapt.log
mv $data_dir/mesh/cad_$data.o.mesh $data_dir/adapt/cad_${data}_pred.o.mesh

rm $data_dir/mesh/cad_$data.o.sol

echo "Done writting adapted meshes to $data_dir/adapt/"
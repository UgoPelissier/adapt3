# 3d mesh adaptation

This repository contains the source code for 3d mesh adaptation based on the [mmg3d](https://www.mmgtools.org/) library.

To use the code, you need to install the [mmg3d](https://www.mmgtools.org/) library and put the path to the library in the `adapt.sh` file, along with the path to the other libraries.

The data files are in the `data` folder. It is required to provide:
- the initial mesh in the `data/mesh` folder (in `.msh` format)
- the solution fields generated by graphnet network in the `data/field` folder (in `.txt` format)

The `adapt.sh` file contains the commands to run the adaptation. The `adapt.sh` file can be run with the command `bash ./adapt.sh -d 499` in the terminal.

The `adapt.sh` file contains the following steps:
- Generating geo file (`python`)
- Converting msh (`GMSH`) to mesh format (INRIA)
- Computing adaptation metric (`FreeFem++`)
- Adapting mesh (`MMG`) to real solution
- Adapting mesh (`MMG`) to predicted solution
- Writting results in `$data_dir/adapt/` folder
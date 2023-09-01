import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--data", type=str)

args = parser.parse_args()
data = args.data

with open("convert.geo", 'w') as geo:
    geo.write('//+\nSetFactory("OpenCASCADE");\n')
    geo.write('//+\nMerge "data/cad_{:s}/mesh/cad_{:s}.msh";\n'.format(data, data))
    geo.write('//+\nSave "data/cad_{:s}/mesh/cad_{:s}.mesh";\n'.format(data, data))
    geo.write('//+\nExit;\n')
#!/usr/bin/python

import getopt, random, os, sys 
from PIL import Image
from scipy import misc
import matplotlib.pyplot as plt
import numpy as np

def limit(a, b):
    if a < b:
        return a
    else: return b
    
def generate_cut(image_matrix):
    x,y = image_matrix.shape[:2]
    x_start = random.randint(0, int(x/2))
    y_start = random.randint(0, int(y/2))
    x_end = limit(x_start + int(x/2) + random.randint(0, int(x/16)), x)
    y_end = limit(y_start + int(y/2) + random.randint(0, int(y/16)), y)
    image_cut = image_matrix[x_start:x_end, y_start:y_end]
    return image_cut


def write_cuts(copies, inpf, outf):
    # get sources an generate copies cuts for each source
    # then store every cut in its corresponding source folder

    #create output folders with all the sources carpets --> source_training
    root_folder = os.path.join(outf, "source_training")
    test_folder = os.path.join(outf, "test")
    os.makedirs(root_folder)
    os.makedirs(test_folder)

    # inputs
    sources_path = os.path.join(inpf, "sources")
    not_sources_path = os.path.join(inpf, "not_sources","test")

    # get all the sources from the path
    sources = []
    for (dirpath, dirnames, filenames) in os.walk(sources_path):
        sources.extend([sources_path + "/" + file for file in filenames])
        break
    
    not_sources = []
    for (dirpath, dirnames, filenames) in os.walk(not_sources_path):
        not_sources.extend([not_sources_path + "/" + file for file in filenames])
        break

    # for each source create a subfolder of source_training and store the cuts
    for i,source in enumerate(sources):
        source_directory = os.path.join(root_folder, "class_" + str(i))
        test_directory = os.path.join(test_folder, "class_" + str(i))
        os.makedirs(source_directory)
        os.makedirs(test_directory)
        image = misc.imread(source)
        for copy in range(copies):
            image_cut = generate_cut(image)
            im = Image.fromarray(image_cut)
            im.save(os.path.join(source_directory, "copy_" + str(copy) + ".jpg"))
        for k in range(10):
            test_cut = image_cut = generate_cut(image)
            im_test = Image.fromarray(test_cut)
            im_test.save(os.path.join(test_directory, "test_copy_" + str(k) \
                                      + ".jpg"))


    # create another class for not_sources
    not_source_directory = os.path.join(root_folder, "class_" + str(len(sources)))
    test_directory_not = os.path.join(test_folder, "class_" + str(len(sources)))
    os.makedirs(not_source_directory) 
    os.makedirs(test_directory_not)
    for i,not_source in enumerate(not_sources):
        for copy in range(copies):
            image_cut = generate_cut(misc.imread(not_source))
            im = Image.fromarray(image_cut)
            im.save(os.path.join(not_source_directory, "copy_" + str(i) + "_" \
                                 + str(copy) + ".jpg")) 
        for k in range(10):
            test_cut = image_cut = generate_cut(image)
            im_test = Image.fromarray(test_cut)
            im_test.save(os.path.join(test_directory_not, "test_copy_" + str(k) \
                                      + ".jpg"))


def main(argv):
    inputdir = ''
    outputdir = ''

    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print('creating_input.py -i <inputdir> -o <outputdir>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('creating_input.py -i <inputdir> -o <outputdir>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputdir = arg
        elif opt in ("-o", "--ofile"):
         outputdir = arg
         
    copies = 200
    write_cuts(copies, inputdir, outputdir)

    print('Input path is ', inputdir)
    print('Output path is ', outputdir)


if __name__ == "__main__":
    main(sys.argv[1:])


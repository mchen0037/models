import os
import zipfile

# make sure you export $PATH_TO_GBCC_CONVERTER '<path_to_convert4_repo>'
# same with PATH_TO_MODELS_FOLDER
PATH_TO_GBCC_CONVERTER = os.getenv("PATH_TO_GBCC_CONVERTER")
PATH_TO_MODELS_FOLDER = os.getenv("PATH_TO_MODELS_FOLDER")

FILE_NAME = "drawing-gallery"
FILE_LOCATION = PATH_TO_MODELS_FOLDER + FILE_NAME + ".nlogo"
EXPECTED_ZIP_LOCATION = PATH_TO_MODELS_FOLDER + FILE_NAME + ".zip"

print("generating " + FILE_NAME + ".nlogo")

# os.system("cp " + FILE_NAME + PATH_TO_GBCC_CONVERTER + "/" + FILE_NAME)
# os.system("node " + PATH_TO_GBCC_CONVERTER + "/converter.js " + FILE_NAME)
os.system("node convert4/converter.js " + FILE_LOCATION)
os.system("mv " + EXPECTED_ZIP_LOCATION + " ./")

with zipfile.ZipFile(FILE_NAME + ".zip", 'r') as zip_ref:
    zip_ref.extractall("./gbcc-models/" + FILE_NAME)

os.system("rm " + FILE_NAME + ".zip")

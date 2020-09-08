# Removes the NetLogo Code and Command Center tabs from a GBCC Model
# Run in gbcc/ filepath.
import os

GBCC_MODEL_NAME = "lattice-land-revised"
PATH_TO_SKELETON = "gbcc-models/" + GBCC_MODEL_NAME + "/app/netlogoweb/skeleton.js"

print("Replacing skeleton.js to remove Command Center and NetLogo Code for %s..." % GBCC_MODEL_NAME)
os.system("rm " + PATH_TO_SKELETON)
os.system("cp scripts/templates/skeleton.js " + PATH_TO_SKELETON)

print("Success")

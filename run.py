import os
from ctypes import cdll

for project in os.listdir("build"):
    for libfile in os.listdir("build/" + project):
        if not libfile.endswith(".so"):
            continue

        lib = cdll.LoadLibrary("build/" + project + "/" + libfile)
        try:
            print(f"{project}/{libfile}: {lib.Hello()}")
        except AttributeError:
            print(f"{project}/{libfile}: Hello() symbol was not found :(")

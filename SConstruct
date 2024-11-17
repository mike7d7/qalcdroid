#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.
#TODO verify that os.getenv() doesn't error out outside NixOS, add path for standard linux
env.Append(CPPPATH=[
                    "src/",
                    os.getenv("includePath").split(":"),
                    ])
sources = Glob("src/*.cpp")

env.Append(LIBS=["libqalculate"])

if env["platform"] == "android":
    env.Append(LIBPATH=["src/libs/arm64-v8a"])
    # env.Append(LINKFLAGS=["-v"])
else:
    env.Append(LIBPATH=["/usr/lib"])
    #TODO verify that os.getenv() doesn't error out outside NixOS
    env.Append(LIBPATH=[os.getenv("libPath")]) 

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "bin/libgdexample.{}.{}.framework/libgdexample.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "bin/libgdexample{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)

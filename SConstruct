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
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

env.Append(LIBS=["libqalculate"])

if env["platform"] == "android":
    env.Append(LIBPATH=["src/libs/arm64-v8a"])
    # env.Append(LINKFLAGS=["-v"])
else:
    env.Append(LIBPATH=["/usr/lib"])
    # TODO: don't hard-link share path in nix
    env.Append(LIBPATH=["/nix/store/g95m2qgx2zy4pddjxv0q09z4p23wd2gr-libqalculate-5.2.0/lib"]) 

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

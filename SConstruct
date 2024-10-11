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
# TODO: don't hard-link share path in nix, add path for standard linux
env.Append(CPPPATH=[
                    "src/",
                    "/nix/store/gg6icgbbz5zmil4adph44aidrn0x2182-libqalculate-5.3.0-dev/include/",
                    "/nix/store/lra2jxa2793339iv0yxyw14i31i85p8l-gmp-with-cxx-6.3.0-dev/include/",
                    "/nix/store/1jkw2qskmmz46apmzi6h30bjx7j12nxb-mpfr-4.2.1-dev/include/"
                    ])
sources = Glob("src/*.cpp")

env.Append(LIBS=["libqalculate"])

if env["platform"] == "android":
    env.Append(LIBPATH=["src/libs/arm64-v8a"])
    # env.Append(LINKFLAGS=["-v"])
else:
    env.Append(LIBPATH=["/usr/lib"])
    # TODO: don't hard-link share path in nix
    env.Append(LIBPATH=["/nix/store/njvc8mzv3gp8a6g1k2d3rvd8rgzhivsb-libqalculate-5.3.0/lib"]) 

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

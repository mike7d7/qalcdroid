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
                    "/nix/store/i7pqadn9f4ajas6v3r6b41bb51yy7cch-libqalculate-5.3.0-dev/include/",
                    "/nix/store/chb5mlvm8kq7lkb8cpkmpr7qdl31jayf-gmp-with-cxx-6.3.0-dev/include/",
                    "/nix/store/hcq5ha2jb7an23p7f1gl3bjvj98i2kls-mpfr-4.2.1-dev/include/"
                    ])
sources = Glob("src/*.cpp")

env.Append(LIBS=["libqalculate"])

if env["platform"] == "android":
    env.Append(LIBPATH=["src/libs/arm64-v8a"])
    # env.Append(LINKFLAGS=["-v"])
else:
    env.Append(LIBPATH=["/usr/lib"])
    # TODO: don't hard-link share path in nix
    env.Append(LIBPATH=["/nix/store/f5pp1svgak2fq94zjsjap5crm73qd7v2-libqalculate-5.3.0/lib"]) 

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

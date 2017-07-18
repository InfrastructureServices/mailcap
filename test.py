#!/usr/bin/python3 -Wd

from collections import defaultdict
import fileinput
import re
import sys


ext2type = {}
seentype = defaultdict(int)
toplevel = defaultdict(int)

good_toplevel = {
    "application",
    "audio",
    "chemical",
    "font",
    "image",
    "message",
    "model",
    "multipart",
    "text",
    "video",
    "x-conference",
    "x-epoc",
}

for line in fileinput.input():

    if re.search(r"^\s*(#|$)", line):
        continue

    line = line.lower()
    type_, *exts = line.split()
    seentype[type_] += 1

    toptype = type_.split("/", 1)[0]
    toplevel[toptype] += 1

    for ext in exts:
        ext2type.setdefault(ext, []).append(type_)

dupes = []
for ext in sorted(ext2type.keys()):
    types = ext2type[ext]
    if len(types) < 2:
        continue
    dupes.append("%s => %s" % (ext, ", ".join(sorted(types))))
for type_ in sorted(seentype.keys()):
    count = seentype[type_]
    if count < 2:
        continue
    dupes.append("%s (%d)" % (type_, count))

print("Top level types:")
for toptype in sorted(toplevel.keys()):
    print("%16s: %d" % (toptype, toplevel[toptype]))
print("%d types, %d extensions" % (len(seentype), len(ext2type)))

dupe_error = False
for dupe in dupes:
    print("Error: duplicate mapping: %s" % dupe)  # XXX to stderr
    dupe_error = True
if not dupe_error:
    print("No duplicate mappings found.")

toplevel_error = False
for toptype in sorted(toplevel.keys()):
    if toptype not in good_toplevel:
        print("Error: bad top level type: %s" % toptype)
        toplevel_error = True
if not toplevel_error:
    print("No bad top level types found.")

sys.exit((dupe_error or toplevel_error) and 1 or 0)

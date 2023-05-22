"""
Script for recognizing differences between mime.types file
and IANAs official list of types.
"""

import urllib.request
import re

already_have = []
upstream_present = []

file_mime_clean = open("mime.types", "r")
lines_file_mime_data = file_mime_clean.read()
file_mime_clean.close()

lines_file_mime_data = re.sub(r"#[^\n]*\n", "", lines_file_mime_data)
lines_file_mime_data = re.sub(r"\n\n", "", lines_file_mime_data)

for line in lines_file_mime_data.splitlines():
    if len(line) >= 2:
        new_line = re.search(r"[a-z0-9A-Z/+\-\._]+", line).group(0)
        already_have.append(new_line)

urls = ["https://www.iana.org/assignments/media-types/text.csv",
        "https://www.iana.org/assignments/media-types/application.csv",
        "https://www.iana.org/assignments/media-types/audio.csv",
        "https://www.iana.org/assignments/media-types/font.csv",
        "https://www.iana.org/assignments/media-types/image.csv",
        "https://www.iana.org/assignments/media-types/message.csv",
        "https://www.iana.org/assignments/media-types/model.csv",
        "https://www.iana.org/assignments/media-types/multipart.csv",
        "https://www.iana.org/assignments/media-types/video.csv"
        ]

for url in urls:
    url_response = urllib.request.urlopen(url)
    url_data = url_response.read()
    url_text = url_data.decode('utf-8')
    url_text = re.sub(r"[A-Za-z,]+\r\n", "", url_text, 1)
    url_text = re.sub(r"[a-zA-Z0-9\-+_ \.\(\)]+OBSOLETED.*\r\n", "", url_text)
    url_text = re.sub(r"[a-zA-Z0-9\-+_ \.\(\)]+DEPRECATED.*\r\n", "", url_text)
    lines_csv_file = url_text.splitlines()
    for line in lines_csv_file:
        if len(line.split(',', 10)[1]) <= 1:
            name = re.search(r"([a-z]+)\.csv", url).group(1) + \
                "/" + line.split(',', 10)[0]
        else:
            name = line.split(',', 10)[1]
        upstream_present.append(name)

for record in upstream_present:
    if record not in already_have:
        print("record %s not present in our file" % (record))

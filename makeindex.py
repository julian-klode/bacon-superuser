#!/usr/bin/python3
#
# Copyright 2014 Julian Andres Klode <jak@jak-linux.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import time

import apt_pkg

HTML = open("index.html.in").read()

TMPL = """
        <tr>
          <td><a href="{name}">{name}</a></td>
          <td>{mtime}</td>
          <td>{size}</td>
        </tr>"""

body = []

for name in sorted(os.listdir("out")):
    if "signed" not in name:
        continue
    st = os.stat("out/" + name)
    body.append(TMPL.format(name=name, st=st,
                            mtime=time.strftime("%a, %d %b %Y %H:%M:%S +0000",
                                                time.gmtime(st.st_mtime)),
                            size=apt_pkg.size_to_str(st.st_size)))

print(HTML.format(body='\n'.join(body)))

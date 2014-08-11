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

HTML = """
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Index of /cm/</title>

    <!-- Le styles -->
    <link rel="stylesheet" href="/style.css" type="text/css" />
    <link rel="stylesheet" href="/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="/local.css" type="text/css" />
  </head>

  <body>


    <div class="navbar navbar-fixed-top">
        <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="">JAK LINUX</a>
          <ul class="nav">
            <li ><a href="/projects/debimg/">debimg</a></li>
            <li ><a href="/projects/dh-autoreconf/">dh-autoreconf</a></li>
            <li ><a href="/projects/dir2ogg/">dir2ogg</a></li>
            <li ><a href="/projects/hardlink/">hardlink</a></li>
            <li ><a href="/projects/ndisgtk/">ndisgtk</a></li>
          </ul>
          <ul class="nav pull-right">
                    <li ><a href="/about/">About</a></li>
                    <li ><a href="/recentchanges/">RecentChanges</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="content">
          <header class="page-header">
                <h1>Index of /cm</h1>
          </header>


    <table style="width: 100%">
      <thead>
        <tr>
            <th>Filename</th>
            <th>Modification time</th>
            <th>Size</th>
        </tr>
      </thead>
      <tbody>
{body}
      </tbody>
    </table>
    </div>
      <footer>
        <p>
                Copyright © 2014 Julian Andres Klode<br/>

        <a href="https://github.com/julian-klode/bacon-superuser">Source and Legal Information</a>&nbsp;|&nbsp;<a href="http://validator.w3.org/check?uri=referer">Valid XHTML 5</a>
        </p>
      </footer>
    </div>
  </body>
</html>"""


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

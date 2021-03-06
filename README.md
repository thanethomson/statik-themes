# Statik Themes

This repository will progressively house themes for
[Statik](https://getstatik.com), the generic static web site generator for
developers. At present, the structure of this repository is a standard
**Statik** project, with all themes contained within the `themes` folder
of this project.

Feel free to contribute your theme here!

## Building Themes
To build different versions of this test project for each theme in
the `themes` folder, there's a `build-all-themes.sh` BASH script
(Linux and macOS only) to do so. It builds each theme into its own
`public-<theme_name>` folder. To run it, simply do the following:

```bash
> ./build-all-themes.sh
```

## License
Licenses for adapted themes can be found in each theme's subfolder
within the `themes` folder. Content outside of those themes is
subject to the following license.

**The MIT License (MIT)**

Copyright (c) 2017 Thane Thomson

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

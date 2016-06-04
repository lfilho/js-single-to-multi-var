[![CircleCI](https://circleci.com/gh/lfilho/js-single-to-multi-var/tree/master.svg?style=svg)](https://circleci.com/gh/lfilho/js-single-to-multi-var/tree/master)

Javascript Single to Multiple Var
=================================

- [Overview](#Overview)
- [Assumptions/Caveats](#Assumptions_Caveats)
- [Installation](#Installation)
- [Usage](#Usage)
- [Acknowledgments](#Acknowledgments)

<a name="Overview">
## Overview

_(soon)_

<a name="Assumptions_Caveats">
## Assumptions / Caveats

- **One variable per line**

  This:

  ```javascript
  var a, b,
      c,
      d;
  ```
  Will become this:

  ```javascript
  var a, b;
  var c;
  var d;
  ```
- **Blocks (functions, object, arrays) should have their openings brackets as the line's last char**

  ```javascript
  var a = function(b, c) {
          //...
      },
      d;
  ```
- **Var declarations must be in  "comma last" style (commas are at the end of the line instead of in the beggining)**

  Good:

  ```javascript
  var a,
      b,
      c;
  ```
  Bad:

  ```javascript
  var a
     ,b
     ,c;
  ```
- **No comments after var declarations (in the same line)**

  ```javascript
  var a,
      b, // With this comment, it won't work
      c;
  ```

Contributions in supporting those edge cases above are very welcome.

<a name="Installation">
## Installation

1. Download / clone this repo.
2. Within your shell, navigate to the folder you just downloaded / cloned.
3. Create a convenience link for later usage:

   ```shell
   ln -s `pwd`/convert.sh /usr/local/bin/to-multi-var
   ```

<a name="Usage">
## Usage

### Calling the script

You can call the script by running:

```shell
<path-where-you-downloaded-it>/convert.sh [arguments]
```

For example:

```shell
/Users/lfilho/workspace/js-single-to-multi-var/convert.sh [arguments]
```

Or, if you did the convenience step from the installation steps above:

```shell
to-multi-var [arguments]
```

### Arguments

- **No arguments**

  ```shell
  to-multi-var
  ```

  Will recurse in all `*.js` files in the current directory

- **With arguments**

  You can also pass as many files and folders as you want.
  All directories passed will be traversed recursively.

  Consider the following folder structure

  ```
  myProject
  ├── folderA/
  │   ├── file1.js
  │   ├── file2.js
  │   └── folderB/
  │       ├── file3.js
  │       └── file4.js
  ├── folderC/
  │   ├── file5.js
  │   └── file6.js
  └── file7.js
  ```
  Suppose you wanted to convert:

  - All files inside `folderB`
  - Single file `folderC/file5.js`
  - Single file `file7.js`

  You'd run:

  ```shell
  to-multi-var file7.js folderC/file5.js folderB
  ```

  Arguments order doesn't matter.

<a name="Acknowledgments">
## Acknowledgments

- [@stefanbuck](https://github.com/stefanbuck) for helping identifying different declaration cases.


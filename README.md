[![CircleCI](https://circleci.com/gh/lfilho/js-single-to-multi-var/tree/master.svg?style=svg)](https://circleci.com/gh/lfilho/js-single-to-multi-var/tree/master)

Javascript Single to Multiple Var
=================================

- [Overview](#Overview)
- [Assumptions/Caveats](#Assumptions_Caveats)
- [Installation](#Installation)
  - [As a shell script](#Installation_As_a_shell_script) (for converting several files)
  - [As a vim plugin](#Installation_As_a_vim_plugin) (for every day usage)
- [Usage](#Usage)
  - [As a shell script](#Usage_As_a_shell_script) (for converting several files)
  - [As a vim plugin](#Usage_As_a_vim_plugin) (for every day usage)
- [Tests](#Tests)
- [Acknowledgments](#Acknowledgments)

<a name="Overview">
## Overview

This script / plugins comes to rescue of the unfortunate people that need to convert things like:

```javascript
var a,
    b = 2,
    c = function() {
        var x,
            z;
        //...
    },
    d = {
       //...
    },
    e;
```

to

```javascript
var a;
var b = 2;
var c = function() {
   var x,
   var z;
   //...
};
var d = {
   //...
};
var e;
```

**Note that** it also adjusts the indentation accordingly. If you see your indentation messed up, you probably have different settings that the plugin's default - take a look at the [`vimrc`](vimrc) in use and adjust it to your taste.

For more examples of the cases it covers or not, take a look at the `test/test-*` files to see what and how it will convert.

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
- **Blocks (functions, object, arrays) should have their openings brackets as the line's last char**. Comments are fine, though.

  ```javascript
  var a = function(b, c) {
          //...
      },
      d = { // This is fine
          a: b
      },
      e;
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

Contributions in supporting those edge cases above are very welcome.

<a name="Installation">
## Installation

<a name="Installation_As_a_shell_script">
### As a shell script

1. Download / clone this repo somewhere in your computer and remember where you did it :D

<a name="Installation_As_a_vim_plugin">
### As a vim plugin

1. Just add `lfilho/js-single-to-multi-var` to your your plugin list and tell your plugin manager to install it

<a name="Usage">
## Usage

<a name="Usage_As_a_shell_script">
### As a shell script
#### Calling the script

You can call the script by running:

```shell
<path-where-you-downloaded-it>/to_multi_var [arguments]
```

For example:

```shell
/Users/lfilho/workspace/js-single-to-multi-var/to_multi_var [arguments]
```

For the next examples in this file we'll just use `to_multi_var` for short.

#### Arguments

- **No arguments**

  ```shell
  to_multi_var
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
  to_multi_var file7.js folderC/file5.js folderB
  ```

  Arguments order doesn't matter.

<a name="Usage_As_a_vim_plugin">
### As a vim plugin

After installing it, you can use it by:
1. Calling the plugin directly:

   ```
   call to_multi_var#single_to_multi_var()
   ```
2. Creating a command for later usage (put this somewhere in your vimrc):

   ```
   command! SingleToMultiVar call to_multi_var#single_to_multi_var()
   ```
   And then invoking it like so:

   ```
   :SingleToMultiVar
   ```
3. Mapping it to a key combination (let's say `<leader>v`):

   ```
   autocmd FileType js,javascript,javascript.jsx noremap <silent> <Leader>v :call to_multi_var#single_to_multi_var()<CR>
   ```

<a name="Tests">
## Tests

This script/plugin was tested on:

| OS    | Vim version                                                    |
| ----- | -------------------------------------------------------------- |
| Linux | 7.4 patches 1-1817 (always the lastest Homebrew's Vim, via CI) |
| OSX   | 7.4 patches 1-969 (Homebrew's MacVim)                          |
| OSX   | 7.4 patches 1-1655 (Homebrew's MacVim)                         |
| OSX   | 7.4 patches 1-1707 (Homebrew's MacVim)                         |
| OSX   | 7.4 patches 1-1831 (Homebrew's MacVim)                         |

For more information on how testing is done, see the [test file](test/test).

<a name="Acknowledgments">
## Acknowledgments

- [@stefanbuck](https://github.com/stefanbuck) for helping identifying different declaration cases.
- [@matthewfranglen](https://github.com/matthewfranglen) for helping debugging vim behaving weirdly

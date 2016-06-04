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

_(soon)_

<a name="Usage">
## Usage

_(soon)_

<a name="Acknowledgments">
## Acknowledgments

- [@stefanbuck](https://github.com/stefanbuck) for helping identifying different declaration cases.


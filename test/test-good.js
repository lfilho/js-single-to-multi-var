var ONE = 'one';
var TWO = 2;
var THREE = 'três';

function testing() {
    var initialAndUndefined;
    var testUndefined;
    var assigned = ONE;
    // comment in the middle
    var anonymous = function() {
        var foo = TWO;
        var bar = THREE;
    };
    var object = {
        a: 0,
        b: 1
    };
    var arrayWithObjects = [{
        c: 2,
        d: 3
    }, {
        e: 4,
        f: 5
    }];
    var functionPlusObject = calling('arg', {
        g: 6,
        h: 7
    });
    // two lines of comment
    // between lines
    var lastLoneWolf;

    var anotherUndefined;
    var functionPlusObject = calling('arg', {
        i: 8,
        j: 9
    });

    // These should remaing unchanged:
    // Comment with var foo = bar; in the middle
    // Comment with var foo = bar, in the middle
    // Comment with var foo = bar;
    // Comment with var foo = bar,

    // This shouldn't change too:
    /* var foo = bar, */
    /* var foo = bar; */

    // This *WILL* be converted:
    /*
       var foo = bar;
       var foo = fu;
    */
}

// TODO
// The following is not supported yet:
var a, b;
var a = 1, b = '', c = 'comma, here', d;
var a = 1, b = 5/3, c = 'comma, here', d;
var a = 1, b = 5/3, c = 'comma, here', d; // with comment after

//////////////////////////////////
// Stuff with line comments after:
//////////////////////////////////

var a = 'comment to follow'; // this is a comment
var b = 2; // no shit, sherlock
var c = { // yow
    k: 10
};
var d; // oh yeah

// Sanity check: just to make sure this won't be touched:
function bogus(arg) {
    if (arg <= 0) {
        return 'foo';
    }

    if (arg === 1) {
        return 'bar';
    }

    return testing();
}


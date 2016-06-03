var ONE = 'one',
    TWO = 2,
    THREE = 'três';

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

function testing() {
    var initialAndUndefined,
        testUndefined,
        assigned = ONE,
        // comment in the middle
        anonymous = function() {
            var foo = TWO,
                bar = THREE;
        },
        object = {
            one: 1,
            two: 2
        },
        // two lines of comment
        // between lines
        lastLoneWolf;

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
       var foo = bar,
           foo = fu;
    */
}

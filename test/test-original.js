var ONE = 'one',
    TWO = 2,
    THREE = 'três';

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
            a: 0,
            b: 1
        },
        arrayWithObjects = [{
            c: 2,
            d: 3
        }, {
            e: 4,
            f: 5
        }],
        functionPlusObject = calling('arg', {
            g: 6,
            h: 7
        }),
        // two lines of comment
        // between lines
        lastLoneWolf;

    var anotherUndefined,
        functionPlusObject = calling('arg', {
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
       var foo = bar,
           foo = fu;
    */
}

/////////////////////////
// Commas inside strings:
/////////////////////////

var a = 1, b = '', c = 'comma, here', d;
var view, spy, testMessage = 'last var with comma, dude';

/////////////////////////////////
// Multi declaration in one line:
/////////////////////////////////

var a, b;
var a = 1, b = '', c = 'comma, here', d;
var a = 1, b = 5/3, c = 'comma, here', d;
var a = 1, b = 5/3, c = 'comma, here', d; // with comment after

//////////////////////////////////
// Stuff with line comments after:
//////////////////////////////////

var a = 'comment to follow', // this is a comment
    b = 2, // no shit, sherlock
    c = { // yow
        k: 10
    },
    d; // oh yeah

////////////////////
// Arguments commas:
////////////////////

var logFile = path.resolve(__dirname, '../tests.log');
var logFile2 = path.resolve(__dirname2, '../tests2.log'),
    test;
var oi,
    combinedSettings = _.extend({}, getValues(), {}, originalSettings);

////////////
// Chaining:
////////////
var views = this.getViews(),
    chainOne = _(views).chain()
        .keysOne()
        .find(function(key) {
            return views[key].isDefault === true;
        })
        .valueOne();

var views = this.getViews(),
    chainTwo = _(views).chain()
        .keysTwo()
        .valueTwo(),
    anotherTwo = 42;

// TODO this is not supported yet:
var views = this.getViews(), chainThree = _(views).chain()
        .keysThree()
        .valueThree(),
    anotherThree = 42;

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


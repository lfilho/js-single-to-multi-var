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

/////////////////////////
// Commas inside strings:
/////////////////////////

var a = 1;
var b = '';
var c = 'comma, here';
var d;
var view;
var spy;
var testMessage = 'last var with comma, dude';

/////////////////////////////////
// Multi declaration in one line:
/////////////////////////////////

var a;
var b;
var a = 1;
var b = '';
var c = 'comma, here';
var d;
var a = 1;
var b = 5/3;
var c = 'comma, here';
var d;
var a = 1;
var b = 5/3;
var c = 'comma, here';
var d; // with comment after

//////////////////////////////////
// Stuff with line comments after:
//////////////////////////////////

var a = 'comment to follow'; // this is a comment
var b = 2; // no shit, sherlock
var c = { // yow
    k: 10
};
var d; // oh yeah

////////////////////
// Arguments commas:
////////////////////

var logFile = path.resolve(__dirname, '../tests.log');
var logFile2 = path.resolve(__dirname2, '../tests2.log');
var test;
var oi;
var combinedSettings = _.extend({}, getValues(), {}, originalSettings);

////////////
// Chaining:
////////////
var views = this.getViews();
var chainOne = _(views).chain()
    .keysOne()
    .find(function(key) {
        return views[key].isDefault === true;
    })
    .valueOne();

var views = this.getViews();
var chainTwo = _(views).chain()
    .keysTwo()
    .valueTwo();
var anotherTwo = 42;

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


# DimDom

[[About](#about) | [Installation](#installation) | [Examples](#examples)]

## About
DimDom is a small javascript library for representing a html DOM structure in a
simple, naive manner.

Use it to define HTML or SVG element trees, along with their attributes and style,
and then add them to existing documents.

DimDom instances are not bound to a document, so they can be created and modified
freely without regard to the document they may ultimately be added to.
No need to pass around Document or Node objects to your functions or classes for
them to create new elements.

When the time comes to add them to your DOM, simply call a DimDom's `create`
method to create a corresponding Node for a given document, or append a new Node
directly to an existing one with the `appendTo` method.

### Advantages over other approaches

Representing new elements as strings of markup makes it difficult to manipulate
those elements, such as modifying attributes or adding/removing children.
In order to do that, you likely would have to create corresponding elements (via
inner/outerHTML, insertAdjacentHTML(), or DocumentFragment) and then manipulate it
using the browser DOM api methods.

Handling elements using the standard DOM api and classes can be a bit verbose and
cumbersome. Also, you usually have to use the document object to create them. This
means you must have knowledge of where your elements will ultimately end up in
order to create and use them.

Other third party libraries provide means to create and manipulate elements, but
they often contain much more that might be overkill for a particular use case.
DimDom has no event handling, no DOM selection, no animation effects, and no ajax
helpers. It doesn't really deal with the standard existing DOM at all. It just
provides an easy way to define new elements.

## Installation

Download the repository and reference the `./dist/dimdom.js` file.

*-OR-*
Via the rawgit cdn at https://cdn.rawgit.com/romancow/dimdom/master/dist/dimdom.js

*-OR-*
Using npm with `npm install romancow/dimdom`

(Sorry, it's not in the npm registry yet.)

## Examples

Create a simple HTML element with some inner text:

    var elem = new DimDom("div", "This is the inner text.");

Create an HTML element with attrbiutes, style, and some inner text:

    var elem = new DimDom("div", {class:"example"}, {color:"SlateGray"}, "This is the inner text.");

Create an HTML element with attributes and children elements:

    var elem = new DimDom("div", {class:"example"}, [
        new DimDom("h1", {id:"interesting"}, "An Interesting Header"),
        new DimDom("p", "This is the inner text.")
    ]);

To specify an element namespace, pass two item array as the first argument to the
constructor. The first item is the namespace, the second shoudl be the element name.
For convenience the standard HTML, SVG, and MathML namespaces can be found at 
`DimDom.NS`:

    var elem = new DimDom([DimDom.NS.SVG, "svg"], {width:500, height:300},
        new DimDom([DimDom.NS.SVG, "circle"], {cx:100, cy:100, r:25})
    );

As a shortcut for creating elements for the preset namespaces:

    var elem = new DimDom.SVG("svg", {width:500, height:300},
        new DimDom.SVG("circle", {cx:100, cy:100, r:25})
    );

To get an actual Node object to insert into a document:

    var elem = new DimDom("div", "This is the inner text.");
    var node = elem.create(document);

    var parent = document.getElementById("container");
    parent.appendChild(node);

Or create and append the corresponding node in one step:

    var parent = document.getElementById("container");
    var elem = new DimDom("div", "This is the inner text.");
    elem.appendTo(parent);

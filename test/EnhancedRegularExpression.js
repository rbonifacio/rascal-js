"use strict";
//------------------------------------------------------------------------------
// Regular Expression Sticky Matching
// Keep the matching position sticky between matches and this way support
//   efficient parsing of arbitrary long input strings, even with an arbitrary
//   number of distinct regular expressions.
// http://es6-features.org/#RegularExpressionStickyMatching
//------------------------------------------------------------------------------

parser("Foo 1 Bar 7 Baz 42", [
    { pattern: /^Foo\s+(\d+)/y, action: console.log("Report rato") },
    { pattern: /^Bar\s+(\d+)/y, action: console.log("Report rato") },
    { pattern: /^Baz\s+(\d+)/y, action: console.log("Report rato") },
    { pattern: /^\s*/y,         action: console.log("Nao")            }
]);
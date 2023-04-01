[![Build status](https://github.com/jordanmontt/RewriteToolsSet/workflows/CI/badge.svg)](https://github.com/pharo-ai/linear-regression/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/jordanmontt/RewriteToolsSet/badge.svg?branch=master)](https://coveralls.io/github/jordanmontt/RewriteToolsSet?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/jordanmontt/RewriteToolsSet/master/LICENSE)
[![Pharo version](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)

# This is Rewrite Tools Set

***
**This repo is no longer maintened. I have migrated the code to [NewTools](https://github.com/pharo-spec/NewTools). The tools are now included in Pharo from Pharo 11 or greater. You can load them from here if you use a lowest Pharo version, Pharo 10 or lower.**
***

RewriteToolsSet is a set of Pharo modular tools that can be used together or separately. This set of tools allow you to do complex code transformations, searches and refactors using the rewrite engine of Pharo! You can create custom code transformation rules and transform the code of a set of classes (or the whole image) with them.

These tools allow you to create, store, load, test, match and apply custom transformations rules and do complex code searches. As well, you can apply the custom transformation rules to a specific set of classes or to the entire Pharo image. You can refactor or replace deprecated methods (or any method) with this tool!

This set of tools includes Yuriy Tymchuk's [MatchTool](https://github.com/Uko/MatchTool). I migrated it to the ner version of [Spec](https://github.com/pharo-spec/Spec).

## Installation

In order to install this tool, perform the following code in a Playground:

```st
Metacello new
    repository: 'github://jordanmontt/RewriteToolsSet/src';
    baseline: 'RewriteToolsSet';
    load
```

## How to open it

When you have downloaded the tool using the above code, it will be added to the Tools menu. You just have to click it.

<img width="317" alt="Capture d’écran 2022-11-06 à 13 56 20" src="https://user-images.githubusercontent.com/33934979/200176692-67979fea-f488-4615-9f9d-8c6ce9765788.png">


# This is RewriteTool

RewriteTool is a set of Pharo's modular tools that can be used together or separately. It allows you to create, store, load, test and match custom Rewrite Rules. It also allows to apply the custom Rewrite Rules to specific classes or to the entire Pharo's system. You can refactor or replace deprecated methods (or any method) with this tool!

RewriteTool was created over the basis of two tools: Mark Rizun's [RewriteTool](http://smalltalkhub.com/#!/~MarkRizun/RewriteTool) and Yuriy Tymchuk's [MatchTool](https://github.com/Uko/MatchTool) that use a deprecated version on the `Spec` library. RewriteTool refactors and enhances those tools in addition to adding more tools and more functionalities. Moreover, RewriteTool is built using the new version of the library `Spec` which is called: `Spec2`.

## Installation

In order to install this tool, you have to run the following script:

    Metacello new
      repository: 'github://jordanmontt/RewriteTool-Spec2';
      baseline: 'RewriteTool';
      load

## UI explanation

RewriteTool consists of three modular tools:
- [RewriteBasicEditor](#rewrite-basic-editor)
- [MatchTool](#match-tool)
- [ExampleBasicRewriteEditor](#example-based-rewrite-editor)

As been said, those modular tools can be perfectly used independtly or in combination.

### Rewrite Basic Editor

### Match Tool

### Example Based Rewrite Editor




If you have any issues or have any feedback, please feel welcome to submit them.

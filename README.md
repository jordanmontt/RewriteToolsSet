# This is Rewrite Tools Set

RewriteToolsSet is a set of Pharo's modular tools that can be used together or separately. This set of tools allow you to do complex code transformations, searches and refactors using the Pharo rewrite engine! You can create custom code transformation rules and transform the code of a set of classes (or the whole image) with them.

This tools allow you to can create, store, load, test, match and apply custom transformations rules and do complex code searches. As well, you can apply the custom transformation rules to a specific set of classes or to the entire Pharo's system. You can refactor or replace deprecated methods (or any method) with this tool!

RewriteToolsSet was created over the basis of two tools: Mark Rizun's [RewriteTool](http://smalltalkhub.com/#!/~MarkRizun/RewriteTool) and Yuriy Tymchuk's [MatchTool](https://github.com/Uko/MatchTool). Those tools use a deprecated version on the `Spec` library. RewriteToolsSet refactors and enhances those tools in addition to adding more tools and a lot of more functionalities. Moreover, RewriteToolsSet is built using the new version of the library `Spec`, `Spec2`.

If you have any issues or have any feedback, please feel welcome to submit them.

You can watch this short video-tutorials of common uses cases of this set of tools!
- https://www.youtube.com/watch?v=M0ElVhUoWXk
- https://www.youtube.com/watch?v=_9v1XTk1J2A
** Note: in those videos the final version of the tool is not used so the UI may change.**
## Installation

In order to install this tool, perform the following code in a Playground:

    Metacello new
      repository: 'github://jordanmontt/RewriteToolsSet/src';
      baseline: 'RewriteToolsSet';
      load


## How to open it

When you downloaded the tool using the above code, it will be added to the Tools menu. You just have to click it and it will open.

![Tools's menu](https://i.imgur.com/jl7MxSD.png)

Another option is to run the following code in a Playground:

`RewriteBasicEditorPresenter open`

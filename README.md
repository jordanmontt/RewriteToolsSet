# This is Rewrite Tools Set

RewriteToolsSet is a set of Pharo's modular tools that can be used together or separately. It allows you to create, store, load, test, match and apply custom Rewrite Rules. You can apply the custom Rewrite Rules to a specific set of classes or to the entire Pharo's system. You can refactor or replace deprecated methods (or any method) with this tool!

RewriteToolsSet was created over the basis of two tools: Mark Rizun's [RewriteTool](http://smalltalkhub.com/#!/~MarkRizun/RewriteTool) and Yuriy Tymchuk's [MatchTool](https://github.com/Uko/MatchTool). Those tools use a deprecated version on the `Spec` library. RewriteToolsSet refactors and enhances those tools in addition to adding more tools and a lot of more functionalities. Moreover, RewriteToolsSet is built using the new version of the library `Spec` which is called: `Spec2`.

If you have any issues or have any feedback, please feel welcome to submit them.

## Installation

In order to install this tool, perform the following code in a Playground:

    Metacello new
      repository: 'github://jordanmontt/RewriteToolsSet';
      baseline: 'RewriteToolsSet';
      load


## How to open it

When you downloaded the tool using the above code, it will be added to the Tools menu. You just have to click it and it will open.

![Tools menu](https://i.imgur.com/4LVxfd9.png)

Another option is to run the following code in a Playground:

`RewriteBasicEditorPresenter open`

## UI explanation

RewriteTool consists of seven modular tools:
- [Rewrite Basic Editor](#rewrite-basic-editor)
- [Example Based Rewrite Editor](#example-based-rewrite-editor)
- [Match Tool](#match-tool)
- [Rewrite Rule Applier](#rewrite-rule-applier)
- [Rewrite Rule Loader](#rewrite-rule-loader)
- [Rewrite Changes Browser](#rewrite-changes-browser)
- [Rewrite Helper Browser](#rewrite-helper-browser)

As been said, these modular tools can be perfectly used independently or in combination.

### Rewrite Basic Editor

![Rewrite Basic Editor UI](https://i.imgur.com/VgugEwf.png)

This is the principal tool that conects all the other ones. It loads with a defafult Rewrite Rule. It has a basic cheat sheet for the Rewrite Rules syntax. If you want a deeper explanation, you can open the Rewrite Helper Browser.
- Press the _More Help_ button to open the helper browser which contains an explanation of the Rewrite Rules syntax.
- Press the _Match Tool_ button to open Match Tool.
- Press the _Apply rule_ button to apply the current rule to all classes in the Pharo´s system.
- Press the _Open Applier_ button to open the Rewrite Applier.
- Press the _Save rule_ button to save the current rule.
- Press the _Load rule_ button to open the loader which allows you to load any rule that you have previously saved.

### Example Based Rewrite Editor

To write

### Match Tool

![Match Tool](https://i.imgur.com/ZfFO6kT.png)

This is a tool that allows you to match and test a Rewrite Rule. You press the _Match_ button and it will match the rule with the Pharo's code. The middle column shows all the occurrences of the rule in the Pharo's code. The right column shows all the bindings of the selected matched of the middle column.

### Rewrite Rule Applier

![Rewrite Rule Applier](https://i.imgur.com/Kr6ckLt.png)

This is a tool that allows you to apply any custom rule to any class or classes. In the first column on the left you can select one or several packages. The middle column will be populated with the classes of the packages that you have selected. Then, you can select one or more classes, those classes will be the ones that will be refactored by the rule. The methods column will be populated with the methods of those classes but cannot be selected. The rule can only be applied to classes, not to specific methods.

In the bottom left corner, there is a dropdown menu with all the saved rules, that is the rule that will be applied to the selected classes. You can apply that rule either to all system classes or only to the selected ones. If you press the _Edit Rule_ button the Rewrite Basic Editor will be opened with the selected rule.

### Rewrite Rule Loader

This is a simple tool that shows a list of all the custom Rewrite Rules saved. You can either choose to load a rule in the Basic Rewrite Editor or to delete the rule.

### Rewrite Changes Browser

Before the rule is applied to one or many classes, the Changes Browser will open. This is a tool that shows all the changes that will be made and how the methods will be changed.

### Rewrite Helper Browser

This is a Helper Browser which contains an explanation of how to create Rewrite Rules and how the Rewrite Rules's syntax work.

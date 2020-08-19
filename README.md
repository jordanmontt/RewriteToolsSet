# This is RewriteTool Spec2

RewriteTool is a tool that allows you to create, store, load, test and match custom Rewrite Rules. It was created over the basis of two tools: Mark Rizun's [RewriteTool](http://smalltalkhub.com/#!/~MarkRizun/RewriteTool) and Yuriy Tymchuk's [MatchTool](https://github.com/Uko/MatchTool). Those tools were built using the `Spec` library which now is deprecated and not work in the latest versions of Pharo.

This tool combines the two previous ones but also enhances them and adds more functionalities. Also, this tool is built using the new library `Spec2`.

Installation
------------
In order to install this tool, you have to run the following script:

    Metacello new
      repository: 'github://jordanmontt/RewriteTool-Spec2';
      baseline: 'RewriteTool';
      load

If you have any issues or have any feedback, please feel welcome to submit them.
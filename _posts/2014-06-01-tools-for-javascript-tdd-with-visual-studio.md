---
layout: post
title: Tools for javascript TDD with Visual Studio
date: '2014-06-01 20:56:38 +0000'
date_gmt: '2014-06-01 18:56:38 +0000'
categories:
- Programming
- UnitTesting
- DevTools
tags:
- chutzpah
- jasmine
- javascript
- MSTest
- powershell
- Unit Testing
- visual studio
---
In this post I describe the tools that I have selected for efficient development of javascript tests within Visual Studio. Indeed, if you are developing sites with ASP.NET or <a href="http://msdn.microsoft.com/en-us/office/dn448457.aspx">Apps for Office</a> then you are more or less committed to use Visual Studio. Therefore, you probably do not want to use another editor for your javascript development.

What were my requirements when I chose the tools that I will describe to you in this post? Actually, I needed tools which can&nbsp;provide&nbsp;me&nbsp;the same comfort that I have while I am developing in&nbsp;TDD with&nbsp;.NET. Precisely, the test should be run individually (or at least individually for a given set). They should be run on the continuous integration build, which is <a href="http://www.jetbrains.com/teamcity/">teamcity</a> in my case. The test runner may use any browser for executing the tests even if flexibility for using all kind of browsers would be appreciated. In addition, the test should be easily debugged and this is a very important aspect for me.

Let me detail a little this latter requirement.&nbsp;Indeed, I have read recently <a title="here" href="https://chrisseroka.wordpress.com/2013/07/07/unit-testing-javascript-in-visualstudio-with-resharper/">this blog post</a> and its written that

<blockquote>Debugging the tests<br />
Wiseman said: &ldquo;If you need to debug unit test then something is wrong with it&rsquo;s unitness.&rdquo;<br />
PS: If it&rsquo;s really needed you can debug it in browser as you normally debug JavaScript code.
</blockquote>
While if the rest of the blog is brilliant, *I do not subscribe at all to this sentence*. &nbsp;If you practice regularly&nbsp;TDD then you'll see that you have to debug, that's part of the game. If you never have to debug maybe it's because you are asserting too much trivialities and not enough your own complex logic. In addition, if you have to create the webpage on your own, for debugging, that is not acceptable to me either. You should be able to put your breakpoint anywhere in your code and hit it in less than five seconds. We will see that the tool chosen permits such quick debugging and that's the main reason why I am using it.

At the time of the writing, the popular Visual Studio Addin <a href="http://www.jetbrains.com/resharper/">Resharper</a> with its version 8 supports javascript tests with the frameworks Jasmine or QUnit. Unfortunately, the debugger cannot be properly attached while debugging the scripts. Sadly, I had to reject Resharper that I appreciate so much for .NET development.

Finally, the best tool that I found is <a title="Chutzpah" href="http://chutzpah.codeplex.com/">Chutzpah</a> (which means Audacity in Yeddish). Firstly, there is the Chutzpah runner which is a javascript test runner that uses the headless browser <a href="http://phantomjs.org/">phantomJs</a>, we will invoke it from the command line in the continuous build. Sedondly, there is the <a href="http://visualstudiogallery.msdn.microsoft.com/71a4e9bd-f660-448f-bd92-f5a65d39b7f0">Chutzpah Visual Studio extension</a> which enables quick runs and debugging sessions from Visual Studio. Both runner and Visual Studio extension is fully compatible with JS test framework <a href="http://jasmine.github.io/2.0/introduction.html">Jasmine 2.0</a>. that I have chosen. Note that I also use the mocking library <a href="http://sinonjs.org/">sinonJs</a> but I won't discuss it there.

You may retrieve the code samples below on my <a title="github repository" href="https://github.com/bpatra/chutzpahSample">github repository</a>.

To illustrate these tools we will use a very simple mockup project and we start its description with the following VisualStudio solution.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/vssolution.jpg' caption="The Visual Studio solution describing the example of this post." %}

As usual there are two projects: <em>WebApplication1</em>, the core project, containing the app folder with our javascript logic, especially the one that we would like to test: <em>sut.js</em> (for SystemUnderTest). There is also the test project, <em>WebApplication1.Tests</em>. The file testing the logic contained in <em>sut.js</em> is simply <em>sutTests.js</em>. The testing framework Jasmine is added to the solution by referencing the folder <em>lib/jasmine-2.0.0.</em>.

We will take a very simple example, where the object <em>app.sut</em> has a function for computing the factorial of an integer. The code of <em>sut.js</em> can be found in the following snippet.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/05730033f7a92e261ef0.js' %}

(Note that in app we have implemented a basic namespacing function such as <a href="http://elegantcode.com/2011/01/26/basic-javascript-part-8-namespaces/">this one</a>)

Let us now focus on the test suite in the <em>sutTests.js</em> code.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/7a5e6f769a0ce3c03beb.js' %}

This piece of code is very basic Jasmine syntax for a test suite. We assert the values of the factorial function for the two corner cases where the input is 0 and 1 and we also test the situation with n=5. Remark also that we have a test which asserts that an exception is thrown when a non positive value is passed to the function. We have not covered this situation with the snippet above, consequently, we expect this test to fail... Remark that all the needed references to js files are handled with <em>///<reference</em> of Visual Studio. By the way, we benefit from Visual Studio Intellisense here.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/intellisense.jpg' caption="The javascript Intellisense with Visual Studio" %}

In the next screen shot, we run the&nbsp;tests with the Visual Studio Test Explorer&nbsp;that is compatible with Jasmine thanks to Chutzpah.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/runallonefailure.jpg' caption="Run all our test with the Visual Studio test explorer. As expected we encounter a failure." %}


If we were in the situation where we do not know what is going wrong (which is often the case) we would need to debug the test. Unfortunately, like Resharper, you cannot debug the test directly in VisualStudio, the debugger does not attach well. Even Chutzpah creator does not know <em>how <a href="http://stackoverflow.com/questions/12561362/how-do-i-debug-my-javascript-that-is-being-executed-by-chutzpah-phantomjs">we would do that</a>,</em> so I believe we will have to wait to debug javascript test as easily as we debug .NET within visual studio. Then, we will have to debug with a web browser. However, Chutzpah creates the webpage for bootstrapping your failing test. So just by clicking in Open in browser you will have the web page loaded and a link to run the failing test within the browser (see screenshots below).


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/openinbrowser.jpg' caption="Chutzpah Visual Studio extension creates web page for running/debugging tests in the web browser." %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/debuginbrowser.jpg' caption="Then the debugging sessions happens in your browser (here Chrome). Clicking again the links reexecute the tests." %}

Now, we do have all the material for editing efficiently tests in Visual Studio. Let us have a few words for running the test using the command line on the server. Personally, I embed the Chutzaph runner in a&nbsp;<em>/build</em> directory within my sources and executes the following Powershell script.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/8563101beef94bdfacaa.js' %}

Here is what it looks when ran it an Powershell console with teamcity options.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/05/chutzpahposh.jpg' caption="The execution of all javascript tests of the solution with Chutzpah runner using Powershell" %}

To conclude, I would say that Chutzpah is a great project and if you need a simple and ready to use test runner I would recommend it. The only limitation for now &nbsp;would be that the runner only supports phantomJS. However, you may use another another test runner for executing the tests with different browser and&nbsp;you can keep the Chutzpah Visual Studio extension for the development. One last important thing to note is the fact that Chutzpah 3.0 supports <a href="http://requirejs.org/">RequireJs</a>.


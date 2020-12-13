---
layout: post
status: publish
published: true
title: Executing PSake build script with Teamcity
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 331
wordpress_url: http://benoitpatra.com/?p=331
date: '2014-07-08 23:16:27 +0000'
date_gmt: '2014-07-08 21:16:27 +0000'
categories:
- Programming
- Scripting
tags:
- build
- C#
- msbuild
- powershell
- psake
- software versioning
- teamcity
---
For my build tasks I have been using MSBuild for a while. I found out that it is fine to use it for standard build tasks such as invoking msbuild.exe itself. However, when it comes to really custom actions it is really painful. I did not want to struggle any longer with xml config files and would like to stay as close as possible to a simple procedural programming language. Most of all I was fed up by the quoting issues when invoking external executables. When writing such actions I wanted to stick to a shell scripting language that I already know. Still, basic scripting can be a little bit improved when it comes to build process. To be precise, the notion of task (or target) is extremely handy because you can split a build step in sub tasks that you may combine differently depending on the build config. While it looks like overkill for a small project it will ease your life in large projects where packaging can be complex.

The tool that I will present in this post is called <a href="https://github.com/psake/psake">PSake</a> (pronounce sak&eacute; like the asian alcohol) and is described by the <a href="http://en.wikipedia.org/wiki/Psake">Wikipedia</a> as

>a domain-specific language and build automation tool written in PowerShell to create builds using a dependency pattern similar to Rake or MSBuild.

This was all I needed: a build tool in Powershell.

Even if I will not cover this in the present post, one of the main benefit of using Powershell for build scripts is the possibility to use directly Powershell extensions such as <a href="http://msdn.microsoft.com/en-us/library/azure/jj554330.aspx">Azure</a> or <a href="http://technet.microsoft.com/en-us/library/ff678226(v=office.15).aspx">Sharepoint</a> Cmdlets. Even if you do not need it right now, they may become extremely useful in the future of your Windows based software project.

In this post I will describe how to use PSake for a very simple build task: patching the <em>AssemblyInfo.cs</em> file for a visual studio .NET solution. I will also show you the organization of the targets that I have chosen.

Let us recall that the version of the .NET assembly produced by the compilation of your C# project uses the <em>AssemblyInfo.cs</em> file that you can find under the <em>/Properties</em> folder. The lines that are automatically generated in the <em>AssemblyInfo.cs</em> file regarding the assembly version are<br />
<code><br />
[assembly: AssemblyVersion("1.0.0.0")]<br />
[assembly: AssemblyFileVersion("1.0.0.0")]<br />
</code><br />

Consequently, the task has to patch the <em>AssemblyVersion</em> so that it contains <em>major.minor</em> while the AssemblyFileVersion will be <em>major.minor.build</em>. Once the task will be finished all <em>AssemblyInfo.cs</em> in the code source repository will be patched similarly, for example with <code>[assembly: AssemblyVersion("6.3")]</code> and <code>[assembly: AssemblyFileVersion("6.3.567")]</code>. If you are not familiar with product versioning you may read the <a href="http://en.wikipedia.org/wiki/Software_versioning">wikipedia page</a>. Here we chose a <em>major.minor.build </em> sequence where the major and minor numbers are fully handled by the owner of the project. However, the <em>.build</em> number is provided by the continuous integration system which will be <a href="http://www.jetbrains.com/teamcity/">Teamcity</a> in our case. Similarly to food industry where, given the number of a ready-made meal you are supposed to be able to track back where the beasts came from, in software, you should be able from the product version to track back the source of your product and its external dependencies. This is why both source code and build history are precious and why the Teamcity database should also be backed up.

The task presented here may not the best advocate for PSake over MSBuild XML configs because using the <FileUpdate> command performs the same kind of patch easily. In addition the <a href="https://msbuildextensionpack.codeplex.com/">MSbuildExtensionPack</a> has a built in AssemblyInfo task for this purpose. But, if you are a .NET developer I am pretty sure you will be at ease, then think as an illustration for PSake.

Here is the source code for the task.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/c1c560c1be6ee52a47a9.js' %}

The outer braces: <code>task PathAssemblyInfo</code> defines the scope of the target. The command does not depend from where the script is run because we use the <a href="http://powershell.com/cs/blogs/tips/archive/2014/02/20/use-psscriptroot-to-load-resources.aspx">$PSScriptRoot</a> variable (available since Powershell 3.0). It basically looks for all AssemblyInfo files in the solution directory and patch them with the appropriate version numbers. The detailed implementation of the functions <em>GetAssemblyVersion</em>, <em>GetAssemblyFileVersion</em> and <em>PatchFile</em> can be found <a href="https://gist.github.com/bpatra/1ae1aac8c9b9508844ab">here</a>.

Now let us look on how to combine and invoke the PSake targets from Teamcity. I have a <em>/build</em> directory at the root of the repository which looks like

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/07/directorystructure.jpg' caption="The organisation of build target with PSake" %}

The PSake project is located under the <em>/build</em> folder. In the <em>/targets</em> directory we put all targets where one target equals one file with the same name. The <em>bootstrapTargets.ps1</em> loads all build targets that are put in the subdirectory with the same name. In <em>bootstrapTargets.ps1</em> I also put the high level targets, the one that will be called by the Continous Integration. Here, I have defined a high level target <em>Example</em> that executes first our <em>PatchAssemblyInfo</em> then another target that I have called <em>RenameMSI</em> (only for the example). You can also put in <em>bootstrapTargets.ps1</em> some functions that will be reused by the different targets.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/8789c64c7bf36308acf3.js' %}

Now see how to invoke the PSake Example task within Teamcity. Create a Powershell using at least the 3.0 version.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/07/psakeexample-e1450469198529.jpg' caption="Invoke the Example PSake task within TeamCity" %}

The script in the Teamcity editor (and only this one) assumes the current directory is the repository root. The first line imports the module while second one invoke the <em>Example</em> task using PSake. The third line below is important so that exceptions thrown in the script appear as build failures.<br />
<code>if ($psake.build_success -eq $false) { exit 1 } else { exit 0 }</code>

To conclude, I would say that PSake is good alternative to those who know Powershell and want to use less XML for their builds.


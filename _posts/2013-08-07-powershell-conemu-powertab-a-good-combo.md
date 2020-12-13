---
layout: post
title: 'Powershell + ConEmu + PowerTab: a good combo'
date: '2013-08-07 20:38:19 +0000'
categories:
- Programming
- Scripting
- DevTools
tags:
- Command-line interface
- ConEmu
- ISE
- powershell
- PowerTab
- Windows PowerShell
---
<strong>Edit: this post was written before the release of <a href="https://github.com/lzybkr/PSReadLine">PSReadLine</a> which seems to be a more reasonable choice than <a href="https://powertab.codeplex.com/">PowerTab</a> for powershell.exe enhancement (completion, intellisense etc.). Indeed, this latter project looks like&nbsp;to be dead now and does not seem to be as rich as the former one. Regarding the rest of the post below, I encourage you to use Conemu console which is still far better than the usual CommandPrompt (this may change with&nbsp;the&nbsp;release of Win10). In addition,&nbsp;you may skip the "Aliasing part" because command in PATH are well recognized by PSReadLine which was not the case for PowerTab. You will discover also a lot of interesting features proposed by PsReadLine such as syntax coloring, custom key bindings....</strong>

<span style="line-height:1.714285714;font-size:1rem;">Microsoft has released in 2006 Powershell (PoSh), a brilliant shell based on the .NET framework. However, the console (or terminal) stays really close to the usual windows command prompt. It is commonly admitted that this console suffers a lot of drawbacks which makes it painful for a everyday usage, see for example these blogs (<a title="artlogic" href="http://blog.artlogic.com/2013/06/28/making-the-windows-command-prompt-suck-slightly-less/">artlogic</a>&nbsp;, <a title="hanselman" href="http://http://www.hanselman.com/blog/MakingABetterSomewhatPrettierButDefinitelyMoreFunctionalWindowsCommandLine.aspx">hanselman</a>, etc.). Just to make things clear, let us recall the difference between a shell and a console. The former is the command interpreter, it is performing the hard work while the latter is just the window, i.e. the program in charge of prompting and displaying information.</span>


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/08/conemu.jpg' caption="ConEmu with PowerTab tabbing" position_class="image-right" %}


In this post I will show you how to configure C<a title="conemu" href="https://code.google.com/p/conemu-maximus5/">onEmu</a>&nbsp;an opensource console emulator to work with Powershell and to benefit from a well designed tab completion with <a title="PowerTab" href="http://powertab.codeplex.com/">PowerTab</a>.

We will only refer to the latest version of Powershell, the 3.0 released in 2012. Let us mention that Powershell 3.0 came with a new version of Powershel ISE, the PoSh scripting environment. In this third version, ISE has&nbsp;<a title="intellisense" href="http://blogs.msdn.com/b/powershell/archive/2012/06/13/intellisense-in-windows-powershell-ise-3-0.aspx">Intellisense</a> which is a great feature, especially when you are discovering PoSh. Unfortunately, ISE console does not support tabbing and suffers the same drawbacks has the original windows command prompt. In addition, ISE is perfectly suited when you are writing some script but is not really adapted to perform every day tasks. In one word ISE more an IDE than a console. In order to have a substitute to Intellisense in ConEmu we will use the PowerTab project.

You may start right now by&nbsp;checking that you have Powershell 3.0 installed (how to <a title="check version" href="http://stackoverflow.com/questions/1825585/how-to-determine-what-version-of-powershell-is-installed">check version</a>). Right after, you may start downloading C<a title="conemu" href="https://code.google.com/p/conemu-maximus5/">onEmu</a>.

If you are an intensive Powershell user, you would want ConEmu to start directly with a new PoSh session. Nothing is more simple, just add the following .txt file somewhere in your disk (e.g. next to ConEmu .exe file).

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6158561.js' %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/08/shortcutprop.jpg' caption="Target in properties of the desktop/taskbar shortcut" position_class="image-right"%}

Next, create a shortcut in task bar or desktop, right click on it on go to the properties of &nbsp;the&nbsp;link. You may enter the following command in the target&nbsp;property:<em>&nbsp;
&lt;pathToConemu&gt;conemu.exe /cmd @
&lt;pathtoyourfile&gt;/startfile.txt</em>

So now you would have a nice console which starts automatically with Powershell. Let us go a little bit further by importing PowerTab in ConEmu. Visit <a title="PowerTab home page" href="http://powertab.codeplex.com/">PowerTab</a> website and download the sources rather than the packaged version. Indeed, many fixes are present in the source code but not packaged in the .zip. At the time of the writing I use version of commit&nbsp;035310b4c93e, Follow the instruction for installing Powertab. Quickly it is: unzipping source under &lt;YourHomePath&gt;/WindowsPowerShell/Modules/PowerTab and execute command&nbsp;<em>Import-Module PowerTab.</em>


While importing PowerTab module, it will ask you if you want to import PowerTab on start. This config will be saved by updating your $PROFILE. If your not familiar with PoSh profiles now, I suggest you to read <a title="this" href="http://technet.microsoft.com/en-us/library/ee692764.aspx">this</a>. To sum up the $PROFILE is a special PoSh script executed each time your entering a new Powershell session (then each time you are starting ConEmu if you have done what is above). This is where you would put some custom scripts and any in-house configuration. NB: under commit&nbsp;035310b4c93e, the function of your $PROFILE are recognized by PowerTab which does not seemed to be the case on the packaged version&nbsp;PowerTab 0.99.6.

Now we do have a console with efficient tabbing. The style is much more old school&nbsp;than the ISE intellisense but it does the job well and is quite pleasant to use.

I am not done yet, actually, our version of PowerTab does not see the .exe in you PATH environment variable for tabbing. This is quite frustrating not to have auto-complete for <em>vim</em>, <em>notepad++</em>, <em>tracecrt.exe</em> etc. This may be included in incoming version (I will see what I can do...) but here is workaround. As long as PowerTab recognizes Powershell command aliases, we are going to build an alias dictionary that includes the aforementioned .exe located in the PATH environment variable.

The following snippet shows a part of your $PROFILE where the aliases are imported just before the module PowerTab. They are imported from a file <em>alias.txt</em> which is located next to the $PROFILE .ps1 file. You create this <em>alias.txt</em> file by invoking the function<em> Export-AliasWithEXEInPATH</em>. You have to call this function at least once and to keep your aliases up-to-date you should run it when you modify the PATH variable. Remark the lightweight PoSh syntax for the .NET hashtable: <em>@{}</em>...

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6159032.js' %}

Even if it will probably be outdated soon, this is my configuration at home and at work for now and I am quite pleased of it.


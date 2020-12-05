---
layout: post
status: publish
published: true
title: A sample Wix installer using the ActiveSetup feature
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2014-07-26 00:15:02 +0000'
date_gmt: '2014-07-25 22:15:02 +0000'
categories:
- Uncategorized
- Programming
- Windows
tags:
- ".NET"
- activesetup
- Addin
- Excel
- Excel-DNA
- install
- msi
- windows registry
- wix
comments:
- id: 21842
  author: Maulik
  author_email: maulikchandya@gmail.com
  author_url: ''
  date: '2017-04-12 10:24:37 +0000'
  date_gmt: '2017-04-12 10:24:37 +0000'
  content: "Hi, thank you for this sample, I used it to install Excel Add In. But
    I am facing one issue when I re-install using new MSI. This is what I did,\r\n\r\n1.
    Create MSI and install it using it. Worked fine and add in was automatically loaded
    in Excel.\r\n2. Re-create MSI and install using it but this time select different
    target path. It did uninstalled previous version and did install new one under
    different target path. But OPEN key value for add in was still pointing to previous
    location and so when I opened Excel, I got error that Add in not found."
- id: 21844
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2017-04-12 11:26:45 +0000'
  date_gmt: '2017-04-12 11:26:45 +0000'
  content: |-
    Hi Maulik,
    unfortunately I do not develop VSTO product anymore. I did not touch Wix code for two years. I will transfer your question to former colleagues of mine see if they can be of any help.

    Best regards
    Benoit
- id: 25573
  author: Zhenyu
  author_email: chris.zhenyu.chen@gmail.com
  author_url: ''
  date: '2017-12-05 15:53:12 +0000'
  date_gmt: '2017-12-05 15:53:12 +0000'
  content: "Hi,\r\n\r\nMy users report a common issues. \"Setup wizard ended prematurely
    because of an error\".\r\n\r\nDo you know what cause this issue?\r\n\r\nThanks,\r\nZhenyu"
- id: 25574
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2017-12-05 16:09:07 +0000'
  date_gmt: '2017-12-05 16:09:07 +0000'
  content: |-
    Hi, I do not know. You should try to install the msi using command line verbose mode to know more.
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa372024(v=vs.85).aspx
- id: 26687
  author: ASB
  author_email: acessdenied2000@gmail.com
  author_url: http://www.
  date: '2018-02-16 06:16:54 +0000'
  date_gmt: '2018-02-16 06:16:54 +0000'
  content: how on earth did u create the installer, its a pathetic article, could
    any one write steps on how to make this work?
- id: 26688
  author: ASB
  author_email: acessdenied2000@gmail.com
  author_url: ''
  date: '2018-02-16 06:17:20 +0000'
  date_gmt: '2018-02-16 06:17:20 +0000'
  content: Pathetic article
- id: 26689
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2018-02-16 07:00:21 +0000'
  date_gmt: '2018-02-16 07:00:21 +0000'
  content: |-
    If you read the article you will notice that the full source code is available on github.
    Pathetic author for pathetic readers.
- id: 54230
  author: Abhishek Kr
  author_email: abhishekbhaskar35@gmail.com
  author_url: ''
  date: '2019-10-04 06:49:14 +0000'
  date_gmt: '2019-10-04 06:49:14 +0000'
  content: Same issue .Don't know what's wrong.
---

{% include image-align-right.html imageurl='/assets/images/legacy-wp-content/2014/07/pedroslokoouedec1.jpg' title="F#-ception!" caption="All users have the software in the case of a local machine install contrary to user install" %}

In this post I will explain the technical details of the <a href="https://github.com/bpatra/ExcelDNAWixInstallerLM">Wix sample installer for local machine</a> install of <a href="https://exceldna.codeplex.com/">Excel-DNA addins</a>. <a href="http://wixtoolset.org/">Wix</a> is a popular free toolset to create .msi installer. I used the ActiveSetup feature to address a "per user" install problem and this is the part I will cover in this post. Therefore, it maybe useful for both who do not know ActiveSetup at all and for people looking out to write their own Wix installer leveraging the ActiveSetup. Even, if I think ActiveSetup should be used only if there is no alternative this barely known feature may save your life so it is good to be aware of its existence. We will use the terminology of the Windows Registry that you can check on the<a href="http://en.wikipedia.org/wiki/Windows_Registry"> Wikipedia page</a>.

First let us present the problem and why we needed this ActiveSetup feature. Automation addins and by consequent Excel-DNA ones are registered by setting a value OPEN in the current user registry hive (HKCU). This OPEN value contains the path to the packaged Excel addin which a file with .xll extension. If there are two addins to register then the values should be named OPEN, OPEN2, OPEN3... see this StackOverflow <a href="http://stackoverflow.com/questions/18602560/how-to-deploy-an-excel-xll-add-in-and-automatically-register-the-add-in-in-excel">discussion</a> or this <a href="http://support.microsoft.com/kb/291392">MS documentation</a>. This is a per user registration, if you create a new user, then he will not have the addin starting with Excel. There is a WixSample available on the <a href="https://github.com/Excel-DNA/WiXInstaller">Excel-DNA github</a>. This is fine as long as you need only a per user install, however, for enterprise deployment you need most of the time a local machine install. Here starts the troubles: the OPEN value mentioned above cannot be set as a HKLM (machine) subkey only in the current user hive (HKCU). Therefore we have to find a way to setup this OPEN value for all users and this is where the the ActiveSetup comes into play. We have also tried to set the addin in the <em>XLSTART</em> machine directory but this has also drawbacks <a href="https://exceldna.codeplex.com/discussions/550941">see this discussion</a>

So what is this ActiveSetup feature? ActiveSetup is a simple yet powerful mechanism built-in in Windows that allows you to execute a custom action at logon for new user. How does it work? Actually this is quite simple. You have to create a subkey in the HKLM hive <em>Software/Microsoft/ActiveSetup/Installed Components</em>. Typically this subkey is a GUID that contains a <em>StubPath REG_EXPAND_SZ</em> value whose data points to the executable of your choice. This value is mirrored in the HKCU registry. Precisely, at logon windows checks if you have this ActiveSetup key in the current user HKCU hive, and if not, the executable of the <em>StubPath</em> is invoked. If the key is present in the HKCU registry then nothing happens. The nice thing is that localization, version and uninstall are handled. Let us detail the uninstall mechanism. Actually, if you need to remove your feature, then you can set the <em>IsInstalled</em> feature to 0 and change the <em>StubPath</em> so that the command there executes a cleaning task of your choice. At logon if the HKCU subkey of active setup was registered previously then the command in the <em>StubPath</em> will be executed. The versioning allows you to reexecute the ActiveSetup command even if the ActiveSetup has already been executed by the user i.e. if the HKLM ActiveSetup key is already mirrored in the HKCU hive. ActiveSetup is poorly (read not) documented but you may find information on the web for example <a href="http://helgeklein.com/blog/2010/04/active-setup-explained/">in this good article</a>.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/07/activesetup-1024x234.jpg' title="ActiveSetup set in the HKLM registry for the Wix sample installer" caption="ActiveSetup set in the HKLM registry for the Wix sample installer" %}

Ok now, how we will use this for our Wix Install? In addition to the common HKLM registration, our <a href="https://github.com/bpatra/ExcelDNAWixInstallerLM">sample</a> builds a .NET40 executable binary called <em>managedOpenKey.exe</em>. This .exe, when invoked with /install parameter, looks at the HKCU hive and creates the OPEN subkey mentioned in the second paragraph, so that the addin will be opened when starting Excel. When the .exe is invoked with /uninstall it will remove the OPEN value, if present, in the HKCU. This is simple: at install/ repair/upgrade our Wix creates the ActiveSetup HKLM key with a <em>StubPath</em> of the form <em>"manageOpenKey.exe /install "</em>. For uninstall, we set the IsInstalled value to zero and change the StubPath to "manageOpenKey.exe /uninstall". To do so we use some<a href="http://blogs.msdn.com/b/jschaffe/archive/2012/10/23/creating-wix-custom-actions-in-c-and-passing-parameters.aspx"> custom actions written in .NET40 </a>of the Wix installer, they must be invoked without impersonation so that we are allowed to write in HKLM.

We wished to allow the usage of the addin without a reboot. Therefore, at install/repair/upgrade the msi quietly invokes the same <em>manageOpenKey.exe</em> so that, for the current user performing the install we do not need the reboot and wait for the active setup to create the <em>HKCU OPEN</em> value. But there is a trick.... We must force the mirroring of the ActiveSetup key in the HKCU registry. Indeed, take the following example: user 1 installs the addin; the <em>OPEN key</em> is registered because we have invoked the .exe directly in the .msi. Now user1 logs off and user2 logs on, ActiveSetup is triggered for him and the addin is registered and everyone is happy. But now user2 decides to uninstall the addins and does so. The user1 when he logs back and opens Excel will have an error message saying that the addin is not found. What happened? The HKCU key for ActiveSetup was not mirrored in the user1 HKCU therefore ActiveSetup does not consider that the feature was installed for him then it does not trigger the StubPath command for cleaning environment when the IsInstalled has been set to false. Tricky, isn't it? These manual creation of HKCU key are made by C# custom actions that should be impersonated because you want to write your key in the HKCU of the user who made the install not the LocalAdministrator that runs the custom action not impersonated such as those mentioned in previous paragraph.

There is also a trick regarding the OS bitness. If you do not take care and write the ActiveSetup in the HKLM hive within a 32bit process on a 64bit OS then your active setup will be written under <em>/Wow6432</em> path. However, when performing the HKCU mirroring mentioned above the .NET API will write in <em>HKCU/Software/Microsoft/Active Setup</em> because it is not supposed to have a Wow6432 key in HKCU. However, there is Wow6432 HKCU key used only by ActiveSetup and you should be cautious. Indeed, the ActiveSetup in /Wow6432 and the one directly under HKLM/Software/Microsoft do not interact. Therefore, in our Wix CustomActions we have to check OS bitness and write the HKLM part in the proper slot with the following code snippet.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/bd641ee939f2c70ed3d9.js' %}

To conclude, I would like to thank my colleague S&eacute;bastien Cadorel who helped me a lot to write down this install sample. If you encounter any troubles with this install sample feel free to submit a bug or to pull request on the <a href="https://github.com/bpatra/ExcelDNAWixInstallerLM">github.</a>


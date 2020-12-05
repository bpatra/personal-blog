---
layout: post
status: publish
published: true
title: Remote debugging Python with VSCode
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 2052
wordpress_url: http://benoitpatra.com/?p=2052
date: '2017-11-27 21:50:29 +0000'
date_gmt: '2017-11-27 21:50:29 +0000'
categories:
- Programming
- DevTools
tags:
- azure
- python
- vscode
- debugging
- networking
comments:
- id: 29018
  author: Debugging Python in VFX applications &#8211; Couple of ideas about Pipeline,
    CG &amp; FX
  author_email: ''
  author_url: https://jurajtomori.wordpress.com/2018/06/13/debugging-python-in-vfx-applications/
  date: '2018-06-13 16:06:00 +0000'
  date_gmt: '2018-06-13 16:06:00 +0000'
  content: "[&#8230;] https://benoitpatra.com/2017/11/27/remote-debugging-python-with-vscode/
    [&#8230;]"
- id: 55507
  author: stuard
  author_email: stuard.ogrady@gmx.net
  author_url: ''
  date: '2019-11-14 15:56:00 +0000'
  date_gmt: '2019-11-14 15:56:00 +0000'
  content: "Hi,\r\n\r\nI tried following the Debugging Python in VFX applications
    blog, but cloud not get the my VsCode debugger to attach at all.\r\n\r\nI tried
    to attach to a programs python process (Houdini) as described on the blog \r\nhttps://jurajtomori.wordpress.com/2018/06/13/debugging-python-in-vfx-applications/\r\n(using
    ptvsd version 3.0.0)\r\n\r\nAlso tried to attach to my own python process as documented
    in the README here:\r\nhttps://github.com/microsoft/ptvsd\r\nI get a \"Failed
    to attach (connect ECONNREFUSED 127.0.0.\" error\r\n(using ptvsd version 4.3.2)\r\n\r\nAny
    idea where I could go wrong ? \r\n\r\n```\r\n{\r\n    // Use IntelliSense to learn
    about possible attributes.\r\n    // Hover to view descriptions of existing attributes.\r\n
    \   // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387\r\n
    \   \"version\": \"0.2.0\",\r\n    \"configurations\": [\r\n        {\r\n            \"name\":
    \"Python: Remote Attach\",\r\n            \"type\": \"python\",\r\n            \"request\":
    \"attach\",\r\n            \"port\": 3000,\r\n            \"host\": \"localhost\",\r\n
    \           \"pathMappings\": [\r\n                {\r\n                    \"localRoot\":
    \"C:\\\\Users\\\\%USERNAME%\\\\Desktop\\\\vfx_py_debugging_examples\",\r\n                    \"remoteRoot\":
    \"C:\\\\Users\\\\%USERNAME%\\\\Desktop\\\\vfx_py_debugging_examples\"\r\n                }\r\n
    \           ]\r\n        },\r\n        {\r\n            \"name\": \"Python: Attach\",\r\n
    \           \"type\": \"python\",\r\n            \"request\": \"attach\",\r\n
    \           \"localRoot\": \"C:\\\\Users\\\\%USERNAME%\\\\Desktop\\\\vfx_py_debugging_examples\",\r\n
    \           \"remoteRoot\": \".\",\r\n            \"port\": 3000,\r\n            \"secret\":
    \"SFds_KjLDFJ:LK\",\r\n            \"host\": \"localhost\"\r\n        },\r\n        {\r\n
    \           \"name\": \"Python\",\r\n            \"type\": \"python\",\r\n            \"request\":
    \"launch\",\r\n            \"stopOnEntry\": true,\r\n            \"pythonPath\":
    \"${config:python.pythonPath}\",\r\n            \"program\": \"${file}\",\r\n
    \           \"cwd\": \"${workspaceFolder}\",\r\n            \"env\": {},\r\n            \"envFile\":
    \"${workspaceFolder}/.env\",\r\n            \"debugOptions\": [\r\n                \"RedirectOutput\"\r\n
    \           ]\r\n        },\r\n    ]\r\n}\r\n```"
- id: 55514
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2019-11-15 09:34:25 +0000'
  date_gmt: '2019-11-15 09:34:25 +0000'
  content: |-
    Honestly, I do not have a lot material to help you.
    I know that Python VSCode has evolved a lot since I wrote this blog post.
    Did you make sure that your code "to be debugged" contains a line such as this one
    <code>ptvsd.enable_attach("my_secret", address = ('0.0.0.0', 80))</code>

    If yes, it looks like the client tries to attach to 127.0.0 (no third 0?). I also think that you should try to listen on all intefaces not only the <a href="https://askubuntu.com/questions/247625/what-is-the-loopback-device-and-how-do-i-use-it" rel="nofollow">loopback</a> to this aim try to connect with host: "0.0.0.0"
- id: 61460
  author: Nic Redshaw
  author_email: nic@nicredshaw.plus.com
  author_url: ''
  date: '2020-07-02 22:48:05 +0000'
  date_gmt: '2020-07-02 20:48:05 +0000'
  content: "Hi Benoit,\r\n\r\nJust thought I'd first say thanks for the article -
    I was pulling my hair out before your careful explanation showed me the light
    !\r\n\r\nHere in 2020 I'm using a Mac and a raspberry pi zero w, and I had to
    install ptvsd 4.3.2 (the latest) to get it to work, and I'm using python 3. With
    this version of ptvsd it seems you can't add the 'secret' in launch.json, so I
    just omitted it:\r\n\r\n    {\r\n      \"name\": \"Attach (Benoit Remote Debug)\",\r\n
    \     \"type\": \"python\",\r\n      \"request\": \"attach\",\r\n      \"pathMappings\":
    [\r\n        {\r\n          \"localRoot\": \"${workspaceRoot}/src\",\r\n          \"remoteRoot\":
    \"/home/pi/pythondev/src\"\r\n        }\r\n      ],\r\n      \"port\": 3210,\r\n
    \     \"host\":\"pizero2.local\",\r\n      \"postDebugTask\": \"remote-stop\"\r\n
    \ }\r\n\r\n(and no secret in the python as well of course).\r\n\r\nThe postDebugTask
    can be omitted, but is there, using tasks.json and a shell script, to kill the
    python 3 process running on the pi via ssh.\r\n\r\nThanks again."
- id: 61465
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2020-07-03 10:23:38 +0000'
  date_gmt: '2020-07-03 08:23:38 +0000'
  content: |-
    Hi Nic,

    thanks a lot. This post is quite old and I have not tested how much it works with the new Remote Extensions introduced by vscode. They also mention some remote debugging capabilities. I use now Remote Extensions but have not tried to remote debug with it.
    https://code.visualstudio.com/docs/remote/remote-overview
- id: 61469
  author: Nic
  author_email: nic@nicredshaw.plus.com
  author_url: ''
  date: '2020-07-03 19:54:26 +0000'
  date_gmt: '2020-07-03 17:54:26 +0000'
  content: "Yes, the Remote extension pack looks quite comprehensive, but doesn't
    support a Raspberry Pi Zero W unfortunately - and it looks like they are not going
    to add it: https://github.com/microsoft/vscode-remote-release/issues/669\r\n\r\nAnother
    option is to use the debugpy plugin instead of ptvsd, but I haven't got round
    to that yet."
---
I truly think that no matter what your platform is, you must have access to a comfortable development environment and a working debugger is one of the most important part of it. Remote debugging can be very helpful: it is possible to execute code on a remote machine and benefit from a nice debugging experience locally in your favorite code editor.

In this blog post I propose to review the setup of Python remote debugging with the portable and popular code editor <a href="https://code.visualstudio.com/">VSCode</a>. Actually VSCode documentation provides <a href="https://code.visualstudio.com/docs/python/debugging#_remote-debugging">some very short instructions</a>. In this blog post we will provide more explanations.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/11/Screen-Shot-2017-11-25-at-18.33.06.png' caption="Use remote debugging capabilities of VSCode with Python" %}

# Prerequisite
We will assume that we do not have any security constraints. Precisely, we do not care about <a href="https://en.wikipedia.org/wiki/Man-in-the-middle_attack">MITM&nbsp;interceptions</a> between our client and remote server.&nbsp;We will discuss in appendix how we could solve this using SSH portforwarding.

We assume that the reader is familiar with the usage of a debugger in VSCode. In addition, we assume that the reader knows how to logon on a remote machine using SSH.

# Our example
In this blog post we used an Ubuntu Azure Virtual Machine. Its configuration, RAM, GPU etc. are independent so you can basically choose anything.

We assume now that the reader has an Azure Ubuntu server running and is able to logon through SSH. Note that in <a href="https://code.visualstudio.com/docs/python/debugging#_remote-debugging">VSCode documentation</a> SSH portforwarding is mentioned but we will ignore it for now.

Let us present precisely what remote debugging is.
In this post, the name <em>remote</em> stands for our Ubuntu VM on Azure while the <em>client</em> is our local, e.g. MACOS, computer. With remote debugging only a single Python process is executed on the remote VM then, on client computer, VSCode "attach itself" to this remote process so you can match the remote code execution with your local files. Therefore, it is important to keep exactly the same .py files on client and in host so that the debugging process is able to match line by line the two versions.

The magic lies in a library called&nbsp;<a href="https://pypi.python.org/pypi/ptvsd">ptvsd</a> that makes the bridge for attaching local VSCode to remotely executed process. The remotely executed Python waits until the client debugging agent is attached.

Obviously network communication is involved here and that is actually the major pitfall when configuring remote debugging. The VSCode documentation is fuzzy about whether to use IP or localhost which port to set etc. We will try to simplify things so the debugging experience becomes crystal clear.

# Networking
To make things simpler we decided to show an example where the Python process is executed on a remote machine whose IP address is 234.56.45.89 (I chose this address randomly). We use the good old port 80 for the communication (the usual port for http).

Before doing anything else we need to make sure that our remote VM network configuration is ok. We will make sure that machine 234.56.45.89 can be contacted from the outside world on port 80.

Firstly, using an SSH session on remote machine we will start a webserver using the following Python3 command. You may need elevated privilege for listening on port 80 (for real production usage give this privilege to the current user, do not sudo the process).

<script src="https://gist.github.com/bpatra/81c1fcba111629f4ec68ce196f2cb4ae.js"></script>

Secondly on a client terminal you should be able request your machine using wget (spider mode to avoid file download). In this command the target machine is accessed with IP:PORT

<script src="https://gist.github.com/bpatra/83d91641cb5b8836e0b15fe232b37f78.js"></script>

You should get response from the server. If you see some errors, you mat need to open the 80 port in firewall configuration, see <a href="https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nsg-quickstart-portal">instructions here for Azure</a>.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/11/Screen-Shot-2017-11-26-at-16.13.49-1024x369.png' caption="Make sure you can contact your machine on port 80 by running a one line Python server" %}

At this stage your network configuration is ok. You can stop the Python command that runs the webserver.

# Configuring VSCode
Make sure that you have the <a href="https://donjayamanne.github.io/pythonVSCode/">VSCode Python extension</a> installed. Follow the instructions <a href="https://code.visualstudio.com/docs/editor/debugging">here</a> to add a new Debug configuration in your <code>launch.json</code> containing the following JSON configuration.

<script src="https://gist.github.com/bpatra/202383698d6a717db4fa94ac9a078e45.js"></script>

It is important to understand that this configuration is only for VSCode. The <em>host</em> corresponds to the machine where the remote Python process is ran. The <em>port</em> corresponds to the port that will be used by the remote process to communicate with the client debugging agent, in our case it is 80.

You must specify the root folders, on both local environment and on the remote machine.

That's it for VSCode configuration.

# The code under debugging
Let us debug the following Python script

<script src="https://gist.github.com/bpatra/706f4e0dac2a204b7291ca804a027c36.js"></script>

As explained in the introduction, the Python file must be the same on client and on remote machine. There is one exception yet, the line <code>ptvsd.wait_for_attach()</code> must be executed by remote Python process only. Indeed, it tells the Python process to pause and wait that the client is attached to continue.

Of course in order to execute it you may need to install dependencies (for example using <a href="https://pypi.python.org/pypi/pip">Pip</a>) so it executes on the remote machine.

REMARK: looks like at the time of the writing version of <code>ptvsd>3.0.0</code> suffers some problems. I suggest that you force the install of version <code>3.0.0</code>, see <a href="https://github.com/DonJayamanne/pythonVSCode/issues/981">this issue</a>.

It is important to understand that <code>enable_attach, enable_attach, break_into_debugger</code> are instructions for the remote Python process. The first line <code>ptvsd.enable_attach("my_secret", address = ('0.0.0.0', 80))</code> basically instructs the remote Python process to listen on all network interfaces, on port 80 for any client debugger that would like to attach. This client agent must provide the right secret (here my_secret).

The line <code>ptvsd.break_into_debugger()</code> is important, it is the line that allows to break and navigate in code with client VSCode.

# Putting things together
Now you are almost ready. Make sure your Python file is duplicated on both local and remote at root location. Make sure the <code>ptvsd.wait_for_attach</code> is uncommented and executes on remote environment.

Now using an SSH session on remote machine. Start the Python process using elevated privileges
<code>sudo python3 your_file_here.py</code>

This should not return anything right now and should be hanging, waiting for your VSCode to attach the process.

Set a VSCode break point just after <code>ptvsd.break_into_debugger()</code>, make sure that in VSCode the selected debugging configuration is Attach (Remote Debugger). Hit F5, you should be attached and breaking in code !

What a relief, efficient working ahead !

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/11/Screen-Shot-2017-11-26-at-16.45.59-1024x775.png' caption="Breaking in VSCode" %}

# Going further
The debugging procedure described aboved is simplified and suffer some flaws.

## Security constraints
Here anybody can intercept your traffic, it is plain unencrypted http traffic. A recommended and yet simple option to secure the communication is to use <a href="https://forwardhq.com/help/ssh-tunneling-how-to">SSH port forwarding tunnelling</a>. It basically creates an encrypted network communication between your localhost client and the remote machine. When an SSH tunnel is setup, you can talk to your local machine on a given port and the remote receives call on another port (magic, isn't it?). Therefore the launch.json configuration should be modified and <em>host</em> value is localhost. Note also that the port in Python code and in launch.json may not be the same, you have two different ports now.

## Copying files
We pointed out that the files must be the same between local env and remote. We advise to group in a shell script: the files mirroring logic (using <a href="https://en.wikipedia.org/wiki/Secure_copy">scp</a>) and the execution of the Python process on remote machine.

## Handling differences between local and remote files
We said that the files must the same between local env and remote but we need some differences at least to allow the execution of <code>ptvsd.wait_for_attach</code> on remote.
This is definitely something that can be handled in an elegant manner using environment variables.

<script src="https://gist.github.com/bpatra/90e8431b78eac650e5da8eabcce8da12.js"></script>

Of course you need to pass now the environment variable to you remote process with SSH, see <a href="https://superuser.com/questions/163167/when-sshing-how-can-i-set-an-environment-variable-on-the-server-that-changes-f">this stackexchange post</a> to know how to do that.

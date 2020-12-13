---
layout: post
title: Remote debugging Python with VSCode
date: '2017-11-27 21:50:29 +0000'
categories:
- Programming
- DevTools
tags:
- azure
- python
- vscode
- debugging
- networking
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


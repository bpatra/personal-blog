---
layout: post
title: No hdmi sound without OS reboot? Restart the drivers...
date: '2013-12-22 18:10:38 +0000'
categories:
- Uncategorized
- Scripting
- Windows
tags:
- Device driver
- HDMI
- hdmi sound
- Microsoft Windows
- Operating system
- powershell
- Television
---
<strong>Edit:</strong> end july 2015 the problem is now fixed for me with windows 10.

This post blog follows a problem that I encountered when I upgraded my laptop to windows 8.1. Precisely, the hdmi sound stops working immediately when I connect the hdmi cable to my television. The hardware works fine because if the OS is reboot with hdmi cable plugged, then the TV as a sound playback device is available. This is terribly annoying, you do not want to reboot each time you want to use your TV as a display device. While searching the internet for a solution, I discovered that I am not the only one with this problem. Therefore, I will try to expose my solution with many details in order to make it reusable by others who would stumble on this post with the same problem.

Assuming that you are in the same, or a close, situation: the hdmi sound works well when Windows is reboot with the cable plugged in. Consequently, when everything is working, if you right click on the sound icon in the tray bar and select "playback devices" you should be able to see the TV in the device playbacks&nbsp;.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/playbackdevices.jpg' caption="The list of available playback devices." %}

Before going any further the first thing to do is to update the drivers. This is quite simple, right click on the windows menu at the bottom left of your desktop screen and select the device manager. My advice is to update all drivers for the two entries in the tree view "display adapters" and "sound, video and game controllers".

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/devicemanager-300x195.jpg' caption="The device manager" %}

Once all drivers have been updated, check that the problem still occurs (restart the OS once at least) and if it does you may be interested in the following.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/updatedriversoftware-300x206.jpg' caption="Upgrading driver software" %}


So even after updating the drivers, you still need the reboot to get the sound. Actually, the drivers managing the hdmi need to be restarted and that is what we are going to do manually, without restarting the OS. To perform such action, we are going to need devcon.exe which is a tiny program distributed freely by Microsoft with the Windows Driver Kit. Download it<a href="http://msdn.microsoft.com/en-us/windows/hardware/gg454513.aspx"> here</a>&nbsp;(you do not need Visual studio).

After the (silent) installation of WDK you may find <strong>devcon.exe</strong> in the the path <em>"C:\Program Files (x86)\Windows Kits\8.1\Tools\x64"</em>. You will notice that you have two directories in Tools the "/x64" and the "/x86" (i.e 32 bits), use the one corresponding to your system (to know more on 32 bits vs 64 bits <a href="http://windows.microsoft.com/en-us/windows/32-bit-and-64-bit-windows#1TC=windows-7">check this</a>).

*WARNING:* devcon.exe error messages are extremely misleading (read completely wrong...). Indeed, if you are using the x86 version instead of the x64 version or if you are trying to restart the drivers (see below) without administrators right you will still have the same error.: "No matching devices found". Consequently, do not try to interpret the error raised by devcon.exe.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/listmedia1-300x77.jpg' caption="'devcon.exe listclass media' executed in powershell using conemu terminal" %}


Now, we are going to restart the two drivers using devcon.exe. First, let us see all drivers dedicated to sound, then type in your command prompt (or better with <a href="http://en.wikipedia.org/wiki/Windows_PowerShell">powershell</a>) run as administrator: <strong>
&lt;pathToDevCon&gt;/devcon.exe listclass media</strong>

The response here is a list of two items, we are going to retain the first one, <em>"Intel (R) display"</em>, which was the audio adapter used for the hdmi (see the first screen shot of this post). The driver Id: <em>HDAUDIOFUNC_01&amp;VEN_8086&amp;DEV_2807&amp;SUBSYS_80860101&amp;REV_10004&amp;36161A1D&amp;0&amp;0001&nbsp;</em>is&nbsp;going to be needed. If you are using powershell you may use the <a href="http://technet.microsoft.com/en-us/library/ee176924.aspx">Out-File command</a> to write it down in a text file...

You can try to restart it directly by typing (in command line run as administrator):&nbsp;<strong>
&lt;pathToDevCon&gt;/devcon.exe restart "@<DRIVER_ID>".<br />
</strong>Note that the @ symbol is inside the quotes which may surprise you if you are a .NET developer...

Unfortunately, it does not seem to be sufficient and the system also needs to reboot the display adapter driver after that. So we are going to do the same action but for display adapter driver: we type in an admin command line:<br />
<strong>
&lt;pathToDevCon&gt;/devcon.exe listclass display</strong>


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/listmedia2-300x90.jpg' caption="devcon.exe listclass display" %}

Then now if you restart the driver listed here as <em>"Intel(R) HD Graphics Family"</em> then the <a class="zem_slink" title="HDMI" href="http://en.wikipedia.org/wiki/HDMI" target="_blank" rel="wikipedia">HDMI</a> sound device playback should be available if the cable is connected. To do so execute:

<strong><strong>
&lt;pathToDevCon&gt;/</strong>devcon.exe restart&nbsp;"@PCIVEN_8086&amp;DEV_0A16&amp;SUBSYS_130D1043&amp;REV_093&amp;11583659&amp;0&amp;10"</strong>

The Id above is mine, obviously you should use yours.

Fine but this is not over yet. Indeed, you do not want to do all this each time you are connecting your hdmi cable with your TV. What we are going to do right now, is to add a powershell script that will automated this process so that you will just have to click on one icon when you will want your TV sound. If you have never run powershell script on your machine, then the execution of ps1 file (powershell script) will not be allowed. Read&nbsp;<a href="http://technet.microsoft.com/en-us/library/ee176949.aspx">this</a> to enable powershell script execution (basically you will just have to type in a powershell console, run as admin, Set-ExecutionPolicy Unrestricted).

Here is the script that you can use. I have added two instructions to enable the drivers, it seems to be sometimes useful when you plug/unplug the hdmi cable several times. All you have to do to make it work is to change the path to devcon.exe and the id. You can save it to the place of your choice such as the <em>Desktop</em> with a .ps1 extension (e.g. restart_drivers.ps1)

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/8072213.js' %}

Remind that to be effective this .ps1 file should be executed with administrator rights. Remind also, that devcon.exe will only tell you that the drivers cannot be found if you are not with admin rights. So I am suggesting to make the script more easily run in admin mode, you can put a powershell.exe shortcut next to the .ps1 script file. By right clicking on the shortcut file go to Properties and fill the target property as follows.&nbsp;Target:"powershell.exe restart_drivers.ps1". Then, in Advanced... select Run as administator.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/12/shortcuts-300x268.jpg' caption="A shortcut to run restart_drivers.ps1 directly with admin right" %}


<span style="line-height: 1.714285714; font-size: 1rem;">That is all, no when you will connect your hdmi </span><span style="line-height: 1.714285714; font-size: 1rem;">cable you will only have to click on the shortcut and enjoy the sound from your TV.</span>

&nbsp;


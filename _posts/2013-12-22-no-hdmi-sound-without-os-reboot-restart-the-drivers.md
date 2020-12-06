---
layout: post
status: publish
published: true
title: No hdmi sound without OS reboot? Restart the drivers...
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 142
wordpress_url: http://benoitpatra.com/?p=142
date: '2013-12-22 18:10:38 +0000'
date_gmt: '2013-12-22 17:10:38 +0000'
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
comments:
- id: 51
  author: Eric
  author_email: snopzet@web.de
  author_url: ''
  date: '2014-03-23 13:22:15 +0000'
  date_gmt: '2014-03-23 12:22:15 +0000'
  content: |-
    This is really awesome!! I have this problem since I own a HTPC and turning off the connected TV is a no-go since windows forgets most sound formats if you do that (i.e. aac sound stops working). After 5 years I can finally fix it with a simple click on a script. Thank you so much!

    You need to spread this blog in all the common HTPC communities... It's very hard to find atm and I bet a lot of people there would love this solution.
- id: 61
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2014-03-24 15:05:40 +0000'
  date_gmt: '2014-03-24 14:05:40 +0000'
  content: Hi Eric, thank you very much, I am very pleased that this solution helped
    you this post was meant for that. I am not into HTPC but feel free to share the
    link with those communities.
- id: 71
  author: jn
  author_email: jn@none.com
  author_url: ''
  date: '2014-06-14 07:46:21 +0000'
  date_gmt: '2014-06-14 05:46:21 +0000'
  content: All this did was crash my Windows 8 with a blue screen. :(
- id: 81
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2014-07-07 16:12:57 +0000'
  date_gmt: '2014-07-07 14:12:57 +0000'
  content: I am sorry that the script did not work for you. I also saw some situtations
    where the manual restart was not efficient.
- id: 91
  author: Peter
  author_email: ptrlovgren@gmail.com
  author_url: ''
  date: '2014-07-08 09:26:15 +0000'
  date_gmt: '2014-07-08 07:26:15 +0000'
  content: "This solution would probably have worked for me if it wasn't for one thing.
    Devcon can't restart something that it can't see. \nI have my laptop always connected
    to a receiver through HDMI which in turn of course is connected to a TV. If I
    boot up my laptop and switch the display to the TV it works great the first time
    with the audio and all that. If I then switch back to the laptop and then back
    again to the TV the sound is lost and is not listed in the playback devices or
    among the devices listed in Devcon. \nI saw that in your script you've added a
    command for enabling the devices and I tried to use that too but with the same
    result as Devcon can't see it and therefore can not enable it. \nThis behavior
    seems to repeat itself if I start a game or something that will use the dedicated
    graphics card (Nvidia GTX 780M) instead of the integrated (Intel HD4600) directly
    after boot and before switching to the TV. This has lead me to believe that it
    has something to do with Nvidias Optimus technology so I tried restarting the
    Nvidia driver just in case but it didn't help. \nLooks like I'm going to have
    to keep restarting to get my sound..."
- id: 101
  author: Peter
  author_email: ptrlovgren@gmail.com
  author_url: ''
  date: '2014-07-08 09:46:59 +0000'
  date_gmt: '2014-07-08 07:46:59 +0000'
  content: Ok so I forgot to mention one thing that (after som testing) seems to be
    the culprit. When at my desk I'm hooked up to an external display (connected via
    an Displayport -> DVI connector if that matters) and the scenario mentioned above
    only happens while using that display. If I just use the laptops display I can
    switch back and forth with my TV without any issues at all.
- id: 111
  author: Nils
  author_email: nyberg_5@hotmail.com
  author_url: ''
  date: '2014-07-16 23:33:13 +0000'
  date_gmt: '2014-07-16 21:33:13 +0000'
  content: I only get access denied with the first step, even though I run cmd as
    administrator
- id: 121
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2014-07-17 08:54:37 +0000'
  date_gmt: '2014-07-17 06:54:37 +0000'
  content: Hi Nils, what is the message raised by devcon.exe?
- id: 131
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2014-07-17 08:55:02 +0000'
  date_gmt: '2014-07-17 06:55:02 +0000'
  content: Hi Nils, what is the message raised by devcon.exe?
- id: 141
  author: Alexander
  author_email: akolesnikov93@gmail.com
  author_url: ''
  date: '2014-08-02 11:26:12 +0000'
  date_gmt: '2014-08-02 09:26:12 +0000'
  content: |-
    You need to open PowerShell as an administrator, then run:
    Set-ExecutionPolicy Unrestricted
    This will solve the problem
- id: 151
  author: Alexander
  author_email: akolesnikov93@gmail.com
  author_url: ''
  date: '2014-08-02 11:31:22 +0000'
  date_gmt: '2014-08-02 09:31:22 +0000'
  content: |-
    Thanks for the great howto!
    However, I can't get it work.
    I've downloaded the latest WDK for Win 8.1 and I'm using x64 version of it.
    The output is:
    HDAUDIOFUNC_01&amp;VEN_8086&amp;DEV_2807&amp;SUBSYS_80860101&amp;REV_10004&amp;490A462&amp;0&amp;0001: Enabled
    1 device(s) are enabled.
    PCIVEN_8086&amp;DEV_0A16&amp;SUBSYS_05EB1028&amp;REV_093&amp;11583659&amp;0&amp;10: Enabled
    1 device(s) are enabled.
    HDAUDIOFUNC_01&amp;VEN_8086&amp;DEV_2807&amp;SUBSYS_80860101&amp;REV_10004&amp;490A462&amp;0&amp;0001: Restart failed
    No matching devices found.
    PCIVEN_8086&amp;DEV_0A16&amp;SUBSYS_05EB1028&amp;REV_093&amp;11583659&amp;0&amp;10: Restart failed
    No matching devices found.
    Google can't help me with this problem. Can you please provide more detailed answer? Thanks!
- id: 161
  author: Vip Sandhu
  author_email: vipatron@gmail.com
  author_url: http://doctorsandhu.com
  date: '2014-11-10 16:36:50 +0000'
  date_gmt: '2014-11-10 15:36:50 +0000'
  content: This is amazing. Fantastic job, Mr. Patra I have been running into this
    problem ever since Windows forced me into the mandatory 8.1 update. Now I can
    avoid restarting so often. I noticed some grammar issues typical of non-native
    English speakers. Je peux traduirer/corriger ceux qui j'ai remarque, si vous voudriez.
    Et encore, merci mille fois pour l'aide!
- id: 171
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2014-11-10 17:16:50 +0000'
  date_gmt: '2014-11-10 16:16:50 +0000'
  content: "Hi, \nI would be very pleased if you help me to correct my English mistakes.\nI
    am also pleased to hear that the solution works well for you. It seems that the
    solution does not work for some environment, unfortunately I did not have the
    time to investigate further..."
- id: 181
  author: cydonia1978
  author_email: cydonia1978@gmail.com
  author_url: ''
  date: '2015-01-09 06:59:44 +0000'
  date_gmt: '2015-01-09 05:59:44 +0000'
  content: Just wanted to say thank you! This worked perfectly on my Asus laptop running
    Win8.1 and connecting via HDMI to a very old Samsung TV. It was pretty annoying
    to not have audio without rebooting, and this worked like a charm!
- id: 191
  author: Renan
  author_email: renanssj5@yahoo.com.br
  author_url: ''
  date: '2015-03-05 23:16:40 +0000'
  date_gmt: '2015-03-05 22:16:40 +0000'
  content: Hi im From Brazil, thank you so much, im suffering with this with MSI gt70
    and now works without restart or plug and unplug THANK YOU SO MUCH!!!
- id: 201
  author: EsQueue
  author_email: klaj@hotmail.com
  author_url: ''
  date: '2015-04-05 17:24:44 +0000'
  date_gmt: '2015-04-05 15:24:44 +0000'
  content: I was just about to report that it didn't work for me but it actually did.
    Just shows my TV instead of my receiver but as long as the receiver works I am
    happy. Thanks for your write up. This has been EXTREMELY annoying.
- id: 211
  author: Jasper
  author_email: nomail@ennak.com
  author_url: ''
  date: '2015-05-09 18:58:21 +0000'
  date_gmt: '2015-05-09 16:58:21 +0000'
  content: Thanks a million!
- id: 14531
  author: Odin
  author_email: Odin.herjan@gmail.com
  author_url: ''
  date: '2016-02-23 21:28:14 +0000'
  date_gmt: '2016-02-23 21:28:14 +0000'
  content: "Couple of years later, I encounter the same problem in Windows 10 and
    this guide solves it! Perfect :-)\r\n\r\nPS! Also thanks to Alexander in the comments
    regarding execution policy!"
- id: 14728
  author: No sound over hdmi moving to other TV win 10 - Hardware Canucks
  author_email: ''
  author_url: http://www.hardwarecanucks.com/forum/o-ss-drivers-general-software/72050-no-sound-over-hdmi-moving-other-tv-win-10-a.html#post817744
  date: '2016-03-06 11:52:14 +0000'
  date_gmt: '2016-03-06 11:52:14 +0000'
  content: "[&#8230;] someone who had made a script that would essentially shut off
    and then turn on the hdmi device  No hdmi sound without OS reboot? Restart the
    drivers&hellip; | Benoit Patra personal blog   __________________ Lian Dream:
    i7 2600k @ 4.6Ghz, Asus Maximus IV Gene-z, MSI 980ti Gaming 6G, [&#8230;]"
- id: 15112
  author: Vans
  author_email: icookies5@yahoo.com
  author_url: ''
  date: '2016-03-24 23:47:04 +0000'
  date_gmt: '2016-03-24 23:47:04 +0000'
  content: THANK YOU!! I was getting so tired of restarting my computer and I was
    about to lose all hope.  Updating the display adapters worked for me.
- id: 18584
  author: Andre
  author_email: aeleblanc@gmail.com
  author_url: ''
  date: '2016-09-29 23:34:31 +0000'
  date_gmt: '2016-09-29 23:34:31 +0000'
  content: "This is great.  Unfortunately for me, it says the restart of the HDMI
    requires a reboot.  The monitor restarts ok.  I implemented the script you kindly
    silver-plattered for us.  This is what I get.  Does anybody have any suggestions
    about getting around this?\r\n\r\nPS C:\\> ./HDMI_Samsung.ps1\r\nHDAUDIO\\FUNC_01&amp;VEN_10EC&amp;DEV_0283&amp;SUBSYS_102805FB&amp;REV_1000\\4&amp;1C5157D6&amp;0&amp;0001:
    Enabled on reboot\r\nThe 1 device(s) are ready to be enabled. To enable the devices,
    restart the devices or\r\nreboot the system .\r\nPCI\\VEN_8086&amp;DEV_0A16&amp;SUBSYS_05FB1028&amp;REV_09\\3&amp;11583659&amp;0&amp;10:
    Enabled\r\n1 device(s) are enabled.\r\nHDAUDIO\\FUNC_01&amp;VEN_10EC&amp;DEV_0283&amp;SUBSYS_102805FB&amp;REV_1000\\4&amp;1C5157D6&amp;0&amp;0001:
    Requires reboot\r\nThe 1 device(s) are ready to be restarted. To restart the devices,
    reboot the system.\r\nPCI\\VEN_8086&amp;DEV_0A16&amp;SUBSYS_05FB1028&amp;REV_09\\3&amp;11583659&amp;0&amp;10:
    Restarted\r\n1 device(s) restarted."
- id: 19298
  author: Ben_fromVienna
  author_email: benjamin.heinrich@gmx.at
  author_url: ''
  date: '2016-11-06 02:38:12 +0000'
  date_gmt: '2016-11-06 02:38:12 +0000'
  content: "Wow youre really a pro on Windows Client Administration.\r\nJust searched
    for this because I wondered about one simple thing:\r\nI got a notebook with integrated
    webcam. Nothing special.\r\nSometimes I dont want my webcam to be active (not
    just because of oberservation but you know there a webpages that would automatically
    request webcam access so that step is not necessary if already deactivated.\r\nPoint
    is however, Windows 7 has a strange way to react on using the same function multiple
    times.\r\n\r\nHardware &amp; Sound => device Manager ->Imaging devices\r\nSelect
    my device\r\nThen I go to \"Properties\"->Drivers -> Deactivate/Activate  (Always
    depending on if i need or not need it).\r\nHere comes the catch:\r\nSometimes
    I can just  click OK and its done.\r\nBUT other times after pressing OK I will
    get a message, that Windows has to be restarted first.\r\nSo is this behaviour
    similiar to the one why you may need reboot for using hdmi sound?\r\nThe strangest
    thing about it is, that sometimes windows will accept my change immediately, other
    times may require reboot.  Any idea why Windows does that?\r\nI really find it
    to be an annoyance, because I have to save my work first and then reboot and thats
    such a waste of time in my mind."
- id: 19311
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-11-07 09:15:15 +0000'
  date_gmt: '2016-11-07 09:15:15 +0000'
  content: |-
    Hi Benjamin,
    actually I am no expert on Windows/Drivers management. I do not really know the ins and outs of drivers interaction with Windows. I shared this script leveraging devcon.exe because this is the only workaround I found. Actually, it worked fine for me for a while after that it stopped working. I do not need it anymore now that I migrated to win10. Sorry I cannot help you more right now. If I see something that may be useful for you I will gladly share it with you.
- id: 19344
  author: Mike
  author_email: ezrider86@hotmail.com
  author_url: ''
  date: '2016-11-09 16:12:00 +0000'
  date_gmt: '2016-11-09 16:12:00 +0000'
  content: "Hello, Thank you for sharing your solution to this problem.  I hope you
    can help me out.  I'm getting an error running the script.  The error reads:\r\n\r\nUnexpected
    token 'devcon' in expression or statement.\r\nAt C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\Soundfix.ps1:1
    char:10 +1 $devcon <<<< = \"C:\\Program Files (x86)Windows Kits\\10\\Tools\\x64\\devcon.exe\"\r\n+Categoryinfo
    :ParserError: (devcon:string) [], ParseException\r\n+FullyQualifiedErrorId :UnexpectedToken\r\n\r\nMy
    script:\r\n1 $devcon = \"C:\\Program Files (x86)\\Windows Kits\\10\\Tools\\x64\\devcon.exe\"
    \r\n2 $audioID = \"@HDAUDIO\\FUNC_01&amp;VEN_8086&amp;DEV_2807&amp;SUBSYS_80860101&amp;REV_1000\\4&amp;1EACBCB&amp;0&amp;0001\"
    \r\n3 $displayID = \"@PCI\\VEN_8086&amp;DEV_0A16&amp;SUBSYS_B21319DA&amp;REV_09\\3&amp;11583659&amp;0&amp;10\"
    \r\n4 . $devcon enable $audioID \r\n5 . $devcon enable $displayID \r\n6 . $devcon
    restart $audioID \r\n7 . $devcon restart $displayId \r\n8 Read-Host \r\n\r\nAny
    thoughts?"
- id: 19345
  author: Mike
  author_email: ezrider86@hotmail.com
  author_url: ''
  date: '2016-11-09 16:20:35 +0000'
  date_gmt: '2016-11-09 16:20:35 +0000'
  content: Sorry disregard my previous comment I just realised that I should not have
    included the line numbers in the script.  Unfortunately when the script runs it
    does not find the drivers for me. "No matching devices found"
- id: 19413
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-11-13 17:05:44 +0000'
  date_gmt: '2016-11-13 17:05:44 +0000'
  content: Unfortunately, "No matching devices found" looks to be a generic error
    for devcon.exe and does not really help for error diagnostics... did you make
    sure to use the proper devcon x86 vs x64 ? Did you start with admin rights ?
- id: 19677
  author: Matthew
  author_email: steeljockey@live.com.au
  author_url: ''
  date: '2016-11-30 06:31:21 +0000'
  date_gmt: '2016-11-30 06:31:21 +0000'
  content: "I get problems right at the start, the first response being \"the term
    'x86' is not recognised as the name of a cmdlet.....etc etc.\r\n\r\nThis is what
    I type in to get that response\r\nC:\\Program Files\\Windows Kits\\10\\Tools\\x64/devcon.exe
    listclass media\r\n\r\nI get the same response in both powershell and command
    prompt, running both as administrator"
- id: 19679
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2016-11-30 10:33:20 +0000'
  date_gmt: '2016-11-30 10:33:20 +0000'
  content: "Hi, Matthew\r\ncan you chech that devcon.exe is indeed located at the
    specified location?\r\nif it is indeed there, try invoking with double quotes
    \"C:\\Program Files\\Windows Kits\\10\\Tools\\x64\\devcon.exe\" listclass media"
- id: 19680
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2016-11-30 10:33:26 +0000'
  date_gmt: '2016-11-30 10:33:26 +0000'
  content: |-
    Hi, Matthew
    can you chech that devcon.exe is indeed located at the specified location?
    if it is indeed there, try with invoking with double quotes "C:\Program Files\Windows Kits\10\Tools\x64\devcon.exe" listclass media
- id: 19778
  author: Vijay
  author_email: vbpahuja@yahoo.com
  author_url: ''
  date: '2016-12-10 13:45:09 +0000'
  date_gmt: '2016-12-10 13:45:09 +0000'
  content: Fantastic! Thank you.
- id: 19880
  author: Kyle P Elliott
  author_email: twistwit@gmail.com
  author_url: ''
  date: '2016-12-18 09:18:54 +0000'
  date_gmt: '2016-12-18 09:18:54 +0000'
  content: "here this is what i had to use\r\n\r\ncd ${Env:ProgramFiles(x86)}\"\\Windows
    Kits\\8.1\\Tools\\x64\""
- id: 20841
  author: Martin
  author_email: martinoferbero@gmail.com
  author_url: ''
  date: '2017-02-15 21:58:39 +0000'
  date_gmt: '2017-02-15 21:58:39 +0000'
  content: "Hey Benoit,\r\n\r\nI was so happy that it worked: On both devices it says
    enabled and restarted. But in playback devices, still the Samsung TV shows: not
    plugged in\r\n\r\nI checked several times, if it is the right devices, and right
    numbers. I even restarted other display adapters(I have 2, Intel and Nvidia),
    but it doesn't work.  Any idea my friend? Maybe other drivers have to be restarted?
    Would really appreciate your help."
- id: 20842
  author: Martin
  author_email: martinoferbero@gmail.com
  author_url: ''
  date: '2017-02-15 22:42:18 +0000'
  date_gmt: '2017-02-15 22:42:18 +0000'
  content: "..the only difference I can see at all between your system and mine, is
    the first screenshot, at playback devices: Your system says under TV: Intel(R)
    Display Audio, mine says: High Definition Audio Device"
- id: 20843
  author: Martin
  author_email: martinoferbero@gmail.com
  author_url: ''
  date: '2017-02-15 23:08:49 +0000'
  date_gmt: '2017-02-15 23:08:49 +0000'
  content: 'this is what it looks like: http://imgur.com/a/DVjAH'
- id: 22763
  author: Sanehet
  author_email: holograma59@hotmail.com
  author_url: ''
  date: '2017-06-08 13:35:19 +0000'
  date_gmt: '2017-06-08 13:35:19 +0000'
  content: "Hey, thank you very much for your help! \r\n\r\nIn my case, I only had
    to update in \"display devices\" - the driver \"Intel(R) HD Graphics 520\" which
    is the video card I suppose. \r\n\r\nI have not updated the sound or video game
    drivers, nevertheless I can now reproduce sound in my TV through HDMI and I didn't
    need to reboot my OS.\r\n\r\nDo you consider necessary updating the sound and
    video game drivers?\r\n\r\nThanks again for your solution! Cheers!!"
- id: 22764
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2017-06-08 14:27:01 +0000'
  date_gmt: '2017-06-08 14:27:01 +0000'
  content: "Hi Sanehet,\r\nI am really no expert on hardware and drivers. I would
    say that if it works for you as it is for now: do not touch it.\r\n\r\nNormally,
    for any piece of software such as web browser - OS etc. I encourage people to
    upgrade to be protected against 0-day security breach https://en.wikipedia.org/wiki/Zero-day_(computing).
    However, for these drivers they are so unstable I would not touch and they are
    not an entry point for malware. So I guess it is ok no to upgrade."
- id: 22831
  author: Nikolai
  author_email: ns@skoleit.dk
  author_url: ''
  date: '2017-06-12 12:19:36 +0000'
  date_gmt: '2017-06-12 12:19:36 +0000'
  content: Any updates on this - i'm having the exact same problem.
- id: 26237
  author: Marcus
  author_email: marcus.powrie@gmail.com
  author_url: ''
  date: '2018-01-18 01:15:21 +0000'
  date_gmt: '2018-01-18 01:15:21 +0000'
  content: "Nice tip - thanks!\r\nTo make the script elevate itself with admin privileges
    so it can be run from clicking a shortcut, I've slightly modified it to:\r\n\r\nWrite-Host
    \"this script requires admin rights otherwise it will tell fibs.\"\r\n#elevate
    this script with administrator privileges\r\nIf (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]
    \"Administrator\"))\r\n\t{   \r\n\t$arguments = \"&amp; '\" + $myinvocation.mycommand.definition
    + \"'\"\r\n\tStart-Process powershell -Verb runAs -ArgumentList $arguments\r\n\tBreak\r\n}\r\n\r\n$devcon
    = \"C:\\Program Files (x86)\\Windows Kits\\10\\Tools\\x64\\devcon.exe\"\r\n\r\n#
    Get the ID of the HDMI audio device\r\n# $devcon listclass media\r\n# note down
    this ID, and replace the below $audioID=\"@...\" value\r\n$audioID = \"@HDAUDIO\\FUNC_01&amp;VEN_8086&amp;DEV_2808&amp;SUBSYS_80860101&amp;REV_1000\\4&amp;B48B4B&amp;0&amp;0001\"\r\n\r\n#
    now get the ID of the HDMI device\r\n# $devcon listclass display\r\n# note down
    this ID, and replace the below $displayID=\"@...\" value\r\n$displayID = \"@PCI\\VEN_8086&amp;DEV_1616&amp;SUBSYS_225A103C&amp;REV_09\\3&amp;B1BFB68&amp;0&amp;10\"\r\n\r\nWrite-Host
    enabling HDMI audio...\r\n. $devcon enable $audioID\r\nWrite-Host enabling HDMI
    display...\r\n. $devcon enable $displayID\r\nWrite-Host restarting HDMI audio...\r\n.
    $devcon restart $audioID\r\nWrite-Host restarting HDMI display...\r\n. $devcon
    restart $displayId\r\nWrite-Host Done!\r\nWrite-Host press Any key to continue.."
- id: 27978
  author: Antonios Theodosiou
  author_email: aetheod@hotmail.com
  author_url: ''
  date: '2018-05-09 20:37:46 +0000'
  date_gmt: '2018-05-09 20:37:46 +0000'
  content: "Thanks for this post! \r\nIt absolutely solved my problem. \r\nFor my
    case, in order to enable the sound, I had only to restart the HDMI audio drivers
    (4 drivers)"
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


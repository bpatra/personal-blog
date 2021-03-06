---
layout: post
title: Windows with WSL2, a good configuration for a dev team?
featured: false
date: '2020-03-07 00:00:00 +0000'
disqus: false
image: /assets/images/legacy-wp-content/2020/03/Ubutntu-on-Windows-10-logo-banner2.jpg
featured_image: /assets/images/legacy-wp-content/2020/03/Ubutntu-on-Windows-10-logo-banner2.jpg
categories:
- Programming
- Windows
tags:
- windows
- Linux
- Ubuntu
- MacOS
- WSL
- WSL2
- Docker
- Team Management
- Efficiency
---
In the Talentoday tech team we have regular discussions about the best Operating System (OS) workstation configuration for the team. While experienced engineers are free to choose what they prefer, it is reasonable to recommend and maintain a kind of <em>preferred</em> configuration for interns and juniors to facilitate the setup and onboarding. Talentoday tech stack being <a href="https://stackoverflow.com/questions/4715374/what-is-the-meaning-of-nix">*Nix based</a>, for long most of the developers were using MacOS with MacBooks. This is definitely an acceptable solution but we confronted that, and some of us (me included), started to use Linux distributions. However, I did not&nbsp;find yet an ideal setup. I will&nbsp;share here&nbsp;some criticisms about various OS configurations and discuss the new Microsoft WSL2 and see how this could be the best of <del>both</del> all worlds, yet to be confirmed.

<h2>Usual OS configurations, main flaws</h2>
First I am presenting here my main criticisms, as you will notice most are not on the technologies themselves but more on their daily usage within a team and a potential large fleet of devices.

<strong>Windows OS</strong>. Unless you&nbsp;develop solely .NET applications (the regular .NET FX not the new .NET Core) that can only run on Windows OS then, Windows is probably not the ideal dev OS. While Python interpreters work well on Windows some other technologies, like Ruby for instance, are <a href="https://www.reddit.com/r/ruby/comments/e1e1kh/not_able_to_install_rubydevkit_2651_64_on_windows/">really a pain on Windows</a>.&nbsp;It is a fact that most of developer tools and technologies are not thought for Windows (or at least not as a <em>first class citizens</em>). On the positive side, administrating the team machines would be easier compared to others. Indeed, Windows is really adapted for maintaining a large fleet of machines and most <em>everyday applications</em> run perfectly on Windows. Unfortunately, this latter argument does not counterbalance the poor dev experience on many technologies.

<strong>Linux standalone OS setup</strong>. In this case, you have a real Linux OS that will probably be the closest thing that hosts and runs your applications in production. Using Linux, you can use a great package manager such as <a href="https://en.wikipedia.org/wiki/APT_(software)">apt</a>. Good code editors like VSCode or Sublime work perfectly. Yet... in the real world other problems arise. First, the ones that are due to Linux desktops and window manager themselves. For example, having different resolutions and scaling for your screens is not well supported <a href="https://www.reddit.com/r/Ubuntu/comments/a4h7ot/ubuntu_with_dual_and_different_dpi_monitors/">unless you go with Weyland.</a>&nbsp;Well with Weyland you will stumble on troubles <a href="https://superuser.com/questions/1221333/screensharing-under-wayland">for sharing your screens</a>. In our team, we do remote work, we need to share things when huddling. We have to present to clients and teammates around the world everyday. You need a comfortable setup with multiple monitor and the ability to jump on in case clients invite you on a <a href="https://www.gotomeeting.com/">GoToMeeting</a>, <a href="https://zoom.us/">Zoom.us</a> or whatever videoconf system and this needs to work. Similarly, it happens frequently that we receive <em>*.xlsx,</em> <em>*.docx</em> files with macros that only Office desktop can process. Therefore, even if you manage to have everything working on your Linux desktop workstation there are things, independent of your will, that can sometimes be problematic.

<strong>Dual boots</strong>. Honestly, I never was really convinced by <a href="https://opensource.com/article/18/5/dual-boot-linux">dual boots</a>. It is quite cumbersome. In addition, most of the time you need <a href="https://askubuntu.com/questions/880240/it-is-possible-to-dual-boot-linux-and-windows-10-with-secure-boot-enabled">to disable secure boot</a>, which is, for a company setup, probably not a good recommendation.

<strong>Leveraging virtualized OS</strong>. That's an option and here are two possibilities. First, host OS is Windows/MacOS and you develop in a guest Linux. Well if you are a developer your primary work will probably be development, then, even though you can make your VM as seamless as possible, it is always preferable to do your everyday work in the host OS. The other way is setting a guest Windows OS (you cannot guest MacOS) on Linux host. Again, some problems like sharing your Linux screen for showing your local devwork will not go away. Let me also point out that you depend a lot on the hypervisor and its ability to handle well displays. My experience proved me that this is often bugged. Fixing this&nbsp;kind of bugs&nbsp;does&nbsp;not seem to be the top priority of hypervisors. Take for example Oracle and VirtualBox <a href="https://www.virtualbox.org/ticket/14349">that keeps ignoring for years this bug on HighDPI screen</a>.

<strong>Mac OS</strong>. It seems that this has become a very popular solution for developers in the past decade. This is the configuration that I have now for almost two years and it works!&nbsp; Nevertheless, there are some criticisms that cannot be ignored. Even if<a href="https://superuser.com/questions/489733/is-mac-os-x-a-unix-based-os"> MacOS is Unix based and POSIX compliant</a> this is no Linux. This makes a bit of difference: you cannot use <em>apt-ge</em>t but you have to rely on Homebrew instead. Small stuff that make your local config different&nbsp;from the prod systems. One can not ignore that Docker For Mac also&nbsp;<a href="https://engageinteractive.co.uk/blog/making-docker-faster-on-mac">has some serious flaws</a>. In addition, it is clear that maintaining a fleet of Macbook Pros is quite a pain: no native <a href="https://community.spiceworks.com/topic/202961-how-to-manage-mac-os-under-ad-and-group-policy">group policies </a>. For device <span style="font-weight: 400;">maintenance</span>, you have to go with Apple support etc. Finally, the cost associated with purchasing <a href="https://www.pcworld.com/article/3179677/dell-xps-15-vs-macbook-pro-15-fight.html">Macbook Pro compared to its equivalent at Dell is higher</a> (even that is not so much as it is often mentioned in discussions).

<h2>The best of all worlds? Windows 10 with WSL2?</h2>
{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/03/Ubutntu-on-Windows-10-logo-banner-300x166.jpg' caption="Ubuntu on Windows" %}

WSL stands for <a href="https://docs.microsoft.com/en-us/windows/wsl/about">Windows Subsystem for Linux</a>. At the time of&nbsp; writing its first version WSL1 is shipped on all up-to-date Windows 10 builds, to get access to WSL2 you need to register to Windows Insider Program and retrieve a preview build.

With WSL, Microsoft brought a Linux Kernel inside Windows 10.&nbsp;It can be used directly from within Windows host using a <em>bash shell</em>. In its first version, it was really useful for many small tasks,&nbsp;such as <em>sshing</em> easily from Windows (and not relying on PuTTy). Yet, <a href="https://docs.microsoft.com/en-us/windows/wsl/wsl2-ux-changes">some limitations on networking and filesystem did not make it a viable solution</a> for an everyday developer workstation setup. WSL2 is now a much more complete solution that makes usable for development (involving a full VM on top of Hyper-V that <a href="https://news.ycombinator.com/item?id=20170326">some may even see as a regression</a>).

In addition, some really important news came along. First, the popular code editor VSCode <a href="https://code.visualstudio.com/blogs/2019/09/03/wsl2#_wsl-2-and-visual-studio-code">fully supports WSL2</a> and brings extensions. Second, and&nbsp;probably more important, Docker in the latest tech preview edition of Docker Desktop let <a href="https://www.docker.com/blog/new-docker-desktop-wsl2-backend/">you use WSL2 to run the containers</a>.

If you are working on existing projects, there is a strong possibility that some (if not all) of&nbsp;your services leverage Docker. Therefore, you must have a way to run and&nbsp;access&nbsp;Docker containers&nbsp;from your new WSL2 environment.&nbsp;This was our situation at Talentoday where we rely a lot on Docker.

I&nbsp;tried to install our *Nix based Talentoday stack on Windows 10 with WSL2 and it worked like a charm.

As a big overview, at Talentoday, the applicative server services are built on top of Ruby on Rails (with jobs and queues etc.) accessing SolR indexers. We also have a cache mechanism&nbsp;on top of Redis, a PostgreSQL database and a Flask based Python WebAPI. For the developer experience, we rely a lot on Docker containers (including the database) for this various components. With the Docker Tech Preview, I had no problem building and starting my images&nbsp;and contacting them within WSL2 and accessing them from both WSL2 code and/or host Windows.

We will need some step back and see if WSL2 is the right way to go in the long run. We will have to pursue our investigation and see if there are no other problems (performance, networks etc.) that I could not&nbsp;spot during this one day trial. In all cases, this early attempt sounds extremely promising and could be a good solution for developers in teams&nbsp;who want to keep the benefit of a commonly distributed OS and a real developer experience&nbsp;leveraging&nbsp;*Nix based technologies.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/03/Capture-1-1024x576.png' caption="Talentoday stack running on WSL2" %}
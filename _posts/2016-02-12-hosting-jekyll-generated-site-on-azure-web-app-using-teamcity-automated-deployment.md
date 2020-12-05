---
layout: post
status: publish
published: true
title: Hosting Jekyll website on Azure Web app using TeamCity automated deployment
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2016-02-12 23:08:32 +0000'
date_gmt: '2016-02-12 23:08:32 +0000'
categories:
- Programming
- Continuous Integration
tags:
- ".NET"
- azure
- jekyll
- powershell
- teamcity
- git
- github
comments: []
---
The public website of my company <a href="https://keluro.com/">Keluro</a> is built with <a href="https://jekyllrb.com/">Jekyll</a>.&nbsp;If you are a Jekyll user you are probably aware of <a href="https://pages.github.com/">Github </a> pages. To me, the best feature of Github pages is the automated deployment of your website when pushing on a specific branch (namely 'gh-pages'). We hosted the website almost a year in Github pages. However, we suffer many inconveniences with it:


* <a href="https://github.com/isaacs/github/issues/156">Https is not supported by&nbsp;Github pages</a>. As Google announced, <a href="https://googlewebmastercentral.blogspot.fr/2014/08/https-as-ranking-signal.html">http over SSL is now a bonus</a> in term of rankings. At Keluro we do have a wild card SSL certificate, its a shame that we could not use it for our public corporate website!</li>
* We could not tune some server caching configuration (ETag, Cache-Control etc.), resulting on poor results from&nbsp;<a href="https://developers.google.com/speed/pagespeed/insights/">Google Page Speed Insights</a>.
* &nbsp;With Githup pages you cannot use custom advanced <a href="https://rubygems.org/">gems</a>. They are ruby extensions, which is the technology on which Jekyll is based on. I have already blogged about <a href="/2014/08/24/organize-a-multilanguage-jekyll-site/">our solution to support multi-lang</a> website. Even if it works, I am more and more thinking that a Jekyll gem would do a better job...
* We had problem with Facebook scrapping our <a href="http://ogp.me/">open graph</a> meta tags and there was nothing we could do about it: <a href="http://ramsesoriginal.info/2015/03/21/facebook-open-graph-github-pages/">see issue here</a>.
* You do not control the version of Jekyll run by Github pages. We found out that there are some <a href="https://github.com/jekyll/jekyll/issues/4203">breaking changes introduced when migrating from Jekyll 2 to Jekyll 3</a>. We do not want our website to get down because of a silent release of a new Jekyll revision.
* &nbsp;At Keluro due to our business model we are windows users. However, the server running Github pages are Linux servers, so you face the technicalities coming from switching between Linux/Windows: CRLF vs LF etc. Even if there are solutions such as .gitattribute file etc. these are extra technicalities that our non-tech teammates working on the website are&nbsp;not aware of and we do not want them to spend time on this.
* We use a <a href="https://help.github.com/articles/user-organization-and-project-pages/">project page</a> rather than a personal page, it was complicated to configure DNS names etc. There are always exception when it comes to project pages with Github pages.

For all these reasons I wanted to quit Github pages. As the CTO of Keluro, I had not a lot of time to investigate all alternatives and wanted a simple solution. We are already Bizspark member, our web apps, APIs, VMs etc. are hosted on <a href="https://azure.microsoft.com/en-gb/">Azure</a>. We are familiar with configuration of IIS server. Consequently, it was a reasonable solution to host the website on Azure&nbsp;with all our other resources. On the other hand, we already had an automated deployment solution: our continuous integration server, TeamCity, which <a href="/2015/09/21/setup-teamcity-on-windows-azure-vm-part-1-on-2/">is also hosted on Azure</a>.

The solution proposed here is then very simple. Similarly to the automated deployment provided by Github pages, we use <a href="https://www.jetbrains.com/teamcity/">TeamCity</a> to trigger changes on a given branch of the Git repository. Then, the website is built by Jekyll on the integration server virtual machine. Finally,&nbsp;it is synchronized with the Azure web app FTP using the sync library <a href="https://winscp.net/eng/download.php">WinSCP</a>. At the end, our static html pages are served using Azure Web app.

Once the TeamCity build configuration is created, you just have to write&nbsp;two Powershell build steps (see code below). You can&nbsp;also use&nbsp;two <a href="https://github.com/psake/psake">Psake </a>build targets and chain them <a href="/2014/07/08/executing-psake-build-script-with-teamcity/">as I wrote here</a>.

The prerequisite is to <a href="http://jekyllrb.com/docs/windows/">install Jekyll on the windows server</a> VM with jekyll.exe on the environment variable $PATH. You can add WinSCP.exe and .dll in a folder within your source code under the 'ignored\build' location. Make sure that 'ignored' is indeed an ignored folder by Jekyll (you do not want Jekyll to output these to your deployed _site folder).

In the TeamCity build configuration you can set up environment variable that will be consumed by the Powershell script ($env:VARNAME). It is an acceptable&nbsp;solution for avoiding hardcoding passwords, location path etc. on the sources. For example, the variable $env.RepoDir is set to %system.teamcity.build.checkoutDir%. You use such environment variable, to store ftp settings. To recover the FTP settings of an Azure Web App, see this <a href="http://stackoverflow.com/questions/22273360/connecting-to-azure-website-via-ftp">stackoverflow question</a>.

REMARK: We did not manage to redirect the WinSCP ouput of the sync logs in real time to TeamCity. We log the results when the syncing is completed. If someone has a solution we will be glad to hear it.

We tried the WinSCP powershell CMDLets but they seem heavily bugged at the time of the writing.

# Build the website with Jekyll
<script src="https://gist.github.com/bpatra/bafe9d56479e3dc86640f65bdf479a9f.js"></script>

# Sync the website with WinSCP
<script src="https://gist.github.com/bpatra/714da12b9c88fc4871d7237d05b51464.js"></script>

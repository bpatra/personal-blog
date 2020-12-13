---
layout: post
status: publish
published: true
title: TeamCity on Windows Azure VM part 2/2 - enabling SSL with reverse proxy
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2015-10-07 23:17:32 +0000'
date_gmt: '2015-10-07 21:17:32 +0000'
categories:
- Programming
- Continuous Integration
tags:
- azure
- iis
- internet information service
- sql azure
- ssl
- teamcity
- web sockets
---
In the <a href="/2015/09/21/setup-teamcity-on-windows-azure-vm-part-1-on-2/">previous post</a> we explained how to install a TeamCity server on a Windows Azure Virtual Machine. We used an external SQL Azure database for the internal database used by Teamcity. The first post ended with a functional TeamCity web app that could not be visible from outside. The objective of this second post is to show how to secure the web app by serving up the pages with SSL. Similarly as the previous post I will detailed out all the procedure from scratch so this tutorial will be accessible to an IIS beginner. Indeed, we are going to use a reverse proxy technique on IIS (Internet Information Service, the Microsoft web server).&nbsp; I would like to thank my friend Gabriel Boya&nbsp;who suggested me the reverse proxy trick. Let us remark that it could also be a good solution for serving under SSL any other non IIS website running on windows.

If you have followed the steps of the previous post, then you should have a TeamCity server that is served on port 8080. You should be able to view&nbsp;it with the IE browser under the remote desktop VM at <em>localhost:8080</em>. Let us start this post by answering the following question:

## What is a reverse proxy and why use it? 
If you try to enable SSL with Tomcat server who serves TeamCity, you are going to suffer for not a very good result. See for instance <a href="http://paulstovell.com/blog/teamcity-ssl-on-windows-with-redirect-from-http">this tutorial</a>&nbsp;and all the questions it brought. Even if you manage to import your certificate on the java certificate store, you will have problem with WebSockets...

So I suggest you to implement a reverse proxy. The name sounds complicated but it is very basic concept: this is simply another website that will act as an intermediate for communicating to your first and primary website (in our case the Tomcat server). Here, we are going to create an empty IIS website, visible from outside on port 80 and 443. It will redirect the incoming request to our TeamCity server which is listening on port 8080.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/reverseproxy1-1024x265.png' caption="Representation of the reverse proxy for our situation" %}

## Install IIS and the required components
First we will have to install and setup IIS with the following features on our Windows server 2012. It is a very easy thing to do. Search the ServerManager in windows &nbsp;then, choose to&nbsp;configure this Local Server (this Virtual Machine) &nbsp;with a Role-based installation.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/servermanager-1024x561.jpg' caption="Add roles and features" %}

Then, check the "Web Server (IIS)" as a role to install.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/servermanager1-1024x552.jpg' caption="Install IIS" %}

Keep the default feaures.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/servermanager2-1024x574.jpg' caption="Keep default installation features" %}

In this recent version, TeamCity uses the <a href="https://en.wikipedia.org/wiki/WebSocket">WebSockets</a>. To make them work, our reverse proxy server will need them: check WebSocket Protocol.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/servermanager3-1024x549.jpg' caption="Check the WebSocket Protocol" %}

Check that everything is right there... and press Install.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/servermanager4-1024x560.jpg' caption="Check that everything is prepared for installation" %}

Now that we have installed IIS with our required features (WebSocket),it is&nbsp;accessible from the menu. I suggest you pin that to the easy launch if you do not want to search it each time you will need it.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/iis-1024x274.jpg' caption="IIS well installed" %}

## Install URL rewrite module
The most simple way to set up the reverse proxy is to have the IIS URL rewrite module installed. Any Microsoft web modules should be installed using the Microsoft Web platform Installer. If you do not have it yet, install it from&nbsp;<a href="http://www.iis.net/learn/install/web-platform-installer/web-platform-installer-direct-downloads">there</a>.

Then, in the Web Platform Installer look for the URL Rewrite 2.0 and install it.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/urlrewrite-1024x596.jpg' caption="URL Rewrite 2.0 installation with Web Platform Installer" %}

## The Reverse proxy website
Ok now we are going to create our proxy website. IIS has gently created a website and its <a href="http://stackoverflow.com/questions/3868612/what-is-an-iis-application-pool">associated pool</a>. Delete them both without any mercy and create a new one (called TeamcityFrom) with the following parameters. Remark: that there is no website and nothing under the <em>C:inetpubwwwroot</em> this is just the default IIS website directory.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/teamcityfront-1024x614.jpg' caption="New TeamCityFront IIS website that point to the inetpub/wwwroot folder" %}

## Create the rewrite rule
We are going to create a rule that basically transform all incoming http request to request targeting locally <em>localhost:8080.&nbsp;</em>Open the URL rewrite menu that should be visible in the window when you click on your site and create a blank rule with the following parameters.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/inboundrule1-1024x621.jpg' caption="URL Rewrite for our TeamcityFront website" %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/inboundrule2-1024x616.jpg' caption="Second part of the rewrite rule" %}

Now let us go back to the management Azure portal and add two new endpoints http for port 80 and https for 443 in Windows Azure

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/endpoints3-e1450468424284.jpg' caption="Add HTTP on port 80 and HTTPS on port 443 with the Azure Management Portal for our VM" %}

Now check that you are able to browse your site at testteamcity.cloudapp.net from the outside. But you could object what was the point? Indeed, we could have setup TeamCity on port 80 and add the HTTP endpoint on Azure and the result would be the same. Yes you would be right, but remember, our goal is to serve securely with&nbsp;SSL!

## Enabling SSL
{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/personalpfx-e1450468449460.jpg' caption="Certificate installation" %}

To enable SSL you need to have a certificate, you can buy one at <a href="https://www.gandi.net/">Gandi.net</a> for example. When you get the .pfx file install it on your VM by double clicking and put the certificate on the personal store.

An SSL certificate is bound to a domain and you do not own cloudapp.net so you cannot use the subdomain&nbsp;te<em>stteamcity.cloudapp.net</em> of your VM. You will have to create an alias for example <em>build.keluro.com</em> and create a CNAME that will redirect to the VM.

Here is the procedure if you manage your domains in Office365.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/office365-1024x515.jpg' caption="Creating a CNAME subdomain in Office365 that point to the *.cloudapp.net address of your VM" %}

Now in IIS, click on your site and edit SSL bindings, add this newly created &nbsp;subdomain <em>build.keluro.com </em>and use the SSL certificate that should be recognized automatically by IIS.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/sslbindings-1024x599.jpg' caption="Create an HTTPS binding for the proxy server under IIS" %}

At this stage, you should be able to browse your site on https from the outside with a clean green lock sign.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/workshttps-e1450468225594.jpg' caption="Browsing in security with https" %}

## Redirection Http to Https
You do not want your user to continue accessing insecurely your web app with basic Http. So a <del>good</del> mandatory practice is to redirect your http traffic to a secure https endpoint. Once again, we will benefit from the reverse proxy on IIS. Simply create a new URL rewrite rule.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/redirecturlrewrite-899x1024.jpg' caption="An HTTP to HTTPS redirect rewrite rule" %}

Then place you HTTPS redirection rule before the ReverseProxy rule.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/urlrewrite2-1024x437.jpg' caption="Place the HTTPS redirection rule before the ReverseProxy rewrite rule" %}

Then know when you type <em>http://build.keluro.com</em> or simply <em>build.keluro.com</em> you'll be automatically redirected and the job is done!

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/10/browsinghttp-e1444251752576.jpg' caption="A working website that redirects automatically to https" %}

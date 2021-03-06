---
layout: post
title: "Debugging locally REST API webhooks with Visual Studio"
date: '2016-10-22 18:49:38 +0000'
disqus: false
categories:
- Programming
- DevTools
tags:
- ".NET"
- iis
- webhooks
---
Modern REST APIs such as <a href="https://msdn.microsoft.com/en-us/office/office365/api/notify-rest-operations">Outlook REST Api</a>, <a href="https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/webhooks">Microsoft Graph</a> or <a href="https://developers.facebook.com/docs/graph-api/webhooks">Facebook Graph</a> expose very powerful capabilities called <a href="https://en.wikipedia.org/wiki/Webhook">webhooks</a>. They allow push notifications. After subscription, when something change these API send notifications to your service by calling the URL you provided. For example, in Outlook REST API the push notification services will send a request when something has been modify in the user mailbox such as a mail received or an email marked as read.

I am not going to explain how you register subscriptions to a particular webhook. In this blog post, we provide a solution in order to be able to "break" with your Visual Studio debugger in a callback webhook you subscribed to. The approach is not windows/.NET specific, actually the mechanism exposed here is generic, but these are the tools I am using at the moment so they will serve as example in this post.

<strong>Problem:</strong> when you subscribe to a webhook you specify what would be your notification URL (see <a href="https://msdn.microsoft.com/en-us/office/office365/api/notify-rest-operations#subscribe-to-changes-in-my-mail-calendar-contacts-or-tasks">Outlook REST API example</a>). This url must be https and visible from the 'outside' internet. Therefore, you cannot set an url such as&nbsp;<em>https://localhost:44301/api/MyNotificationCallBack</em>&nbsp;where <em>https://localhost:44301</em>&nbsp;is the url of your local development website. &nbsp;However, it would be convenient in order to 'break' directly in your server side code responsible for handling the request. In addition, if you are using Visual Studio and IIS express for development you cannot simply expose a website with custom domain and SSL to the outside internet.

<strong>Solution:</strong> take a (sub)domain name you own (e.g. <em>superdebug.keluro.com</em>) then create an <a href="https://support.dnsimple.com/articles/a-record/">A record</a> to point to <a href="http://www.whatismypublicip.com/">your public IP</a>. If you are in a home network this IP is the one of your ISP box. Configure this box to redirect incoming traffic for <em>superdebug.keluro.com</em> on port 443 to your personal developer machine (still on port&nbsp;443). In your&nbsp;machine, configure an IIS web server with a binding for <em>https://superdebug.keluro.com</em> on port 443 that will act&nbsp;as reverse proxy and&nbsp;will redirect incoming traffic to your IIS Express local development server &nbsp;(e.g. <em>https://localhost:44301</em>). Finally, set a valid SSL certificate on the reverse proxy IIS server for <em>superdebug.keluro.com</em>. Now, you can now use <em>https://superdebug.keluro.com/api/MyNotificationCallBack</em> as notification Url and the routing logic will redirect incoming push notification requests to <em>https://localhost:44301/api/MyNotificationCallBack</em>&nbsp;where you can debug locally.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2016/10/drawing.jpg' caption="Debug locally IIS Express website visible from the outside internet" %}

<strong>Pitfalls:</strong>

<ul>
<li>Unfortunately, in case of home network, I cannot give precise instructions on how to configure your ISP box to reroute incoming traffic. Also make sure that the box IP does not change and is static.</li>
<li>Take care of your own Firewall rules, make sure that 443 port is open for both Inbound and Outbound rules.</li>
<li>In IIS <a href="https://www.iis.net/downloads/microsoft/application-request-routing">Application Request Routing</a> (ARR), the module that may be used for creating the reverse proxy, an option is set by default that modifies 'location' request response Headers. It may break your application that probably uses OAUTH flow. See this <a href="http://stackoverflow.com/a/29661418/1569150">stackoverflow response</a>.</li>
<li>If you never setup IIS to work as a reverse proxy. That is quite simple now with ARR or Rewrite Request modules. In this <a href="/2015/09/21/setup-teamcity-on-windows-azure-vm-part-1-on-2/">previous blog post</a> we explained how to setup a reverse proxy with IIS.</li>
</ul>

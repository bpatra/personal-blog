---
layout: post
status: publish
published: true
title: Implementing the OAUTH 2.0 flow in app for office sandboxed environment
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2015-05-28 17:15:09 +0000'
date_gmt: '2015-05-28 15:15:09 +0000'
categories:
- Programming
- Web Development
tags:
- app-for-office
- HTML5
- javascript
- OAUTH
- office365
- office-addins
---
<strong>EDIT:</strong> this approach is outdated. You can have a look at the sample we released and especially in the README section we compare the different approaches
<a href="https://github.com/Keluro/Office365-AddinWeb-SignInSample">https://github.com/Keluro/Office365-AddinWeb-SignInSample</a>

In this post I will explain how I implemented the OAUTH 2.0 flow in the app for office sandboxed environment. The objective of this post is to discuss with others if the proposed implementation is satisfactory. Do not hesitate to criticize and propose alternatives.

Following the <a title="msdn documentation" href="https://msdn.microsoft.com/en-us/library/office/jj220082.aspx">msdn documentation</a>, the app for office model is the new model for

>engaging new consumer and enterprise experiences for Office client applications.

They follow with: _Using the power of the web and standard web technologies like HTML5, XML, CSS3, JavaScript, and REST APIs, you can create apps that interact with Office documents, email messages, meeting requests, and appointments._

Personally, I find this extremely promising, I even release my first app last year: <a title="Keluro web analytics" href="http://keluro.com/webanalytics/">Keluro web analytics</a>&nbsp;that is distributed <a href="https://store.office.com/keluro-web-analytics-WA104365670.aspx">here</a> on the store.&nbsp;I even wrote a small article dealing with app for office on the <a href="http://keluro.com/programming/2014/07/29/5thingsyoushouldknowappforoffice/">Keluro web blog</a>.

Let us get straight to the point for this tech article. Apps for office aim at building connected service. For example, Keluro web analytics fetchs data from Google Analytics within MS Excel. I am working on a new project that must communicate with other <a href="https://msdn.microsoft.com/en-us/office/office365/howto/platform-development-overview">Office 365 APIs</a>. In all cases, you must use the OAUTH 2.0 flow to grant your app the right to communicate with those APIs. Sometimes there are some client libraries to leverage technicalities of the OAUTH flow. For my fist app, I used the <a href="https://developers.google.com/api-client-library/javascript/start/start-js">Google Javascript API</a> and for the second one I used the<a title="ADAL Js" href="https://github.com/AzureAD/azure-activedirectory-library-for-js"> Azure Active Directory adal.js library</a>.

However, there is problem. The apps for office run in a sandboxed environment that prevent cross domain navigation. This sandboxed environment is an iframe with sandbox attributes for the case of the office web apps. I asked the question for more information in <a href="https://social.msdn.microsoft.com/Forums/office/en-US/c0d9d148-3242-4a0c-902c-245f406f3371/what-are-the-precise-restrictions-for-the-iframe-and-the-browser-in-apps-for-office-?forum=appsforoffice">this msdn thread</a>. In all cases, the consequence is that the usual OAUTH 2.0 flow that redirects you to https://login.microsoft.com/etc. or https://apis.google.com to prompt the user for allowing access will not work. In addition, the pages served by those domains cannot be 'iframed' whether they are served to with X-Frame-Options deny or some js 'frame busting' is embedded.

I will get straight to the only working solution that I found. Actually, its the same recipe that I used for Google APIs and ADAL.

It looks like that the apps for office run with the following sandboxed attributes&nbsp;<em>sandbox="allow-scripts allow-forms allow-same-origin ms-allow-popups allow-popups".&nbsp;</em>Therefore, we are allowed to use popups and this popup is not restricted by CrossOrigin. What we will do is to open a popup and we will do the OAUTH flow in this popup, when its done we will get back the necessary information in the main app iframe. Here is a summary with a small graphic.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/05/solutionsummary-917x1024.png' caption="An overview of the solution found for the OAUTH2.0 in sandboxed env" %}

Then, you got it we will use a special callback.html file (that is basically blank and contains only javascript) as returned url. Here it its code.

<script src="https://gist.github.com/bpatra/21f481d4e1b782650ede201d4866be90.js"></script>

Then in the main iframe when it's time to start the OAUTH flow, you have a piece of javascript that looks like the following

<script src="https://gist.github.com/bpatra/f726b27e7901c415e6cfe21fc77a2689.js"></script>

I personally find this implementation not satisfactory because of the use of the popup (that may be blocked). What do you think of it ? Do you think of an alternative. I tried many things using <a title="postMessage" href="http://ejohn.org/blog/cross-window-messaging/">postMessage API</a> but it does not work with IE in sandboxed environment.

This is the implementation that is discussed in this <a title="Adal js issue" href="https://github.com/AzureAD/azure-activedirectory-library-for-js/issues/129">ADAL.js issue</a>. You may also find a setup of a sandboxed environment and some implementation attempt (without apps for office for simplicity) on <a title="sandboxed remote branch on fork" href="https://github.com/bpatra/azure-activedirectory-library-for-js/tree/sandboxed-iframe">my remote branch of my Adal.js fork</a>.


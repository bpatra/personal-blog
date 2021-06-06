---
layout: post
published: true
title: 'The story of KMailPrint, the one million PDFs app'
date: '2021-06-06 00:00:00 +0000'
featured: true
featured_image: /assets/images/posts/wordpress-to-jekyll-migration/wordpress2jekyll.jpg
image: /assets/images/posts/wordpress-to-jekyll-migration/wordpress2jekyll.jpg
featured_image_in_post: /assets/images/posts/wordpress-to-jekyll-migration/wordpress2jekyll.jpg
hidden: true
categories:
- Programming
- DevOps
- Web Development
tags:
- ".NET"
- azure
- azure static web apps
- C#
- react
- angularJS
- asp.net
comments: []
---

In 2015, I used to creating Office Addin with the traditional COM/VSTO approach and I heard about this new model to create Office Addin. These were web addins, the model was entirely different from what I used to develop. Office was about 1 billion user at that time and this promise of a market place to distribute was definitely exciting. I developped quickly to addins. The first one was an Excel add-in allowing you to sync your spreadsheet with Google Analytics data, the second one KMailPrint was a simple virtual printer for Outlook, allowing you to print in a nicely formatted PDF.

At that time the capabilities for Excel web addins were limited so I dropped the support of this former email. KMailPrint quickly found a certain tractions printing several hundred of email daily. I decided to maintain the project over the years dedicating at most few hours per years. It is 6 years old now and the counter achieve more than a milion of generated PDF, considering that there is no API and these are manual requests from end-users, far from being amazing there is definitely a certain interest. In this post I will detail, all the migrations that the project have submit to.

TODO: image illustrating KMailPrint

TODO: image of Google Analytics

TODO: image of pulse Githug


# The global architecture evolution

At first there were only one server that were handling everything. Among the main responsibilities, the server was serving the Single Page Application powering the web addin, handling the virtual printer logic and finally handling all the server side logic.

Over the years, it evolved to a most service oriented approach. The frontend is now served statically independtly of the application server or the virtual printer service.

# Evolution of the frontend

The very first version started with KnockoutJS, reusing part of my Google Analytics addin that was written with it. I decided to migrate to AngularJS. Dependencies were managed by Bower and frontend build tasks were handled by Grunt. Everything was managed with Visual Studio directly in the development solution.

I leverage the first version of the Office UI Fabric which were a kind of Design System ancestor providing reusable components for Office apps. Actually, I almost rewrote anything but there were some css classes I managed to use directly in my project.

Now the project has been almost be rewritten in React Typescript. Note that the Office Commands reuse the same classes and typescript module, yet thanks to an advanced Webpack configuration there is no dependency of React in my Addin commands. The UI is almost all made with Microsoft's new design system Fluent UI.

# Evolution of the backend

The very first backend was implemented was a C# ASP.NET MVC. Then I stripped all dynamic views rendering to make it an .NET core Web API app. It is now a .NET Core 3.1 web app. My main motivation towards migrating to .NET core was the ability to containerize application for easier hosting and maintenance. Now that I work with a Macbook for 4 years, I am glad to still be able to work with .NET which was only possible with a .NET core project.


# Evolution of the printer

In its first version, the virtual printer was a PhantomJS printer. Precisely, we use Powershell instrumentation to spawn a PhantomJS process to print the targeted HTML page. It lasted 2 years but having so many child processes in the application server was problematic. I decided to move the virtual printing logic in a dedicated Linux Virtual Machine, where a Node/ExpressJS API was handling the virtual printing still with PhantomJS.

The installation was more and more problematic and we managed to containerize with Docker the virtual printer application.

PhantomJS was known to be end-of-life for many years. In 2021, I finally decided to remove PhantomJS and rewrote the virtual printer using the Pupeeter project which leverages internally the Chrome Embedded Framework. The project lies as a containerized service whose API are still implemented in Typescript with Node and ExpressJS.


# Evolution of the infrastructure

In 2015, at the very begining the infrastructure were problematic. I was trying to leverage the first versions of Azure Web Apps. Yet this was not possible. I tried to run an ASP.NET MVC app even that was not problematic, the underlying virtual machine provided by Azure did not have the graphical libraries to perform the printing and server side rendering task. I was then forced to fallback on the Azure Cloud Services which were full Windows VM at that time.

This situation lasted, I even had a bare Ubuntu Linux virutal machine when the PDF printer was first moved to Node. Finally, the migration to .NET and the containerization of PhantomJS allowed me to move everything back to Container Azure Web App. Having work with many Docker container orchestrators (Amazon ECS, Nomad or even a lillte Kubernetes), I still believe that for a very simple and basic usage that remains probably the easiest way to host and run a couple of containers.

In addition, I followed the evolution of the Azure Blobstorage (equivalent of Amazon S3). The recent evolution allowed me to benefit from the lastest lifecycle feature, which allow the blob to self destruct after a certain period of time.

Finally, the fresh new frontend written in React is hosted in Azure Static Web Apps. I have already spoke in good favor about Azure Static Web Apps. I confirm that is really adapted to host a frontend SPA application as well.


That's it for this time traveling in the history of this small project. I encourage you to maintain your sparetime projects. Having hundreds of people using it everday was a strong motivator for me but to be frank I was tempted to let it go last year. Now that I work at iAdvize were our main technology for frontend development is React, that was a great opportunity for me to learn React with a real project with real goals.
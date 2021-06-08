---
layout: post
published: true
title: 'KMailPrint, the app celebrates a million of generated PDFs'
date: '2021-06-08 00:00:00 +0000'
featured: true
featured_image: /assets/images/posts/kmailprint-story/kmailprint-story.jpg
image: /assets/images/posts/kmailprint-story/kmailprint-story.jpg
featured_image_in_post: /assets/images/posts/kmailprint-story/kmailprint-story.jpg
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
- javascript
- office-addins
- asp.net
comments: []
---
In 2012 while working at [eFront](https://www.efront.com/), I was in charge of the development of some Microsoft Office addin projects. At that time, we leveraged the [COM/VSTO](https://stackoverflow.com/questions/9011814/what-is-the-difference-between-a-com-add-in-and-a-vsto-add-in) technologies to craft these extensions. The next year, I heard about this new generation of [Office Addins](https://docs.microsoft.com/en-us/office/dev/add-ins/overview/office-add-ins). They were actually web addins, the model was entirely different from what I used to develop. In those days Office was about 1 billion users and the promise of a marketplace to distribute to so many business and individual users was definitely exciting. I developed quickly my first addin to see what were the capacities of this new technology. This first one was an Excel add-in allowing you to sync your spreadsheet with Google Analytics data. In 2015, I bootstrapped a second one: [KMailPrint](https://appsource.microsoft.com/en-us/product/office/WA104379552). It is actually a simple virtual printer for Outlook emails. In few words, it allows you to transform an email into a nicely formatted PDF, far better from what you can do with Outlook Desktop or with the virtual printer of your browser. I thought that this project was not really worth a post on this blog, I never wrote about it. Now I believe that making a short retrospective about its evolutions over the years could actually be of some interest.

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/screenshot-addin-commands.jpg' caption="The KMailPrint Outlook addin loads in a task pane. It also can trigger command calls from a contextual menu directly in the reading pane of the email." position_class="image-center" size_class="small" %}

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/screenshot-addin-settings.jpg' caption="The KMailPrint addin lets you access a series of advanced settings such as: paper format, date format, including CC: etc." position_class="image-center" size_class="small" %}

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/screenshot-addin-printed.jpg' caption="The resulting is a nicely formatted PDF, rendering well embedded images with a formatted header." position_class="image-center" size_class="small" %}

At the beginning, the capabilities of Excel addins were really limited so I dropped my first Excel addin. Yet KMailPrint found a certain traction, seeing the printing count reach several hundred of emails daily. Noticing that it was actually helping people, I decided to maintain the project over the years, dedicating at most few hours per year to it. Now it is a 6-year-old project and the total counter reaches roughly a million of generated PDFs. There is no API and these are all manual triggers from end-users. Far from being amazing, there is definitely a certain interest so I think the project is worth the maintenance. In this post I will detail all the major engineering evolutions that the project has seen.

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/kmailprint-google-analytics.jpg' caption="KMailPrint traction was at its peek in 2018, now the usage is in decline. I do not exactly know why but I am still maintaining this project that is helping people on a daily basis." position_class="image-center" size_class="medium" %}

# The global architecture evolution

At first there was only one _monolithic_ server responsible to handle everything. Among the main responsibilities, it was serving the Single Page Application powering the web addin, handling the virtual printer logic and finally handling all the server-side logic that is mainly [Exchange Web Services](https://docs.microsoft.com/en-us/exchange/client-developer/exchange-web-services/explore-the-ews-managed-api-ews-and-web-services-in-exchange) processing.

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/kmailprint-architecture.png' caption="KMailPrint started with a monolithic server approach where many responsibilities were handled by the same codebase." position_class="image-center" size_class="medium" %}

Over the years, this monolith gave birth to a more service oriented approach. The frontend is now served statically and independently of the application server or the virtual printer service.

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/kmailprint-architecture-services.png' caption="From a monolithic server approach, I quickly saw the need to split responsibilities, especially for the virtual printer." position_class="image-center" size_class="medium" %}

# Evolution of the frontend

The very first version started with [KnockoutJS](https://knockoutjs.com/), reusing portions of my Excel/Google Analytics addin that was written with it. Quickly after, I decided to rewrite with [AngularJS](https://angularjs.org/). When it comes to the tooling, the dependencies were managed by [Bower](https://bower.io/) and frontend build tasks were automated by [Grunt](https://gruntjs.com/). Everything was handled with Visual Studio directly in the development solution. The developer experience was actually pretty nice for a web based project at that time.

About the UI, of course it started with [Bootstrap](https://getbootstrap.com/) then, it leveraged the first version of the [Office UI Fabric](https://github.com/OfficeDev/office-ui-fabric-core). It was a kind of design system ancestor providing reusable components for Office apps.

Now the frontend project has been almost be rewritten in [React](https://reactjs.org/) and [Typescript](https://www.typescriptlang.org/). The UI is entirely made with Microsoft's new design system: [Fluent UI](https://developer.microsoft.com/en-us/fluentui#/).

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/evolution-frontend.png' caption="The KMailPrint frontend has follow the usual transformation of a typical web app over the years. I was tempted to rewrite it with my favorite SPA framework Vue.Js. However, I seized the opportunity to learn React while migrating KMailPrint because it is the frontend technology used by iAdvize, where I work now." position_class="image-center" size_class="large" %}

# Evolution of the backend

The very first backend was implemented as a C# [ASP.NET MVC](https://dotnet.microsoft.com/apps/aspnet/mvc) using the .NET Framework 4.5. Then I stripped all dynamic views rendering to transform it into a real [.NET Core](https://en.wikipedia.org/wiki/.NET_Core) Web API. Now it uses the latest .NET Core 3.1 version. To be honest, my main motivation by migrating to .NET Core was the ability to deploy as a containerized application for easier hosting and maintenance. Now that I work with a MacBook, I am glad to be able to work natively with C#/.NET, something that was not possible 6 years ago.

# Evolution of the printer

In its first version, the virtual printer used an underlying engine made with a [PhantomJS](https://phantomjs.org/) headless browser. Precisely, I used [Powershell instrumentation](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-7.1) techniques to manage the PhantomJS processes responsible for printing the targeted HTML content. It lasted 2 years but having so many child processes in the application server was problematic. I decided to switch to a [Node/ExpressJS](https://expressjs.com/) REST API service, handling the virtual printing, the underlying engine remained backed by PhantomJS.

The installation was more and more problematic and I performed a migration to Docker for the virtual printer service.

PhantomJS was known to be end-of-life for many years. In 2021, I finally decided to drop my legacy PhantomJS Docker images (that I could not build anymore) and rewrote the virtual printer with ExpressJS and [Puppeteer](https://pptr.dev/). This later project is based on the [Chromium Embedded Framework](https://en.wikipedia.org/wiki/Chromium_Embedded_Framework). My virtual printer Express project is now a containerized REST API service implemented in Typescript with Node and [ExpressJS](https://expressjs.com/).

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/evolution-backend.png' caption="The KMailPrint backend evolution followed the segregation of concerns and the creation of dedicated services. The C# application is actually almost now reduced to managing API calls to the virtual printer service and to the EWS API." position_class="image-center" size_class="large" %}

# Evolution of the infrastructure

In 2015 at the very beginning, the infrastructure constraints were problematic. I attempted to leverage the first versions of [Azure App Services](https://en.wikipedia.org/wiki/Azure_Web_Apps). That was not possible: the OS exposed by the underlying Azure VM did not have the necessary graphic libraries to perform the [rasterizing](https://en.wikipedia.org/wiki/Rasterisation) tasks required to the virtual impression. I was forced to fallback to a more heavy solution using the [Azure Cloud Services](https://azure.microsoft.com/en-au/services/cloud-services/) which were powered with a full capacity Windows VM.

This situation lasted for a couple of years, I even had a bare Ubuntu Linux virtual machine when the PDF printer was first migrated to Node. Finally, the migration to .NET Core and the containerization of the PhantomJS-based app allowed me to move everything back to [Container Azure Web App](https://azure.microsoft.com/en-us/services/app-service/containers/). Having work with many Docker orchestration services (Amazon ECS, Nomad or even a little of Kubernetes), I believe that for a basic usage such as the one exposed here, it remains one of the easiest ways to run a couple of containers on the cloud.

In addition, I followed the evolution of the Azure [BlobStorage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) (equivalent of Amazon S3). The recent evolution allowed me to benefit from the latest blob lifecycle management features.

Finally, the fresh new static frontend written in React is hosted with [Azure Static Web Apps](https://azure.microsoft.com/en-us/services/app-service/static/). I have already [spoke in good favor about Azure Static Web Apps]({{ site.baseurl }}/2020/12/27/i-migrated-away-from-wordpress-to-jekyll-hosted-on-azure-static-web-apps/). I confirm that it is really well adapted for hosting a frontend SPA application as well. The Github actions are also good friends to integrate quickly a CI workflow.

Infrastructure costs are limited, because KMailPrint does not expose any external APIs the number of requests is fairly limited. I manage to host all my containers on top of an [A1 Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes) costing less than a couples of dollars per month.

{% include image-caption.html imageurl='/assets/images/posts/kmailprint-story/evolution-infra.png' caption="The schema exposes the timeline evolution of the KMailPrint infrastructure. It leverages mostly Azure technologies." position_class="image-center" size_class="large" %}

That's it for the time traveling in the history of this small project. I encourage you to maintain your side projects, even the small ones: one day you will be proud of the work accomplished. Having hundreds of people using it everyday was a strong motivator for me. To be frank, I was tempted to let it go last year. Now that I work at iAdvize where our main technology for frontend development is React, KMailPrint was a great opportunity for me to learn React with a real project in my hands.
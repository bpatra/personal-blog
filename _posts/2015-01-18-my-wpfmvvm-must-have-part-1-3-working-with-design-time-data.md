---
layout: post
status: publish
published: true
title: My WPF/MVVM "must have" part 1/ 3 - working with design time data
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2015-01-18 17:23:06 +0000'
date_gmt: '2015-01-18 16:23:06 +0000'
categories:
- Programming
- MVVM
tags:
- C#
- Design
- MVVM
- WPF
- XAML
---
This is the first post of a series in three parts where I will discuss what are the "must have" of any of my WPF/MVVM projects. This one is about dealing with design time data with the framework <a title="MVVM light" href="http://www.mvvmlight.net/">MVVM light.</a>&nbsp;The&nbsp;sample project of this post can be found <a href="https://github.com/bpatra/DesignableMVVMSample">here on my github</a>.

When we speak of design time data in a WPF project, we refer to the data that will be visible in the Visual Studio designer. In the picture below the data displayed have no reason to be related to production or any testing dataset. They serve <strong>the only purpose of designing your app</strong>. It is important to be aware that the Visual Studio designer is extremely powerful and is able to execute some of the .NET code of your app. I have noticed also that the VS WPF designer have improved a lot with VS 2012.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/01/visualstudiodesigner1-1024x439.jpg' title="Visual Studio 2013 designer" caption="Visual Studio 2013 designer" %}

<em><strong>Why having design time data is ABSOLUTELY mandatory?</strong></em>
First, some controls do not need data to be designed. Take a <em>Button</em> for example, its <em>Content</em> (the label) is probably static then you will not have any troubles designing it. On the contrary, if you take the <em>DataGrid </em>in the screenshot above, the rows are dynamic data so you won't be able to see some lines in your VS designer unless you specify some design time data.

Now let me tell you a story. I learnt WPF because I was affected to an Excel addin project that had been started two years before. The screens had been developed using WPF but without any pattern, only (spaghetti) code behind. In addition to the fact that nothing was testable and the business logic was tightly coupled to the presentation, there was no design time data for the WPF screens. Sometimes, in order to view the effect of a single border color modification, the developer had to start the addin, connect some web services, fetch (potentially large) data etc... All of this was <strong>dramatic in terms of efficiency</strong>. A complete reskin of the application was not even thinkable.&nbsp;Let me conclude this argumentation by saying that some data are <strong>not easily produced with a test dataset</strong>. For example, if you have a <em>Textblock</em> displaying a path on your hardrive. You would like to see if it is still ok if this path becomes very long. If you do not have design time data, you will have to create such a deep folder hierarchy in your drive, only to see the behavior of your <em>TextBlock </em> control style. This is a pity, using design time data, you may insert any string in the control in less than a second.

<strong><em>How do you do that in practice with&nbsp;an MVVM project?</em></strong>
We are going to take a very simple sample project (that can be found <a href="https://github.com/bpatra/DesignableMVVMSample">here</a>). This application is a window with two tabs to display some information about book authors. You can select the author with a <em>Combobox</em>. On the first tab, there is basic information about the author while on the second tab there is the list of the books written by this author. Implementing this with MVVM: you will have three views (.xaml files): one the main window, two for the tabs.

<a href="/assets/images/legacy-wp-content/2015/01/application.jpg"><img class="aligncenter wp-image-704 size-medium" src="/assets/images/legacy-wp-content/2015/01/application.jpg?w=300" alt="Sample book application" width="300" height="163" /></a>

In my WPF apps, all view models are specified through interfaces. Then, for the sample project, we have the three following interfaces: <em>IMainViewModel</em>, <em>ISummaryTabViewModel </em>and <em>IBooksWrittenTabViewModel</em>.
<em>ISummaryTabViewModel </em>and <em>IBooksWrittenTabViewModel </em>are "sub view models". Naturally, they are exposed as member of the <em>IMainViewModel</em>.

<script src="https://gist.github.com/bpatra/af220475e6b720ea538a879ad234053f.js"></script>

<strong>For each view model there are two implementations: </strong>the production implementation and the design implementation. I like to separate in another namespace the design time implementations to avoid "solution explorer visual pollution".

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/01/solutionexplorer.jpg'  caption="Visual Studio Solution Explorer with Design ViewModels" %}


We use a <em>ViewModelLocator</em> so that the views can find the appropriate implementation of the view model interface. Typically, the <em>ViewModelLocator</em> exposes a static property for the "top" rooted view model.

<script src="https://gist.github.com/bpatra/04c72218ac3325ba8fb0519deffc9c96.js"></script>

In the sample above, I kept the IoC Ninject container (the <em>_kernel </em>field). You may ignore this but the <em>ViewModelLocator</em> is the composition root of the application, this is where an IoC Container should be used, <a href="http://msdn.microsoft.com/en-us/magazine/jj991965.aspx">see this post for more information</a>.

All the magic lies in the if statement <em>ViewModelBase.IsInDesignModeStatic</em> which is provided by the amazing <a href="http://www.mvvmlight.net/">MVVM Light Framework</a> developed by Laurent Bugnion. It will detect if the call to the <em>ViewModelLocator</em> comes from the Visual Studio Designer or if the application is truly running.

If you create a multi lang app with the approach detailed in <a href="/2014/11/30/string-localization-for-xaml-and-c-using-dynamically-implemented-interface/">one of my previous posts</a> you can change within the <em>if(ViewModelBase.IsInDesignModeStatic)</em> scope the <em>CurrentUICulture</em> to design and see your app with any supported languages.

Now the <em>ViewModelLocator</em> is manipulated in the views as follows
In MainWindow.xaml

<script src="https://gist.github.com/bpatra/13f8c814ffa256e9c3ff36e5274da5ba.js"></script>

In SummaryTabControl.xaml the control <em>DataContext</em> is bound to the <em>SummaryTabViewModel</em> property of the <em>IMainViewModel</em>.

<script src="https://gist.github.com/bpatra/f27f125e87be9eaaf666e224fa6fd3aa.js"></script>

The <em>Locator</em> resource has been declared in the App.xaml

<script src="https://gist.github.com/bpatra/0a50da6367b3a3440c89a653bb35dbd2.js"></script>

Let us have a look at the <em>DesignMainViewModel</em> class

<script src="https://gist.github.com/bpatra/98227b2a4de6eb75c5045ba7e6e4b92d.js"></script>

and the <em>SummaryTabViewModel</em> class

<script src="https://gist.github.com/bpatra/bf8030ce120e9896182fc378a1b6e25d.js"></script>

When implementing the "Design" view models it is important to avoid implementing any business logic. If the fake data are incoherent between the several view models design implementations that should not trouble you either. To conclude, in a real app, you will probably have to create design implementation not only for the view models but also for the objects used in data bindings (e.g. the interface IBook).

This is the end of the first part of the WPF/MVVM "must have" series. The second article will deal with the organization of the unit tests of an MVVM application.


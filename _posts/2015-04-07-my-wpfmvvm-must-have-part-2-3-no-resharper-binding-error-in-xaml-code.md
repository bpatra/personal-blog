---
layout: post
status: publish
published: true
title: My WPF/MVVM "must have" part 2/ 3 - No Resharper binding error in XAML code
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 752
wordpress_url: http://benoitpatra.com/?p=752
date: '2015-04-07 13:02:58 +0000'
date_gmt: '2015-04-07 11:02:58 +0000'
categories:
- Programming
- MVVM
tags:
- ".NET"
- C#
- MVVM
- resharper
- XAML
---
This second post of&nbsp;the "WPF must have" series deals with Resharper and its ability to find binding errors in XAML.

<a title="Resharper" href="https://www.jetbrains.com/resharper/">Resharper</a> is a well known Visual Studio plugin used by many.NET developers. It's a great productivity tool developed by <a title="Jetbrains" href="http://jetbrains.com">Jetbrains</a>. Even if Resharper (abbreviated in R#) handles javascript and other languages such as VB.NET, I would say that R# is&nbsp;a must when it comes to C#. In addition, we will see in this post that it is also really adapted&nbsp;to XAML editing.

If you have followed <a title="My WPF/MVVM &ldquo;must have&rdquo; part 1/ 3 &ndash; working with design time data" href="/2015/01/18/my-wpfmvvm-must-have-part-1-3-working-with-design-time-data/">my previous post regarding WPF and MVVM</a>, you saw&nbsp;that the ViewModels (VMs), consumed by the Views (composed essentially of XAML code), are proposed by ViewModel locators, for top level VM, or by ViewModel properties. In all cases, we always manipulate the VMs through&nbsp;<a href="https://msdn.microsoft.com/en-us/library/ms173156.aspx">C# interfaces</a>. This has two major&nbsp;advantages, the first one being the ability to work with&nbsp;design time data (see the <a title="My WPF/MVVM &ldquo;must have&rdquo; part 1/ 3 &ndash; working with design time data" href="/2015/01/18/my-wpfmvvm-must-have-part-1-3-working-with-design-time-data/">first post of the series</a>) and, the second one, to leverage unit testing (this will be the topic of the third post of the series). In addition, specifying the <em>DataContext</em> (i.e. the ViewModel) of a given view through an interface is particularly well adapted to&nbsp;R#&nbsp;usage in XAML.

Let us have a look at the MainWindow.xaml designer and its XAML source taken from my usual sample application <a title="DesignableMVVMSample" href="https://github.com/bpatra/DesignableMVVMSample">DesignableMVVMSample</a>. The vertical bar next to the XAML code is the R#'s warning/error notification zone. <strong>My recommendation is to keep the error count to zero so that the XAML file status stays always to full green (no warning, no error).</strong>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/04/nozeroerrorinbindingsedited-1024x481.jpg' caption="Zero error in R# warning and error bar" %}

The extremely cool feature is that you will benefit from an extension of Visual Studio's&nbsp;intellisense provided by R#. The interface <em>IMainViewModel</em> exposes a property called <em>AvailablePersons</em>. See in the picture below: all the properties of the ViewModel's interface (<em>AvailablePersons</em> and <em>BooksWrittenTabViewModel</em>) are now proposed in bold, to distinguish them from the <em>UserControl's</em> Dependency Properties.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/04/itellisensinbinding-e1450469479908.jpg'  caption="R# augmented Intellisense provides ViewModel members for DataBinding." %}

In addition, this works very well&nbsp;with the strongly typed translation mechanism that I presented in <a title="String localization for XAML and C# using dynamically implemented interface" href="/2014/11/30/string-localization-for-xaml-and-c-using-dynamically-implemented-interface/">this previous post</a>. Remark&nbsp;that all available translations are now proposed by R# and if you try to use a non translated string you will get a binding error.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/04/errorwithbinding.jpg'  caption="Error with translations bindings" %}

As usual with <a href="https://www.jetbrains.com/resharper/webhelp80/Configuring_ReSharper__Sharing_Configuration_Options.html">Resharper options</a>, you can disable them at several level: team level, solution level etc. , but more importantly, you can ignore them just once. Indeed, sometimes R# gets wrong and you may want to disable the warning/error. When you click the error you have the&nbsp;possibility to do this&nbsp;by adding the following comment in XAML.&nbsp;<em><!-- ReSharper disable once Xaml.BindingWithContextNotResolved -->. </em><strong>Obviously, this should be exceptional, if you use this too often there is something suspicious in your code.</strong>

Let us finish by one tip. R# can&nbsp;detect binding error with "sub datacontext", however, &nbsp;within a <em>DataTemplate</em>, Resharper is not always able to recognize well the <em>DataContext</em> type and will raise binding errors where there are none. The trick to avoid such errors is to "force" the DataType in the DataTemplate, see the sample below.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/04/datatypeforced.jpg'  caption="When the DataType is specified within DataTemplate, you can continue to use R# intelisense" %}

When&nbsp;developing our product <a title="KAssistant" href="http://kassistant.com">KAssistant</a>, a legal management software fully integrated within MSOutlook, my associate Gr&eacute;goire who is not a C# expert, was handling most of the work regarding the design and the views in XAML. Early binding errors detected by Resharper was of a great help and saved us a lot of precious time to focus more on the features of our product.


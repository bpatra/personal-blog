---
layout: post
title: A generic version of ICollectionView used in a MVVM searchable list
date: '2014-10-12 16:54:13 +0000'
categories:
- Programming
- MVVM
tags:
- ".NET"
- C#
- MVVM
- resharper
- Unit Testing
- WPF
- XAML
---
In this post we&nbsp;will describe how to create a searchable list with&nbsp;<a href="http://en.wikipedia.org/wiki/Windows_Presentation_Foundation">WPF</a> following <a href="http://en.wikipedia.org/wiki/Model_View_ViewModel">MVVM </a>principles.&nbsp;To this aim we will use a WPF <em>ListView</em> to display the searched items and a <em>TextBox</em> to enter the text used for the search. Most of the implementation that you will find on the web (e.g. <a href="http://stackoverflow.com/questions/15473048/create-a-textboxsearch-to-filter-from-listview-wpf">this one)</a> will recommend you to bind your <em>ListView</em> to an <em>ICollectionView</em>. However, this is not 100% satisfactory&nbsp;as long as <em>ICollectionView</em> does not have a built-in generic version.&nbsp;Consequently&nbsp;the ViewModel's member exposing the binding items&nbsp;will return&nbsp;an&nbsp;<em>ICollectionView</em> which is a&nbsp;powerful object (see <a href="http://marlongrech.wordpress.com/2008/11/22/icollectionview-explained/">this for instance</a>)&nbsp;&nbsp;but is "only"&nbsp;an enumeration of&nbsp;<em>System.Object</em>. In this post we will show you that a generic version can be easily implemented and exposed by your ViewModel.

In this post we will create a very simple app that let you search a player in the list of all the players of the last Football World Cup in Brazil. The complete source code can be found on&nbsp;<a href="https://github.com/bpatra/MvvMSample">my Github here.</a>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/10/listview.jpg' caption="Searching 'dav' in the ListView display a list of results starting with ex Chelsea's player David Luis..." %}

The key ingredients of such implementation is very simple in MVVM. First take the View which&nbsp;does not need more than the few lines of xaml below.

<script src="https://gist.github.com/bpatra/6c1231218fd0afd758d3ab8e931e39b5.js"></script>

Let us start by exposing the non-generic version: the <em>DataContext</em> of the control above is bound to an instance of an implementation of the interface <em>IPlayerSearchViewModel</em> below.

<script src="https://gist.github.com/bpatra/43743ef80f688107af83691766df5bcd.js"></script>

A very straightforward implementation that works is the following one.

<script src="https://gist.github.com/bpatra/2d9448dc2b136b052262adbc2b58f73e.js"></script>

As I said in the introduction, this is quite enoying. You may want to create screens with many <em>ICollectionView</em> bindings that may contain different types, then it is becoming error prone and we are loosing the benefit of C#'s type safety. The unit test example below is showing you that the elements need to be casted while they are accessed from the <em>ICollectionView</em>.

<script src="https://gist.github.com/bpatra/3bc98ea153ecd3110e8f299cb02e4e11.js"></script>

In addition we cannot use anymore the XAML validation and intellisense provided by Resharper.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/10/resharpercomplaining-1024x195.jpg' caption="Resharper complaining because of the unknown's member of the DataContext (typed as object)" %}

Fortunately we can create our generic version of <em>ICollectionView</em> and get back to the comfortable world of type safety. In this example, I will only provide the generic enumeration and the generic version for the <em>SourceCollection</em> member but you can add others. Indeed, you may create a generic version of the <em>Filter</em> predicate to avoid dealing with <em>System.Object</em> in your lambdas but with your generic type <em>T</em> instead.

<script src="https://gist.github.com/bpatra/264d432133e244af843933778fc6bea4.js"></script>

Actually, the implementation of the <em>ICollectionView</em> is really easy as long as you already have the non-generic instance at hand <em>ICollectionView</em>

<script src="https://gist.github.com/bpatra/d76477ab67cfa678f128a75f13e23c65.js"></script>

Therefore the implementation of the the ViewModel becomes cleaner and statically typed. First the new version of the ViewModel interface.

<script src="https://gist.github.com/bpatra/2f9a4ea2b2dba1c56362d7803758857c.js"></script>

Then, the implementation.

<script src="https://gist.github.com/bpatra/3cbd2739d735b1dc936c8ffba566de47.js"></script>

You do not have to cast or worry anymore on the the type of the objects contained in you <em>ICollectionView</em>. You will also detect binding errors statically with Resharper.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/10/resharperclever-e1450469370983.png' caption="Resharper handles typed generic collections in databinding" %}

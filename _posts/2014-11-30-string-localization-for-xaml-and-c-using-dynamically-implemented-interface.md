---
layout: post
status: publish
published: true
title: String localization for XAML and C# using dynamically implemented interface
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2014-11-30 11:51:19 +0000'
date_gmt: '2014-11-30 10:51:19 +0000'
categories:
- Programming
tags:
- C#
- Localization
- MSIL
- resharper
- Unit Testing
- WPF
- XAML
---
In this post I will describe a solution for easy localized strings management in XAML or C#. Precisely, we will use the usual recommended material for manipulating localized strings in .NET: resx files and the <a href="http://msdn.microsoft.com/en-us/library/system.resources.resourcemanager%28v=vs.110%29.aspx">ResourceManager</a> class. However, for XAML manipulation, we will add a "type layer" on top of this. We will see that having typed resources can be very useful. The "type layer" is basically an interface where string properties contain the localized strings, then in XAML or C# code the translations are accessed by using directly these properties. To avoid painful repetitions, the implementation of the interface is dynamically generated using some very simple <a href="http://en.wikipedia.org/wiki/Common_Intermediate_Language">MSIL</a>. 

To conclude, we will write simple unit tests that check that the translation files (.resx) contains all the localized strings for all supported languages.

First, let us recall that it is really important that your localized strings are not dispersed in the source code of your application. Using a code snippet of the following form is a bad practice.

<script src="https://gist.github.com/bpatra/645b32770cc5ba466b5059ab247dac89.js"></script>

Indeed, it is very important that you keep grouped all the translations for a given language in one file. Then, you could rework your translations on your own or with a professional without having to grep the entire code base.

Fortunately, .NET comes with all the material you need to handle Culture-Specific resources with the <a href="http://msdn.microsoft.com/en-us/library/system.resources.resourcemanager%28v=vs.110%29.aspx">ResourceManager</a>. Say you support english (default) and french languages then you have two .resx files which contains key/value string entries. Such files are named <em>LocalizedStrings.resx</em> and <em>LocalizedStrings.fr-FR.resx</em> they may contain, among others, the entry <em>SayHello</em> ("Hello!" in english and "Bonjour !" in french). Finally, you only have to initialize the <em>ResourceManager</em> and getting the localized strings as follows.

<script src="https://gist.github.com/bpatra/8b1e52a6528c30a964618530cddcab10.js"></script>

It is important to note that the right file (<em>*.resx</em> or <em>*.fr-FR.resx</em>) is automatically chosen using the <em>Tread.CurrentThread.CurrentUICulture</em>.

When manipulating XAML for the UI of your app, creating a type for the localized string is recommended. Indeed, in XAML you can bind to properties but you cannot (at least not easily) bind to methods. So the <a href="http://msdn.microsoft.com/en-us/library/dd882554%28VS.95%29.aspx">recommended method from the MSDN</a> is to create a LocalizedStrings class whose members are the localized strings.

So we can create the LocalizedStrings class

<script src="https://gist.github.com/bpatra/b966b101cc41713a5e123699e2d54196.js"></script>

While the instance is retrieved using a Singleton-like pattern (there is no reason to mock this for testing so it makes sense to use a singleton here).

<script src="https://gist.github.com/bpatra/62bffb72829342ab1a69a6096fc14c2e.js"></script>

We can use easily the LocalizedStrings in the xaml after adding the StringLocalizer has an application resource.

<script src="https://gist.github.com/bpatra/2c5ba54ac00b82ff74bc67be79472026.js"></script>

Obviously we can use the same class in the plain old C#
<script src="https://gist.github.com/bpatra/c5bb3d1460f08a787026b7deb8a97d9b.js"></script>

Using this "type layer" is not only mandatory for XAML it is also very useful because we benefit from the static typing. Indeed, typing help us to create localized strings list that do not contain tons on unused entries. Even if this is not a matter of life or death, it is a good thing to remove unused localized strings from your dictionaries, because they going to cost you some effort or money when you will make new languages available or if you want to review the terminology used in your application. The only thing you have to do is to search for unused member of the class (the plugin <a href="https://www.jetbrains.com/resharper/">Resharper</a> does this well even in XAML).

As shown in the image below the XAML-intellisense of Resharper shows us all members of the interface which is handy to reuse localized strings.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/11/resharperlistofusedentries.jpg' title="The plugins resharper shows all properties of the LocalizedStrings class" caption="The plugins resharper shows all properties of the LocalizedStrings class" %}

Still there is one thing which is cumbersome, every-time you create a new entry you have to type the same logic for the property: <em>_rem.GetString("NameOfTheProperty")</em>. Then, it's time to be nerdy and find a way to do this automatically! Let us replace the <em>LocalizedStrings</em> class by and interface <em>ILocalizedStrings </em> whose implementation is dynamically generated. You can emit dynamically new type in .NET using the ILGenerator. So this is the implementation of the new <em>StringLocalizer</em> with some help from the .NET IL guru <a href="http://olivierguimbal.name/">Olivier Guimbal</a>.

So here it is what the interface looks like

<script src="https://gist.github.com/bpatra/f61b4304a2a5f17f5dd0833574a107d0.js"></script>

And here is the StringLocalizer

<script src="https://gist.github.com/bpatra/d9afa9be95d0417cee963fba04cbb48b.js"></script>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/11/failingtest.png' title="Tests are failing because there are some unused entries in the resx." caption="Tests are failing because there are some unused entries in the resx." %}

To conclude let us write unit tests to ensure that all properties in the interface <em>ILocalizedStrings</em> are defined on all .resx files and, reciprocally, to make sure that all keys in the resx files are properties of the interface. This will help us to track non translated entries and to remove useless keys in the resx dictionaries. We basically parse the .resx files to retrieve all keys and use reflexion to get all public properties of the interface. The test fail when problematic entries are discovered and printed in the test console.

<script src="https://gist.github.com/bpatra/2f3a188a80d4dc3d4c0ef0a0db3fb321.js"></script>


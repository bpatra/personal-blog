---
layout: post
status: publish
published: true
title: F#-ception, wtf ?!?
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2013-07-30 20:33:07 +0000'
date_gmt: '2013-07-30 18:33:07 +0000'
categories:
- Programming
- Algorithms
- Functional Programming
tags:
- coding for fun
- F#
- powershell
- functional programming
comments: []
---

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/07/220px-inception_ver3.jpg' title="F#-ception!" position_class="image-right" %}

Hi, its middle of summer so let us relax with a "coding for fun" post. The subject presented here came from a kind of "wtf contest" that we had with a colleague of mine on our free time. The objective was to write&nbsp;a unit test to tackle an existing code base using the weirdest approach. My contestant Gabriel is a brilliant developer, so in order to compete with him I had to bring something really absurd rather than technically sophisticated. So I came with the idea of executing F# code inlined in a powershell script invoked from F# code. Obviously, this is absolutely useless. However, it fitted well for the thematic of the &nbsp;contest. In this post we&nbsp;will skip the "existing code base" part&nbsp;and focus on how to achieve this with a very simple example .

The first part of the job is to write some F# code that builds the powershell script with inlined F#. We will have to reference the F# code dom provider which can be downloaded&nbsp;<a title="here" href="http://fsharppowerpack.codeplex.com/">here</a>. Remark that for the sake of simplicity of this post we did not add any extra assemblies (see&nbsp;<em>referencedAssemblies</em> in script below).

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6098558.js' %}

Then let us try the&nbsp;<em>FsToPs</em> function with very simple case

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6098579.js' %}

Thus, the powershell code in <em>simpleExample.ps1</em> looks like

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6098589.js' %}

You should be able to run this script in a powershell session. However, it is not finished for us, we have to invoke this script in F# and retrieve the returned value. The following snippet will do the job for us.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6098637.js' %}

Then executed within MsTest framework....

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6098656.js' %}

...it works!


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/07/testpassed.jpg' caption="The run is successful" size_class="small" %}

I'd like to thank Gabriel for being fair play by helping me to debug the first version of F#-ception.
---
layout: post
status: publish
published: true
title: A git practical class
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2013-12-01 18:26:23 +0000'
date_gmt: '2013-12-01 17:26:23 +0000'
categories:
- Programming
- DevTools
tags:
- git
- learning
- github
comments: []
---

Since 2010, I teach C++&nbsp; about 25 hours per year at <a href="http://www.ensae.fr/">ENSAE</a>&nbsp;engineering school. During a short period we have to teach the students, with few computer science background, the complex concept of C++ (pointers, dynamic memory management, virtuality, templates etc.). The objective is to give them the basic material to be autonomous while they will be building their own C++ project during the second semester. This year we decided to sacrifice a little part of the core C++ teaching to have one lesson and a practical class dedicated to source control. Indeed, we have seen too many students struggling with sharing code on USB drives or via emails. Moreover, we do believe that this is something that a student should know before getting into&nbsp;any&nbsp;professional life involving code. To my point of view, source control is entirely a part of the software development process and could not be avoided anymore.

<a href="https://github.com/bpatra/tpgit/blob/master/TPGit.pdf?raw=true">The link to the practical (pdf)</a>

The source control that we decided to retain is git. Even if we do believe that SVN would suffice for the quite small project of our students. We think that git is the future in term of source control and git is much more powerful than SVN so, why have less when you can have more?

I publish this practical because it may be useful to others. Note that this practical is not a tutorial and it does not aim at being a git manual either. I think that their is plenty of very good documentation on the net starting by the famous <a href="http://git-scm.com/book">ProGit</a> by Scott Chacon. This practical is more about <em>how do you work with git in a real life?</em>&nbsp;It should be followed by a pair of student but you can do it alone if you manage split your brain in two.

It starts by forking an existing dummy C++ project on my personal <a href="https://github.com/bpatra">github</a>. After that, the two students are supposed to make some modifications (adding dummy classes, commenting code etc.) and share the work on their github using the most common git commands (add, commit, merge, fetch, push, pull). We examine at the end some more advanced features: blame, interactive rebasing etc.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/11/gitextensions.jpg' caption="The main window of GitExtensions" size_class="small" %}

Contrary to many practical that you may find on the web, this practical encourage the students to use&nbsp;<a href="https://code.google.com/p/gitextensions/">GitExtensions</a>.&nbsp;However, some tasks should be executed through the command line. I decided to promote GitExtensions because our students, for their great majority, are not computer geeks. They are not really friendly to the command line especially on windows (ENSAE computers have Win7 OS), so giving them&nbsp; a "command line only" tool would probably not convince the majority. Secondly, &nbsp;GitExtensions is really the best GUI over git that I have found, so why not use it? I use it at work and I switch from command line to GitExtensions depending on the task. Finally,&nbsp;&nbsp;GitExtension is ``verbose'' by default, this means that it tells what command line is being executing underneath, so it helps you learning git internals.

To conclude, that some will find in&nbsp;this document a complementary to git documentation such as ProGit.
---
layout: post
title: Organize a multilanguage Jekyll site
date: '2014-08-24 15:47:39 +0000'
categories:
- Programming
- Web Development
tags:
- jekyll
- mulitlanguage
- SEO
---
In this post I will describe a simple organization of <a href="http://jekyllrb.com/">Jekyll</a> sources to get a mulitlanguage website.

<strong>EDIT:&nbsp;</strong>In the post below I suggest to use a 'translated' tree structure under the /fr directory. e.g. _/about/about.html_ becomes _fr/apropos/apropos.html_. This leads to complication and nobody cares if the url is translated. I suggest you to keep the exact same tree structure&nbsp;in base site, <em>_layout</em> and _fr_ directories.

What is Jekyll actually? Jekyll describes itself as a "a blog-aware static site generator". If you know the product you'll find this description totally fitted but still obscure if you are a newcomer. Let me introduce Jekyll in my own terms. Jekyll helps you to build .html pages, they are created when you publish (or update your site). Contrary to traditional dynamic webservers (e.g. ASP.NET, PHP etc.), the pages are not served and created "on demand" when the user visits the website. With Jekyll it's more simple, they are only web pages stored on the server disk as if you have created them "by hand". The magic lies in the fact that you do not have to duplicate all the html everywhere. Jekyll is a "generator" which means by using its basic features, includes, layouts etc. you will not have to repeat yourself so your site will be easily maintainable. What does "blog aware" mean? Jekyll can create pages but it has also been created for blogging on the first place. On its core you will find many things related to blog matters such as pagination, ordering, tagging etc. To conclude the presentation of Jekyll let us mention the fact that it is supported natively by <a href="https://pages.github.com/">github-pages</a>.

The multi language organization described in this post will illustrate some of the features of Jekyll. If you create a website with Jekyll, you must have a clean website structure such as the following one. You will notice the usual directories <em>_layout</em> and <em>_site</em>.

<script src="https://gist.github.com/bpatra/05e8ae432ea98b1321f05ae9d9c48ba1.js"></script>

<em>_layout</em> is extremely powerful, it is a form of inheritance. When you declare a page such as <em>index.html</em> and if you reference in the YAML (a kind of file header recognized by Jekyll) the <em>default</em> layout then your page will use all the html defined in the _layout <em>default</em>. We will use extensively the layout pattern for our localized website structure. The main idea is simple: the content of the pages are stored in a layout file located under the <em>_layout</em> directory, the rest of the site will only "call" layouts with the proper language to use.

Let us take a simple example to illustrate this. Suppose that your have a website which default language is english and another one: french. Naturally, the default language is located at the root of the website while other languages are located on a subfolders (e.g. www.myexample.com/fr). Suppose now that you have another subdirectory "about" ("&agrave; propos" in french) then your hosted website will have the following structure:

<script src="https://gist.github.com/bpatra/2918b37b10632785c89f142875f52688.js"></script>

The question now is: how to achieve this easily with Jekyll such that the translation of the sentences are kept side by side on the same file? This latter requirement is important to work with your translators. The trick is to replicate the website structure in <em>_layouts</em>. We use the YAML formatter to define a key/value variable that will hold the translation. The "true" pages will only call the layout with the right language to use.

Then, for the example mentioned above, the Jekyll sources structure looks like:

<script src="https://gist.github.com/bpatra/dc3f01114a9a0ecd2600d00936118b7b.js"></script>

The <em>about_lyt.html</em> contains the html content of the page and the translation such as this one. This new layout uses the default layout containing the common content of all website pages.

<script src="https://gist.github.com/bpatra/209b250af53241ab5d1f74ea9b4e852d.js"></script>

Then the two localized files simply contain a very basic YAML header.
Let us have a look at the file <em>about.html</em>

<script src="https://gist.github.com/bpatra/f5e98015d60f71dc0090e5466ca48687.js"></script>

And now let us examine its french alter ego <em>apropos.html</em>

<script src="https://gist.github.com/bpatra/ca0904ecade4b4c287506d15b1096eb4.js"></script>

This, organization is very simple and maintainable, this is the one that I have chosen for my own company's website <a href="http://www.keluro.com">www.keluro.com</a>. It is also very easy to send the YAML to the translators and put them back in your files to update your website. If you are interested in a script to extract YAML you may use <a href="https://gist.github.com/79d8f54b50ea6a2c484c">this one</a> written in powershell.


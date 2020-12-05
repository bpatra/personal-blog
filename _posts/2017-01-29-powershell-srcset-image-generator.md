---
layout: post
status: publish
published: true
title: Powershell srcset image generator
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 1988
wordpress_url: http://benoitpatra.com/?p=1988
date: '2017-01-29 18:33:27 +0000'
date_gmt: '2017-01-29 18:33:27 +0000'
categories:
- Programming
- Scripting
tags:
- html
- HTML5
- powershell
- pictures
- web
- SEO
comments: []
---
If you have a website and SEO matters for you, then you probably had to <a href="https://developers.google.com/speed/docs/insights/OptimizeImages">optimize images</a>. To this aim, you may want to have responsive images. As explained <a href="https://www.sitepoint.com/how-to-build-responsive-images-with-srcset/">here</a>,

<blockquote>a responsive image is an image which is displayed in its best form on a web page, depending on the device your website is being viewed from.
</blockquote>
One of the modern way to serve quickly responsive images is to benefit from the <code>srcset</code> html attribute. Shortly, depending on parameters and your viewport (i.e. browser window) the <code>srcset</code> attribute will tell the browser to download the best appropriate image for the current display.

For example, if you put the following HTML element

<script src="https://gist.github.com/bpatra/b3a9672acb18009d0b845c5cda8e46b6.js"></script>

Your server logic can serve up to four different images representing the same pictures.

You may guess that creating all this different resized pictures can be painful manually. In this blog post we propose the following Powershell script to help you for the automation of this task.

<script src="https://gist.github.com/bpatra/527c52118ca17114ef1e51e52a93d69a.js"></script>

Now you can simply invoke the script like this: <code>.\SrcsetBuilder.ps1 "..\images\MyImage.jpg" 85</code>. Then all generated images: <em>MyImage-200.jpg, MyImage-400.jpg, MyImage-600.jpg, MyImage-800.jpg</em> are located next to <em>MyImage.jpg</em>.
You can modify the generated images widths by changing the values in the array <code>$canvasWidths</code> (line 11).


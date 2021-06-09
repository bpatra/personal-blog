---
layout: post
title: Resize image and preserve ratio with Powershell
date: '2014-09-14 18:32:22 +0000'
disqus: true
categories:
- Programming
- Scripting
- Web Development
tags:
- bitmap
- jpeg
- powershell
- ratio
- SEO
---
My recently created company website <a href="http://www.keluro.com">Keluro </a>has two blogs: <a href="http://keluro.com/fr/blog">one in french</a> and <a href="http://www.keluro.com/blog">one in english</a>. The main blog pages are a preview list of the existing posts. I gave the possibility to the writer to put a thumbnail&nbsp;image in the preview. It's a simply <img /> tag where a css class is responsible for the resizing and to display the image in a 194px X 194px box while keeping the original aspect ratio. Most of the time this preview is a reduction of an image that is displayed in the blog post. Everything was fine until I found out that the these blog pages did not received a good mark while inspecting them with <a title="Page Speed Insights" href="http://developers.google.com/speed/pagespeed/insights/">PageSpeedInsights </a>. It basically says that the thumbnails were not optimized enough... For SEO reasons I want these blog pages to load quickly so I needed to resize these images once for all even if it has to duplicate the image.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/09/drawingresizingposh.jpg'  caption="Resizing two pictures with landscape and portrait aspect ratio to make them fill a given canvas." %}

I think that most of us already had&nbsp;to do such kind of image resizing task. You can use many available software to do that: Paint, Office Picture Manager, Gimp, Inkscape etc. However, when it comes to manipulate&nbsp;many pictures, it could be really useful to use a script. Let me share with you this Powershell script that you can use to resize your .jpg pictures. Note that there is also a quality parameter (from 1 to 100) that you can use if you need to compress more the image.

<script src="https://gist.github.com/bpatra/22678266076663c4b594daa56f69c383.js"></script>

Now suppose that you have saved and named the script above "MakePreviewImages.ps1". You may use it in a loop statement such as the following one where we assume that MakePreviewImages.ps1 is located under the current directory and the images are in a subfolder called "images".

<script src="https://gist.github.com/bpatra/efba7d86edad94a8f2c9039e599f5255.js"></script>


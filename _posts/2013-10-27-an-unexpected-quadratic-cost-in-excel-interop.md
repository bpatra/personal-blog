---
layout: post
status: publish
published: true
title: An unexpected quadratic cost in Excel Interop
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2013-10-27 12:13:52 +0000'
date_gmt: '2013-10-27 11:13:52 +0000'
categories:
- Programming
- Algorithms
tags:
- Add-Ins
- algorithm
- C#
- Excel
- interop excel
- Microsoft Excel
- BigData
comments:
- id: 11
  author: SutoCom
  author_email: dennes777@gmail.com
  author_url: http://www.sutocom.net
  date: '2013-10-31 23:07:20 +0000'
  date_gmt: '2013-10-31 22:07:20 +0000'
  content: Reblogged this on <a href="http://sutocom.net/2013/10/31/an-unexpected-quadratic-cost-in-excel-interop/"
    rel="nofollow">Sutoprise Avenue, A SutoCom Source</a>.
- id: 21
  author: allensmith2
  author_email: allenfirstday2@outlook.com
  author_url: http://allenfirstday2.wordpress.com
  date: '2015-01-20 03:41:03 +0000'
  date_gmt: '2015-01-20 02:41:03 +0000'
  content: |-
    I want a combined Ranges. How do I combine two ranges into one?
    Dim range1 as Excel.Range =   osheetTemperatureData.Range(""A7:""A10"")
    Dim range2 as Excel.Range =   osheetTemperatureData.Range(""C7:""C10"")
    Dim range3 as Excel.Range = range1 + range2 '????
    <a href="http://www.keepautomation.com/products/excel_barcode/" rel="nofollow">Excel barcode</a>
- id: 31
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://benoitpatra.wordpress.com
  date: '2015-01-20 13:09:36 +0000'
  date_gmt: '2015-01-20 12:09:36 +0000'
  content: You can use the Union describe in this post but take care if you do that
    in loop you may face the quadractic cost (that may lead to disastrous performance)
    described here.
- id: 41
  author: allensmith2
  author_email: allenfirstday2@outlook.com
  author_url: http://allenfirstday2.wordpress.com
  date: '2015-01-21 02:54:41 +0000'
  date_gmt: '2015-01-21 01:54:41 +0000'
  content: Thanks for your reply,I try the method you told me,it does work.
---
My current task at work is the development of an excel addin. This addin is developed in C# .NET and is based on the Excel Interop assemblies, we also use&nbsp;<a href="http://excel-dna.net/">Excel DNA</a>&nbsp;for the packaging and the User Defined functions. While developing a new feature I stumbled upon a technical oddity of Excel Interop which I will describe to you in this post.

Let me start this post by reminding you that a range in Excel is not necessarily a block of contiguous&nbsp;cells. Indeed, try it yourself by starting excel right now. Then you can select a range, keep the Ctrl button of your keyboard press on and select an other block of contiguous cell. Then, you have several cells selected that you can name (as shown in the screenshot). Finally, you have created a named range with non-contiguous cells.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/10/ranges-300x168.jpg' caption="A range of non-contiguous cells in Excel" position_class="image-right"%}

<span style="line-height: 1.714285714; font-size: 1rem;">Having said that, let us assume that for our addin&nbsp;we need to reference programmatically the range of all lines of the form, with usual excel notations,&nbsp;</span><strong style="line-height: 1.714285714; font-size: 1rem;">Ax:Cx</strong><span style="line-height: 1.714285714; font-size: 1rem;">&nbsp;where </span><strong style="line-height: 1.714285714; font-size: 1rem;">x</strong><span style="line-height: 1.714285714; font-size: 1rem;"> describes a set of row indices.&nbsp;</span>

Then we need to use the method <a href="http://msdn.microsoft.com/en-us/library/microsoft.office.interop.excel._application.union.aspx">Application.Union</a> of <a href="http://msdn.microsoft.com/en-us/library/Microsoft.Office.Interop.Excel.aspx">Micorsoft.Office.Interop.Excel</a> and finally produce few lines of code that &nbsp;looks like that.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/7170224.js' %}

In the chart above we have monitored the time execution of the <em>BuildUnionAll</em>&nbsp;method for&nbsp;different values of the parameter <em>count.</em>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/10/linear.jpg' caption="Performance curve for the BuildUnion method" size_class="medium" %}

Remark: in the case of <em>BuildUnionAll</em>&nbsp;there is no need to use a loop and the <em>Union</em> method, we could have just ask for the range "<strong>A1:Ccount".&nbsp;</strong>Note also that for small unions you may also use a syntax with semicolon to separate contiguous cells blocks e.g.&nbsp;<em>worsheet.Range["A1:C3;A8:C12"].&nbsp;</em>However, this does not work for large ranges made of multiple non-adjacent cells blocks.

So far so good, we see an almost linear curve, which is natural regarding to what we were expecting.

Now, change a little bit our expectation to something quite different and more realistic where we would truly need the <em>Application.Union</em> method. Then let us say that we would like to have the union <strong>Ax:Cx</strong>&nbsp;mentioned above but for <strong>x </strong>odd index only. We want the <em>IEnumerable<int></em>&nbsp;to have the same size than before, so let us use the method in the code below.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/99adafee10e3866c4bd1.js' %}

Similarly, we monitor the performance curve.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/10/quadratic.jpg' caption="Quadratic performance" size_class="medium" %}

Argghhh!!! we get an awful quadratic cost which makes our approach completely broken for large unions. This quadratic cost was unexpected. Actually I did not found documentation on this (the msdn doc on Excel.Interop is really minimalist). However, it seems that the rule is that the Union method has a linear cost depending on the number of Areas in the input ranges. The <a href="http://msdn.microsoft.com/en-us/library/microsoft.office.interop.excel.range.areas.aspx">Areas</a> member of a <a href="http://msdn.microsoft.com/en-us/library/Microsoft.Office.Interop.Excel.Range.aspx">Range</a> is the collection containing the blocks of contiguous cells of the range.

This experimental rule, leads us to review our algorithm in a different way. If the cost of an Union is important (linear) when there are many areas in a range. Then we will try to minimize this situation: we will let our algorithm perform the union preferably on ranges having fewer areas. Once again, the basic techniques from school bring a good solution and we will design a very simple recursive algorithm based on the divide and conquer approach, inspired for the merge sort algorithm.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/003404081d81a3c24930.js' %}

To the end, we recover an almost linear curve. The asymptotic complexity here (if the rows to pick are not adjacent to each other) equals the merge sort one which is O(n.ln(n)).

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2013/10/divideandconquer.jpg' caption="Back to normal with divide and conquer approach" size_class="medium" %}
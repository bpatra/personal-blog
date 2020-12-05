---
layout: post
status: publish
published: true
title: My TransientFaultHandling utilitary classes for DocumentDB
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2016-06-25 22:42:03 +0000'
date_gmt: '2016-06-25 22:42:03 +0000'
categories:
- Programming
- Database
tags:
- ".NET"
- C#
- DocumentDB
- consistency
- nosql
- CosmosDB
- BigData
comments:
- id: 17171
  author: Rajesh Nagpal
  author_email: rnagpal@microsoft.com
  author_url: ''
  date: '2016-06-27 02:51:56 +0000'
  date_gmt: '2016-06-27 02:51:56 +0000'
  content: "Hi Benoit,\r\n\r\nGlad to hear that you use DocumentDB as your NoSQL data
    store. I went through your post and wanted to mention that we have built-in support
    for basic retry mechanism for 429s for all requests(query as well as commands)
    starting .NET SDK 1.8.0 release of DocumentDB.\r\n\r\nThis is done by exposing
    a RetryOptions property on the ConnectionPolicy instance that gets passed to DocumentClient
    constructor. By default, all requests will be retried 9 times(so that you have
    10 attempts for each request) and it will use the retryAfter response header to
    determine how much to wait between each request. There is a max wait time set
    to 30 sec for each request after which it will throw. Both these values(MaxRetryAttemptsOnThrottledRequests
    and MaxRetryWaitTimeInSeconds) can be overridden on the RetryOptions instance.\r\n\r\nPlease
    give it a try and let us know if you have any feedback to further improve the
    retry mechanism.\r\n\r\nWe will look into the tracing issue that you mentioned
    to see if there are better ways to expose the retry related information for each
    request.\r\n\r\nI'm from the DocumentDB Engineering team and feel free to reach
    us for any .NET SDK related issues in DocumentDB at https://github.com/Azure/azure-documentdb-dotnet/issues
    \r\n\r\nRegards,\r\nRajesh"
- id: 17176
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-06-27 08:23:23 +0000'
  date_gmt: '2016-06-27 08:23:23 +0000'
  content: |-
    Hi Rajesh,
    thank you very much for your insights. Indeed, my .NET SDK package as an update waiting: 1.8.0 version. I will definitely have a look at this ! Maybe you should mark the Nuget package "Microsoft.Azure.Documents.Client.TransientFaultHandling" as deprecated.
- id: 17182
  author: Rajesh Nagpal
  author_email: rnagpal@microsoft.com
  author_url: ''
  date: '2016-06-28 01:27:14 +0000'
  date_gmt: '2016-06-28 01:27:14 +0000'
  content: "Hi Benoit,\r\n\r\nTransientFaultHandling package does some more stuff
    like retrying on some transient errors which the SDK doesn't supports yet. Eventually,
    we plan to deprecate it once we have the parity.\r\n\r\nKeep me posted on your
    experience of using the build-in retry policy in .NET SDK.\r\n\r\nRegards,\r\nRajesh"
- id: 17298
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-07-09 10:55:10 +0000'
  date_gmt: '2016-07-09 10:55:10 +0000'
  content: I have upgraded to .NET SDK 1.8.0 and set the retry policies options in
    my pre-production environnement. It looks to work well but I did not conduct any
    measurement experiments yet.
---
<a href="https://keluro.com/">Keluro</a> uses extensively <a href="https://azure.microsoft.com/en-us/services/documentdb/">DocumentDB</a> for data persistence. However, it's extensive scaling capabilities come with a price. Indeed with your queries or your commands you may exceed the amout of request unit you are granted. In that case you will received a 429 error "Request rate too large" or a "DocumentException" if you use the .NET SDK. It is your responsability then to implement the retry policies to avoid such a failure and wait the proper amout of time before retrying.

<strong>Edit</strong>: look at the comment below. The release v1.8.0 of the .NET SDK proposes some settings options for these retry policies.

<a href="https://blogs.msdn.microsoft.com/bigdatasupport/2015/09/02/dealing-with-requestratetoolarge-errors-in-azure-documentdb-and-testing-performance/">Some samples are provided by Microsoft</a> on how to handle this 429 "Request too large error", but they are concerning only commands, such as inserting or deleting a document, there is no sample on own to implement the retry policies for common queries. <a href="https://www.nuget.org/packages/Microsoft.Azure.DocumentDB.TransientFaultHandling/">A Nuget package is also available</a>: "Microsoft.Azure.Documents.Client.TransientFaultHandling" but even if integrating it is as quick as an eye blink, there is no logging capabilities. In my case it did not really resolve my exceeding RU problem, I even doubt that I made it work and the code is not opensource. Then, I decided to integrate the ideas from the samples in own utilitary classes on top of the DocumentDB .NET SDK.

The idea is similar to "TransientFaultHandling" package: to wrap the DocumentClient inside another class exposed only through an interface. By all accounts, it is a good thing to abstract the DocumentClient behind an interface for testability purposes. In our case this interface is named <em>IDocumentClientWrapped</em>.

<script src="https://gist.github.com/bpatra/52779d9c83f4ed2974c42165aaedc837.js"></script>

Instead of returning an <em>Queryable<T></em> instance as <em>DocumentClient</em> would do we return an <em>IRetryQueryable<T></em>. This latter type, whose definition will follow, is also a wrapper on the <em>IQueryable<T></em> instance returned by the DocumentDB client. However, this interface explicitely retries when the enumeration fails because of 429 request too large exception raised by the database engine, DocumentDB in our case.

<script src="https://gist.github.com/bpatra/51a215059688299229ae8c406a1f4d89.js"></script>

In this interface we only expose the method extension methods that are actually supported by the "real" <em>IQueryable<T></em> instance returned by DocumentDB: <em>Select</em>, <em>SelectMany</em>, <em>Where</em> etc. For example, at the time of the writing <em>GroupBy</em> is not supported. You would get an runtime exception if you used it directly on the <em>IQueryable<T></em> instance returned by <em>DocumentClient</em>.

Now look at how we use these interfaces in the calling code.

<script src="https://gist.github.com/bpatra/f85b60e6a320687f0e64e7a030381498.js"></script>

Independently of the retry policies classes and the "request too large errors", let me emphasis that LINQ can be tricky here. Indeed, the piece of code above is completly different from this one:

<script src="https://gist.github.com/bpatra/96419e843e3153674f88c2a0c1924a00.js"></script>

In this case the Where constraint is perfomed "in memory" by your .NET application server. It means that you have fetched all data from DocumentDB to your app server. If MyType contains a lot of data, then all have been transfered from DocumentDB to your application server and/or if the Where constraint filters a lot of documents you will probably have a bottleneck.

Let us get back to our problem. Now that we saw that having retry policy for a query means only calling <em>AsRetryEnumerable()</em> instead of <em>AsEnumerable()</em> let us jump to the implementation of thoses classes.

The idea is to use an IEnumerator that "retries" and use two utility method: <em>ExecuteWithRetry</em>,<em>ExecuteWithRetryAsync</em>. The former one for basic mono threaded calls while the latter is for the async/await context. Most of this code is verbose because it is only wrapping implementation. I hope it will be helpful for others.

<script src="https://gist.github.com/bpatra/d9939abc7e2bad936493955cb93066c3.js"></script>
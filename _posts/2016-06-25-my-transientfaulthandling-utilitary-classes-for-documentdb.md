---
layout: post
title: My TransientFaultHandling utilitary classes for DocumentDB
date: '2016-06-25 22:42:03 +0000'
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
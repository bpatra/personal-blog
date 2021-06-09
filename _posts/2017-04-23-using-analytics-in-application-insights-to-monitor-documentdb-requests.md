---
layout: post
title: Using Analytics in Application Insights to monitor CosmosDB Requests
date: '2017-04-23 15:21:07 +0000'
disqus: false
categories:
- Programming
- Database
tags:
- azure
- DocumentDB
- nosql
- CosmosDB
- BigData
---
Following Wikipedia, <a href="https://en.wikipedia.org/wiki/DocumentDB">DocumentDB</a>&nbsp;(now CosmosDB) is

>Microsoft&rsquo;s multi-tenant distributed database service for managing JSON documents at Internet scale.

The throughput of the database is charged and measured in <em>request unit per second</em> (RUs). Therefore, when creating application on top of DocumentDB, this is a very important dimension that you should pay attention to and monitor carefully.

Unfortunately, at the time of the writing the Azure portal tools to measure your RUs usage are very poor and not really usable. You have access to tiny charts where granularity cannot be really changed.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/04/azure.jpg' caption="These are the only monitoring charts available in the Azure Portal" %}

In this blog post, I show how <a href="https://azure.microsoft.com/en-us/services/application-insights/">Application Insights Analytics</a> can be used to monitor the RUs consumption efficiently. This is how we monitor our collections now at <a href="https://keluro.com/">Keluro</a>.

Let us start by presenting Application Insights, it defines itself <a href="https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview">here</a> as

>an extensible Application Performance Management (APM) service for web developers on multiple platforms. Use it to monitor your live web application. It will automatically detect performance anomalies. It includes powerful analytics tools to help you diagnose issues and to understand what users actually do with your app.

Let us show how to use it in a C# application that is using the DocumentDB .NET SDK.

First you need to install the <a href="https://www.nuget.org/packages/Microsoft.ApplicationInsights">Application Insights Nuget Package</a>. Then, you need to track the queries using a <em>TelemetryClient</em> object, see a sample code below.

<script src="https://gist.github.com/bpatra/83ac0293cb8d830933d66332497a937b.js"></script>

The good news is that you can now effectively keep records of all requests made to DocumentDB. Thanks to a great component of Application Insights named <a href="https://docs.microsoft.com/en-us/azure/application-insights/app-insights-analytics">Analytics</a>, you can browse the queries and see their precise <em>request-charges</em> (the amount of RUs consumed).

You can also add identifiers (with variables such as <em>kind</em> and <em>infolog</em> in sample above) from your calling code for a better identification of the requests. Keep in mind that the request payload is not saved by Application Insights.

In the screenshot below you can list and filter the requests tracked with DocumentDB in Application Insights Analytics thanks to its <a href="https://docs.microsoft.com/en-us/azure/application-insights/app-insights-analytics-tour">amazing querying language to access data</a>.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/04/analytics_1.jpg' caption="Getting all requests to DocumentDB in a a timeframe using application Insights Analytics" %}

There is one problem with this approach is that for now, using this technique and DocumentDB .NET SDK we do not have access to the number of retries (the 429 requests). This is an <a href="https://github.com/Azure/azure-documentdb-dotnet/issues/225">open issue on Github</a>.

Finally, Analytics allows us to create a very important chart. The accumulated RUs per second for a specific time range.
The code looks like the following one.

<script src="https://gist.github.com/bpatra/14d12e1acfc6edbe27375b7958fcd959.js"></script>

And the rendered charts is as follows

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2017/04/analytics_2.jpg' caption="Accumulated Request-Charge per second (RUs)" %}

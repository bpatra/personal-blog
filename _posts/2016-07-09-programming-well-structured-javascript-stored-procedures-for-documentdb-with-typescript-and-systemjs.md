---
layout: post
title: "Programming well structured Javascript stored procedures for DocumentDB with Typescript and SystemJs"
date: '2016-07-09 17:06:38 +0000'
categories:
- Programming
- Database
tags:
- javascript
- DocumentDB
- typescript
- systemjs
- nosql
- CosmosDB
- BigData
---

If you are using <a href="https://azure.microsoft.com/en-us/documentation/articles/documentdb-introduction/">DocumentDB</a> you may&nbsp;had to write your own <a href="https://azure.microsoft.com/en-us/documentation/articles/documentdb-programming/">stored procedure</a>. A stored procedure is a function written in Javascript that runs on the DocumentDB cloud infrastructure. It may reduce performance problem or make you execute some queries&nbsp;that are not supported yet through&nbsp;the REST API such as <a href="https://dzone.com/articles/aggregation-framework-as-stored-procedure-in-azure">aggregate function</a>.

EDIT: code sample on github <a href="https://github.com/bpatra/StoredProcedureGeneration">https://github.com/bpatra/StoredProcedureGeneration</a>

A stored procedure should be registered as a single function of the form:

<script src="https://gist.github.com/bpatra/e3ecf58a562bf50beb8b4f5f80fe6646.js"></script>

You can create function inside the <em>myStoredProcedure</em> function body. However, you cannot create other functions in the file otherwise DocumentDB will complain.&nbsp;This is quite annoying because you probably want to create independent and reusable pieces of code for testability or simply for the sake of readability. The problem comes from the fact that you cannot really use out-of-the box third party module management libraries such as <em>requireJS</em>, <em>commonJS</em> or <em>SystemJS</em>. This sounds no good. Is that&nbsp;means we are forced to inline all our code in a big not modular and un-testable Javascript file!?!?

The answer is no, in this blog post I will show you the solution we implemented at Keluro to overcome this problem. This solution is based on <em>SystemJs</em> and <em>SystemJs-Builder</em> to create a standalone function where all modules/class dependencies are embedded in the stored procedure single function which acts as our entry point. The code snippets presented in the following are extracted from the following <a href="https://github.com/bpatra/StoredProcedureGeneration">git repository</a>.

In this article, we will use Visual Studio as an IDE but it is not mandatory. Actually, it is only to simplify the options settings for compiling Typescript files, you can invoke the compiler manually exactly with the same set of options.

In the following, we will take an example where the stored procedure computes the sum of input arguments. Therefore, we create a Typescript class for the core of our stored procedure called <em>Utilitary</em> that contains a method called <em>sumValues</em>.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2016/07/DocumentDB_Utilitaryts-1024x647.jpg' caption="A typescript class used in DocumentDB stored procedure" %}

Then we create the entry point of the stored procedure in a Typescript file that uses the DocumentDB current context. We benefit from the <a href="https://github.com/typings/typings">typings </a>from <em>documentdb-server.d.ts</em> that defines the <em>IContext</em> interface.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2016/07/DocumentDB_MyStoredProcedurets-1024x548.jpg' caption="MyStoredProcedure typescript file executed by DocumentDB" %}

We compile the Typescript files has <em>SystemJs</em> modules and we redirect all generated Typescript in the directory <em>out-js</em>. As I told you, no need of VisualStudio to do this, you can achieve the same result by invoking the Typescript compiler with similar&nbsp;options.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2016/07/VisualStudioTypescriptCompilingOptions-1024x700.jpg' caption="Compiling options set in Visual Studio" %}

If you look at the generated Typescript you will get something that looks like

<script src="https://gist.github.com/bpatra/2e1bb8c984e829c11a81fd56f1f56378.js"></script>

If you try to run such a Javascript source code directly with DocumentDB you will get an error. These modules are meant to run with <em>System.js</em> and in the case of&nbsp;a stored procedure you cannot reference any third party library such as <em>System.js</em>. This is where <em>SystemJs-Builder</em> will come into play. <em>SystemJs-builder</em> will package everything so that your modules are independent of <em>System.js</em> and they can be used as a standalone file.

To invoke <em>SystemJs-Builder</em> you need to use <em>Node.js</em>. In the sample git repository, you will have to hit 'npm install' to restore the&nbsp;<em>SystemJs-Builder Node package</em>. When the Typescript files are compiled invoke the node script "<a href="https://github.com/bpatra/StoredProcedureGeneration/blob/master/documentdb_storedprocedure_builder.js">documentdb_storedprocedure_builder.js</a>" at the root of the repository. This script basically executes two tasks. First, it&nbsp;generates a standalone Javascript file with <em>SystemJs-Builder</em>. Secondly, because DocumentDB explicitly needs a file with one function and not an&nbsp;executable Javascript script,&nbsp;we wrap this code inside a function that will act as our entry point for the stored procedure.

We also retrieve the arguments passed to the storedprocedure procedure function in a variable called <em>storedProcedureArgs</em>&nbsp;that is kept in the global namespace. The resulting file is generated and put in the directory <em>generated-procedure</em>. Finally, this file contains what we needed:&nbsp;a standalone and executable by DocumentDB Javascript function. With this approach all Typescript classes can be reused for other&nbsp;stored procedures ,&nbsp;for unit tests or anywhere in your Typescript code base.

There are probably thousands of alternatives to create testable and decoupled stored procedures. We liked this approach because it reuses the same tools that we were already using for our single page applications: Typescript and SystemJs. To conclude let me thank&nbsp;Olivier Guimbal who showed us some months ago how Typescript, <em>SystemJs</em> and <em>SystemJs-Builder</em> worked well together.


---
layout: post
title: My WPF/MVVM "must have" part 3/3 - On view model unit tests organization
date: '2015-06-30 13:11:33 +0000'
disqus: false
categories:
- Programming
- MVVM
tags:
- C#
- MOQ
- MVVM
- TDD
- unit tests
- UnitTest
- WPF
---
One of the great advantage of the MVVM pattern is that it allows you to test the Graphic User Interface logic of the application through the view models. The latter ones are in charge of 'presenting' the data to your screen controls, the so-called views. For a very short introduction to MVVM, I recommend <a href="http://blog.hitechmagic.com/?page_id=513">this article</a>. This post is the last one of the series on the WPF/MVVM and it deals with the organization of the view model unit tests in a large project. I have written a <a href="/2014/03/15/unit-testing-drag-and-drop-logic-with-mvvm-pattern-in-wpf/">blog post</a> on how MVVM can let you test some part of your logic that you might not have thought possible before. The present blog post does not aim at presenting 'how' you write unit test but rather at presenting a way to organize the numerous unit tests.

When you implement unit tests for view models, you must test end-user actions. For example, you will implement test assertions for the click command on a button. Unit test should be organized so that when they fail you can easily find out the user action or presentation status of the data that you are testing. To this aim, we will use a structure of unit tests that use extensively class inheritance. Although, MSTest is not know to be the best framework for tests with inheritance, it remains the framework that I use. I do believe that one can find an even more elegant approach with other tests framework. The approach presented here is mine, I do not pretend this is the best one, it is just an example of an organization that have proven to work in large projects.

The mocking framework used is <a href="https://github.com/Moq/moq4">Moq</a>. A mocking framework is not 100% mandatory for TDD. However, anytime I saw a C# project that was not using a mocking framework, then the unit tests were not really unit tests. Sometimes they were badly written and were not asserting relevant stuff and sometimes they were more or less integration tests.

Let us get back to our organization of view model tests: the basic idea is taken from the book <a href="http://amzn.com/047064320X">Professional Test Driven Development in C#</a>. I recommend it if you are unfamiliar with unit testing. It is one of the best reference that I found on the subject of TDD. It contains many relevant real life examples.

So the idea is to have a base class called <em>Specification</em>.

<script src="https://gist.github.com/bpatra/2d081e304c04132b0f653906e9eacdb6.js"></script>

This is the base class that all view model unit test class should inherit. I acknowledge that there are virtual calls in constructor, <a href="http://stackoverflow.com/questions/119506/virtual-member-call-in-a-constructor">this not a very neat pattern</a>. But as you probably know, C# defers from Java and C++ and the virtual call will always call the most derived class implementation of a virtual method, even in constructors.

Another thing that you must know: for each unit test execution, a new instance of the class is created, even if the tests belongs to the same test class. Consequently, we get a well test isolation without even use <em>[TestInitialize] [TestCleanup] [ClassInitialize]</em> attributes.

Let us go back to our <em>Specification</em> class, you remarked that it is abstract. To continue the organization, for each view model, you create a directory under the <em>ViewModels</em> directory of the test project. In this directory, create a new abstract class derived from the <em>Specification</em> class. This will be the base class for all test of a given view model we prefix this base class by 'General', e.g. for a view model called <em>AdminViewModel</em>, we created <em>GeneralAdminViewModelTests</em> class.

<script src="https://gist.github.com/bpatra/371b883455a68a0e220f5ced6755feb2.js"></script>

In this GeneralAdminViewModelTests, we instanciate the System Under Test (SUT), in this example: <em>AdminViewModel</em>. It is assigned to a protected field with the same name, this is the only 'true' implementation. The role of this <em>GeneralAdminViewModelTest</em>, is to pass the dependencies, that can be other view model (parent view models) or other services. The dependencies are "fresh" mock object, without any setup. The configuration of the setups depends on their usage, which will be precised in the 'true' derived child test class, to this aim we declare a protected abstract method SetupMocks. There is a big benefit of performing the instanciation of the SUT in one base class. Indeed, whenever you'll add or remove a dependencies you will have just this base class implementation to change. This would have been a tedious operation if the SUT were instanciated in multiple places.

Personally, I did not managed to use one fake implementation for all tests and inject them using a IoC container. Actually, when you write unit tests you always need a different behavior of you mock depending on the test specification. For example, if you have an <em>IoService</em> that abstracts usage of disk I/O operation, sometimes you will want to fake a failure, an exception throwage etc. Therefore, my approach is to setups the mocks only with the behavior required for the tests. However, it is possible to factorize your mocks configuration, by using some 'Usual Mocks' setups.

Let us detail the true implementation of unit tests. You must separate your tests according to "existing" configurations. In my example, the <em>AdminViewModel</em> must deal with two situations (among others): when there are some existing data (called matters) and when there are none. That is why, under the <em>AdminViewModelTests</em> directory we created two files <em>"WhenThereAreThreeMatters.cs"</em> and <em>"WhenThereAreNoMatter.cs"</em>. See the resulting tree file structure in picture below.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/06/fileexplorer1.jpg'  caption="An example of view model test organization for the 'AdminViewModel'" %}

Once again, the trick is to play with inheritance. A the top of the file, we declare once again a base class. That will be the mother class of all test class in this file. In this situation, we will setup the mocks so that they fake the existence of three matters in the database.

Once the mocks are setup, we can implement the true tests class, that act as the specification of the view models. They are the most derived class (they could be marked as sealed), they are decorated with the <em>[TestClass]</em> attributes and the <em>[TestMethod]</em> attiribute for the tests. In the code listing below, there are two examples. First the <em>WhenNothingIsDone</em>, that will assert the following facts: <em>when nothing is done, there are still three matters displayed, the view model is not 'dirty' (no changes from the end-user) and that is still possible to delete a matter</em>. Then we have another class, that will test the behavior of our <em>AdminViewModel</em>, when there are <em>ThreeExistingMatters</em>: <em>when we click Delete (on a matters) then, there are only two matters displayed and the view model is dirty.</em> You may think, of others TestClass, asserting behavior of this view model under these circumstances, for example, you may Assert what is going on when the end-user clicks Save (after clicking Delete) etc.

Remark that we needed more setups for the mock in the <em>WhenDeletingMatters</em> implementation, so it is possible to override the the <em>SetupMocks</em> method to add some behavior to the mock. See examples in C# code listing below.

<script src="https://gist.github.com/bpatra/f0da8237a1a60086e6bd3fa1cb295167.js"></script>

Finally, one particularly helpful trick is to use the folder Namespacing conventions. Remark that a feature from Resharper enables you to enforce this convention for all files in a given folder, the current project and even the whole solution. Then our class <em>WhenDeletingAMatter</em> has for complete name <em>.ViewModels.AdminViewModelTests.WhenThereAreThreeMatters.WhenDeletingAMatter</em>. In your Resharper Test Session or VisualStudio TestExplorer, you can select 'group by namespaces', then you have a very neat a readable organization of your unit test as shown in the screenshot below.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/06/resharperorgnaizationbynamespaces-1024x642.jpg' caption="When selecting the option 'GroupByNamespaces' then the readability of the test organization becomes very clear" %}

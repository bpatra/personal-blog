---
layout: post
title: Unit Testing Drag and Drop logic with MVVM pattern in WPF
date: '2014-03-15 15:49:47 +0000'
disqus: false
categories:
- Programming
- UnitTesting
- MVVM
tags:
- C#
- GongWPF
- mock framework
- MOQ
- MSTest
- MVVM
- Unit Testing
- WPF
- XAML
---
I recently had a discussion with a friend about the Model-View-ViewModel pattern (MVVM) for UI apps and the fact that it allows unit testing where you would not have thought it possible in the first place, for example, logic involved by drag and drop. We agreed on the fact that most of MVVM posts are very theoretical regarding MVVM and when they are not, the testing part, is only mentioned never detailed. That is why I decided to write 
The objective of this post is to detail the code architecture and the techniques involved to the testing of a very simple WPF app. This app enables the user to rank via drag and drop the list of the french football clubs and save this ranking. This could be a part of larger app that could be used, for example, to bet the final table... However for the sake of simplicity of this post we will focus mainly on the WPF control <em>ListView</em> containing the football club rows. The source code can be found in this <a href="https://github.com/bpatra/MvvMSample">github repository</a>.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/03/screenshotandsave.png' caption="The list view control displaying the football clubs that can be reorganized by drag and drop. The order can be saved." %}

We will use an external library that wraps all the complex events handling regarding the mouse action involved in the drag and drop. Following unit testing principles, we will only test our logic which will be the movement of elements in the collection the&nbsp;<em>ListView</em> is bound to. In order to add little bit of extra complexity, we would like to allow not only the movement of one row but also of a block of contiguous rows.

There are tons of blog posts and articles on theoretical description of MVVM written by brilliant developers so I will try to be as brief as possible and will focus more on the example. &nbsp;The fundamental and natural principle on which MVVM and other UI pattern are based on is to separate the UI from the business logic. In one sentence, the application logic should not be tied to UI elements.&nbsp;The Model/View/ViewModel comes in three parts, it is well summarized in this <a href="//blog.hitechmagic.com/?page_id=513">blog</a>, quoting:

>A view is simply a UI page: _It does not know where the data is coming from._

>A ViewModel holds _a certain shape of data, and commands,_ that a View binds to.

>The model refers to the actual business data, which is used to populate the ViewModels.

The basic interaction rules can be summarized in the drawing below.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/03/mvvm1-300x149.png' caption="MVVM interactions overview" %}

Speaking more in terms of WPF, the view contains the UserControls, the windows. A view class definition is split between the xaml file (simplifying UI design) and the associate .cs file called code behind. If an application is coded following MVVM principles the code behind should be small, containing code on the UI elements that are difficult to expressed with XAML syntax (e.g. keyboard bindings).

Now it is time, to present the external tools that we are going to use in this small app. The drag and drop mouse interaction will be handled by the open source project <a title="GongWPF" href="https://github.com/punker76/gong-wpf-dragdrop">GongWPF</a>. For unit testing we will use the <a title="Visual Studio Test framework" href="http://en.wikipedia.org/wiki/Visual_Studio_Unit_Testing_Framework">Visual Studio Test framework</a> and <a title="Moq" href="https://github.com/Moq/moq4">Moq</a> for creating mock objects. For a real and more sophisticated app written with MVVM, I would recommend you to use a framework. Personally, I do like <a title="mvvmlight" href="https://mvvmlight.codeplex.com/">MVVMLight</a>.

Let us describe the code of our app starting by the so-called <em>model</em> part. This is a natural way because, in real scenarios this may be existing parts, written before ever considering the UI. However, in this fake app it is going to be very simple. The main business interface is&nbsp;<em>IFootballClub</em>&nbsp;exposing three properties regarding the club.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9401745.js' %}

The core model is represented by the interface <em>IChampionship</em>. It is extremely lightweight in our situation because, in this post, we want to focus more on the View/ViewModel interaction. However, we have added the property <em>CurrentChampionShipRanking</em> and&nbsp;<em>GetGoodBetCount</em> as examples of methods that could be put in the model.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9401776.js' %}

Let us now present the interface for our ViewModel,&nbsp;<em>IChampionshipViewModel</em>, which is the most important part of this blog post. Therefore, it will be the only interface where we provide the implementation. This implementation will handle the drag and drop core logic and will be the system under test for our matter. The list of football clubs will be kept in the <em>FootballClubs</em> observable collection. This collection handles natively all the notifications for the view. The Save action will be handled by the <em>SaveClick</em> property whose type is <em>ICommand</em>. An <em>ICommand</em> is an interface for an action that can be executed.

Remark also that <em>IChampionshipViewModel</em> extends <em>IDropTarget</em> which is the main interface provided by GongWPF for handling the drag and drop events. This interface contains two methods&nbsp;<em>void DragOver(IDropInfo dropInfo) </em>and<em>&nbsp;void Drop(IDropInfo dropInfo)</em>

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9516512.js' %}

To complete the overview let us present the xaml for our view. Indeed, following MVVM principles, our custom <em>UserControl</em> is essentially XAML leaving no code behind. The most important part is the binding of the View to the ViewModel via the <em>DataContext</em> property. In our case, we have used a ViewModelLocator&nbsp;(a very simple one with no IoC container) see &nbsp;<a href="http://stackoverflow.com/questions/14130327/viewmodels-in-viewmodellocator-mvvm-light">this post</a> for more information on the ViewModelLocator pattern. Naturally, the <em>ListView</em> <em>ItemsSource</em> (the list of rows) is bound to the <em>FootballClubs</em> property of the&nbsp;<em>IChampionshipViewModel</em> interface. For each column, we can bind to a property of the interface <em>IFootballClub</em>. Note also, that the <a href="http://www.jetbrains.com/resharper/">Resharper AddIn </a>enables intellisense and type validation of those bindings which is really valuable for early detection of errors.
Finally, the <em>ListView</em> control has the following GongWPF attributes:<br />
<em>dd:DragDrop.IsDragSource="True",&nbsp;dd:DragDrop.IsDropTarget="True",&nbsp;dd:DragDrop.DropHandler="{Binding}"</em>

Thanks to these attributes, GongWPF will be able to make a bridge between the mouse UI events and the methods of the <em>IDropTarget</em> interface which our ViewModel extends.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9516759.js' %}

Unfortunately, as brilliant as it is, GongWPF does not do everything and it's our responsibility &nbsp;to implement the logic that moves the elements within the <em>ObservableCollection</em>&nbsp;<em>FootballClubs.&nbsp;</em>

Following the TDD principles let us write tests first.&nbsp;But before that, let us have a glimpse at our SUT (system under test) which is the class <em>ChampionshipBetViewModel</em>. The model <em>IChampionship</em> is injected as a constructor parameter. We will not discuss further the <em>SaveClick</em> part but we use a custom implementation of the <em>ICommand</em> interface which basically execute the lambda expression passed as parameter. This <em>Action </em>typed lambda updates our model with the reranked list of football clubs.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9517801.js' %}

Here comes our first unit test. I think it is a good thing when a test can expressed in terms of a simple sentence such as "Given... When ... Then...". Logically, the test method name should be closed to this sentence. The first one will assert that " <strong>given a list of four rows when the the source is the first row and the target is the second one then the list of row should be reordered</strong>". Remark that the target (the <em>InsertIndex</em> in GongWPF API) corresponds to the row instance preceding the inserted item. Being clear with this convention, the GongWPF interfaces are easily mocked using Moq, resulting in the following unit test. We assert that after executing the <em>Drop</em> method the list is<em> club2, club1, club3, club4</em>

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9518156.js' %}

<p>For having a proper case coverage it is also important to assert "negative" situations such as the following one "<strong>given a list of four rows, if the source is the block containing the two last rows and the target is the second one then the drop action should not change the order</strong>"</p>

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9518403.js' %}

Remind, that we have for specification to be able to move a block of contiguous rows at once but we do not want to move two discontinuous blocks. Therefore, the <em>DragOver</em> method should handle properly this situation: the styling that allows insertion should be set in the first situation and not set at all in the second one. To assert this with unit tests, we use the <em>VerifySet</em> methods on the mock object <em>dropInfo</em>. For both properties <em>DropTargetAdorner</em> and <em>Effects</em>, we verify they are set when the selected items forms a contiguous block and not set when the two selected rows are not adjacent. If those conditions are not met the tests would fail, indeed, Moq framework would throw exceptions.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9533498.js' %}

We finish this post by showing the true implementation of the ViewModel. We do not provide the details of the method <em>MoveAllLeft</em> and&nbsp;<em>MoveAllRight</em>&nbsp;they can be found on the <a href="https://github.com/bpatra/MvvMSample">github</a> (they probably can be reviewed and shortened).

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/9537240.js' %}

To conclude, we have shown the basic ingredients for the testing of a ViewModel, this tests suite can be extended to complete a strong code coverage (there are many corner cases in our situation). Not also, that the MVVM pattern allows you to test the command, for example the <em>SaveClick</em>. Thanks to the Moq VerifySet method, you can check that the setter on the&nbsp;<em>UserBet</em>&nbsp;property for the&nbsp;mock&nbsp;<em>Mock<IChampionship> </em>is called (see project on github).

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/03/testseries-e1450467680749.jpg' caption="All tests running successfully" %}

---
layout: post
title: 'Rewriting a tree algorithm with purely functional data structures: the "zippers".'
date: '2013-07-24 23:34:30 +0000'
disqus: false
categories:
- Programming
- Algorithms
- Functional Programming
tags:
- algorithm
- Data structure
- F#
- functional implementation
- Purely functional
- Tree
- functional programming
- BigData
---
This is my first post, it follows a question that I have posted few weeks ago <a title="here" href="http://stackoverflow.com/questions/17364840/implement-tree-builder-with-f">here</a>. A really interesting link provided by a stackoverflow user made me review my question and lead me to write this post. The objective here is to describe the modification of an existing algorithm implementation, from a first try which uses intensively mutability of the underlying data structure to a purely immutable functional implementation. We will show that this can be achieved quite easily when using the appropriate data structures which in our case are the so-called "zippers".

I discovered the F# programming language recently. While implementing some stuff for the discovery of the language I came confronted with the next problem. Given a sequence of branches coming from a tree but accessible one by one in a random order, how to reconstruct (efficiently) a labeled tree. For example, imagine to retrieve your disk paths in a random order e.g. "C:\Foo", "C:\", "C:\Foobar", "C:\Foo1\bar2" etc. and you would like to rebuild your filesystem.

The branches are supposed to be represented by a linked list of string labels. We also assume that the sequence does not contain twice the same branch and it is in valid, in the sense that a labeled n-ary tree can be created with it. There may be many trees that can be built but we will accept any of them, in other words, we do not care about the order of the children of a given node. The n-ary tree data structure is the usual one where the children of a node are represented by a linked list.

I have no doubt that there may exit better solutions but let us focus at the first implementation that came to my mind as a seasoned imperative and an inexperienced functional programmer. The algorithm is recursive and works as follows.

The branch is inserted in the tree using the recursive procedure:

* If the current tree is empty then it is replaced by the branch (as a tree). Except the previous corner case, the invariant loop states that "the label of the current tree node is equal to head of the current branch".<br />

Having said that we explore a step below:

* If the tail of the current branch is empty list then there is nothing to do. Indeed, following the invariant loop, the current branch is actually a sub-branch of the existing tree.<br />
* Else, we search the children of the given node and try to find a match with the next value of the current branch.<br />
  * If such a match exists we are not done yet, we have to go deeper and apply our procedure on the subtree of the matched child with the tail of current branch.<br />
  * If there is no match, we are arrived to an end so we append the current branch (transformed as a tree) to the children list.

Implementing this in F# leads to the following code (provided some help from Leaf Garland). The function that builds the tree is the <em>mergeInto</em>&nbsp;that performs side effects on its first parameter.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6074217.js' %}

Now apply this with a simple example.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6074329.js' %}

However, this implementation is quite frustrating because we have hacked our functional data structure with F# ref cells to enable mutability just for this particular construction. We needed such mutability to perform our "append" operation on the tree. We were focused on a subtree and we could not return a new tree with the branch attached correctly. &nbsp;Because of the recursion,&nbsp;we did not know where we were exactly.

This is were the zippers come into play. The zippers were introduced by Gerard Huet&nbsp;<a title="in this paper" href="http://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/huet-zipper.pdf" target="_blank">in this paper</a>. The authors says that they have probably been "invented at numerous occasions by creative programmers" but never published. I recommend you to have a look on the first fourth pages of this paper, it is very accessible for an academic publication and may help you for the following.

A zipper is a practical implementation of a given data structure, this is why we can say that what follows is a labeled n-ary tree implemented using the zipper pattern. To sum up, the zipper enables you to focus on a subtree but the structure keeps the path that lead you there granting you to return a new immutable instance of the complete tree.

The translation of zippers implementation of Huet's paper from OCAML to F# is straightforward. In the implementation below I reused the good idea from <a title="this post" href="http://www.lshift.net/blog/2010/12/30/f-zipper-with-pipe-forward">this post</a> where the author changed the order of the function arguments to enable F# pipe-forward. The <em>go</em> functions are used for tree traversal while the <em>insert</em> returns a new data structure with the input tree inserted. Most of the implementation of the zippers provided on the web are designed for leaf-labeled trees, so for our case we need to extend the types to support labeled trees. In the code below, we have removed the <em>go_left</em> and <em>insert_left</em> because they were not of any use for the following.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6074448.js' %}

The power of the zippers comes from the <em>Path</em> and <em>Location</em> discriminated unions, even if the focus is on a subtree we know where we are because we kept track of what is on our left, above and on our right. If you want to visualize some zipper I suggest you to read <a title="this post" href="http://blog.ezyang.com/2010/04/you-could-have-invented-zippers/">this post</a>.<br />
You can see that the difference with Huet's implementation on leaf-labeled trees is that the <em>Path</em> type contains the label of the currentPosition (that can be retrieved with the <em>getLabel</em> method). I was in difficulty to implement the <em>go_up</em> method without it (to build the parent node), though I am not completely satisfied with this...

Now, it is time to review our algorithm and we will see that it will become more elegant and less imperative:
* The main difference comes from the fact that we do not have to look for a "matched child" while keeping the focus on the current node. We can go down directly and move right.

* Precisely, the first corner case with the Empty tree stays similar. The invariant loop states "that the parent label of the current node equals the head of the current branch".

* Then, if the label of the node matches the head of the branch, we have to go deeper. If there is no right simbling then this is our destination and we have to append the branch here. Finally, if there is a younger simbling (a node at the right) reapply the procedure but put the focus on him.

In this new implementation, we can append the branch to the good location because we have an <em>insert_right</em> operation. In the previous implementation we could not do this (without modifying once again the tree structure) because we would have gone too deep to append the tree to the list kept by the parent of our node.

Remark that we have not speak the word "zipper" in the description, the zippers are only wrappers that provides efficient and useful operations on our immutable data structure.

So the core algorithm looks now

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6074520.js' %}

We introduce the <em>getZipper</em> function that creates a zipper around a tree and the <em>appendToTree</em> which is the method that we will call effectively (abstracting the zipper). Here how it works with the same branch sequence.

{% include insert-gists.html gisturl='https://gist.github.com/bpatra/6074560.js' %}

So now we have a competitor to our <em>mergeInto</em> method which uses only purely functional and immutable datastructure and which does not require any modification on the exposed tree data structure. Remark that provided the same input sequence of branches the two algorithms do not build the same tree. However, I would not said that the zipper is without default for our case. The zipper structure is quite complex , that is non negligible. We have also added an extra complexity cost, not in the <em>appendToTreeZipper</em> function but in <em>appendToTree,</em> it comes&nbsp;from the <em>root</em> function. After a quick examination of the <em>go_up</em> method an upper bound for the <em>root</em> function complexity can be found, it is the height of the tree multiplied by the number of individuals in the largest sibship.


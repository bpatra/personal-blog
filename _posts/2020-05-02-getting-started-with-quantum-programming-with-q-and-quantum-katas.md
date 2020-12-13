---
layout: post
status: publish
published: true
has_maths: true
title: 'Quantum programming: getting started with Q# and Quantum Katas'
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
wordpress_id: 2341
wordpress_url: http://benoitpatra.com/?p=2341
date: '2020-05-02 15:13:32 +0000'
date_gmt: '2020-05-02 13:13:32 +0000'
featured: true
featured_image_thumbnail:
featured_image: /assets/images/legacy-wp-content/2020/05/qubit-preview.png
hidden: true
categories:
- Programming
- Quantum Computing
tags:
- python
- Q#
- Quantum Computing
- Maths
- Linear algebra
- quantum programming
---

Quantum computing has received a lot of attention in the past years and in fall 2019 <a href="https://www.youtube.com/watch?v=-ZNEzzDcllU" target="_blank">Google claimed</a> they achieved the so-called <a href="https://en.wikipedia.org/wiki/Quantum_supremacy">quantum supremacy</a>. Quantum computing brings with it great promises from its early days, when Richard Feynman and others, imagined that leveraging the quantum properties of subatomic particles could lead to devices with inconmensurable computing power compared to what could be ever achieved with a classical computer.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/05/Richard_Feynman_Nobel-212x300.jpg' caption="Professor Richard Feynman. Nobel prize and one of the forefathers of quantum computing." position_class="image-right" %}

I am no quantum researcher or expert, I cannot reasonably predict who is going to win this "race" for quantum supremacy or even when. However, these recent claims make the race even more exciting to watch. Even if a usable quantum computing chip does not seem to be something we will have at hand in the short term, there is still a lot that can be done now, with simulations for instance.

Among the big players, Microsoft made an interesting move. Indeed, they started building an "open quantum programming community" by releasing end of 2017 their <a href="https://docs.microsoft.com/en-us/quantum/language/" target="_blank">Q# programming language</a>.

Microsoft describes Q# as:

<blockquote>
Q# (Q-sharp) is a domain-specific programming language used for expressing quantum algorithms. It is to be used for writing subroutines that execute on an adjunct quantum processor, under the control of a classical host program and computer. Until quantum processors are widely available, Q# subroutines execute on a simulator.
</blockquote>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/05/1_w9516UckuSEBQdiUOoiHbQ.png' caption="A sphere is often used to represent the concept of Qubit: the fundamental unit of a Quantum capable device. Image source: https://medium.com/@kareldumon/" size_class="small" %}


Actually, Microsoft released a full <a href="https://docs.microsoft.com/en-us/quantum/welcome" target="_blank">Quantum Development Kit</a> on top of the Q# compiler. It is completely free and open source. Following Microsoft habits to do things properly, even in its early days this was really well polished: documentation was pretty neat and complete and even some samples were shipped to help you start. They did pretty good job making all this super attractive, even the name Q# sounds cool, doesn't it?

I started playing around with Q# in spring 2018. I managed to install and ran the provided samples (on my Mac) without any trouble. However, after all this I felt a little stuck. <em>Now so what?</em> Crafting quantum algorithms on my own seemed to be a distant dream, so I stopped there for a couple of months. It seems that the <a href="https://www.microsoft.com/en-us/quantum?rtc=1" target="_blank">Microsoft QuArc team</a> noticed this lack of training programs and guidance. To overcome this they launched end of 2018 the <a href="https://github.com/microsoft/QuantumKatas" target="_blank">Quantum Katas</a>: a series of exercises and tutorials so that "newbies" like me could ramp up at their own pace. It is really well done: very didacting and complete. I definitely recommend this as #1 source for anyone who would like to get started with quantum computing and programming.

In this blog post, I share some of my feedbacks, tips and even resources to help you getting started. As <a href="#maths"> discussed here</a>, to start for real quantum computing you need higher (post-secondary) education in mathematics. However, you can definitely get the substance of what is quantum computing with no maths at all. In all cases, I recommend you this 3-minutes videos, for a quick overview of what quantum computing is.

<iframe width="500" height="281" src="https://www.youtube.com/embed/WVv5OAR4Nik" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><p>A very well done 3-min intro on quantum computing by IBM. If you do not want to jump into what follows and just have an overview of what is quantum computing, that's a good video to watch.</p>

<h2>An overview of Quantum Katas</h2>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/05/K1PL_Berlin_2018-09-16_Female_Kata_108-177x300.jpg' caption="The name kata comes from martial arts and karate. It's a discipline originally aimed at practicing the execution of a movement until perfection. Image source Wikipedia." position_class="image-right"%}

Quantum Katas is a series of tutorials and exercises provided by Microsoft. They come with the form of small challenges that you need to solve using the Q# programming language. They guide you progressively from the very beginning to advanced and hard problems on quantum computing.

Most of the katas are presented as a <a href="https://docs.microsoft.com/en-us/quantum/techniques/operations-and-functions" target="_blank">Q# operation</a> whose implementation is missing and your job is to complete it. Similarly to <a href="https://en.wikipedia.org/wiki/Unit_testing" target="_blank">a unit test,</a> the quantum simulator will validate your submission on a series of test inputs (that is left unknown to the programmer). Usually, completing a kata does not take more than 20 lines of Q# at max.

When executed within a <a href="#notebooks">Jupyter notebook</a>, you benefit from well formatted explanations with beautiful maths equations right next to your Q# code inputs.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/05/Screenshot-2020-05-02-at-11.29.14-1024x892.png' caption="A Q# kata example. It takes the form of an exercice. Fill the operation with code and see if it passes the tests. If you do not understand anything yet, do not worry: the series of tutorials will lead you there." size_class="medium" %}

<h2>What are the real prerequisites to get started with Q# and Quantum Katas?</h2>
On the <a href="https://docs.microsoft.com/en-us/quantum/overview/how-to-learn-quantum-computing">Katas's webpage</a> Microsoft provides the prerequisites to get started. I think it was interesting to provide my point of view here.

<h3 id="maths">Mathematics</h3>
Linear algebra is almost everywhere in quantum computing. Precisely, linear algebra with the field $\mathbb{C}$ of <a href="https://en.wikipedia.org/wiki/Complex_number" target="_blank">complex numbers</a>. As you will learn, a $N$-Qubits system is described by a $2^{N}$ dimensional vector space on $\mathbb{C}$.

I would say that to really get started with quantum computing, <strong>one would need a good knowledge on complex numbers and linear algebra that would correspond more or less to a BSc. in Sciences</strong>. In the french/european universitarian system this corresponds to Licence L2/L3 or Maths Sp&eacute; (for <a href="https://en.wikipedia.org/wiki/Classe_pr%C3%A9paratoire_aux_grandes_%C3%A9coles" target="_blank">preparation classes</a>). I was a maths teaching assistant at University Paris VI for three years, I taught there linear algebra, material and <a href="http://www.lsta.upmc.fr/doct/patra/index.html#enseignement" target="_blank">exercices are still available here (in french)</a>.

The Quantum Katas provide two tutorials about complex numbers and linear algebra. Yet, in my humble opinion, I think this a good refresher on concepts and notations but I doubt one can reasonably learn from scratch and be ready for the rest of Quantum Katas.

<h3>Programming</h3>
At first glance, the Q# syntax looks like <a href="https://en.wikipedia.org/wiki/C_Sharp_(programming_language)">C#</a> syntax. Moreover, Q# is functional by design and one can definitely see inspiration from <a href="https://en.wikipedia.org/wiki/F_Sharp_(programming_language)" target="_blank">F#</a>, the C# cousin's functional language, also running on top of the .NET CLI. For example, variables are immutable by default. But do not worry too much, your interaction with .NET will be limited to the sole installation of .NET Core on your machine (maybe not at all if you go with a <a href="https://github.com/microsoft/QuantumKatas#docker" target="_blank">Docker install</a>).

This is how a piece of Q# looks like. Similarly to its great cousins: F# and C#, it let you switch easily between functional and imperative styles.

<script src="https://gist.github.com/bpatra/6848499c79dacee27553d94bd0c305eb.js"></script>

When completing Quantum Katas, you will not be required to go really deep in the Q# language. Most of the exercices are solved with a couples of lines. To do your katas, you will just have to learn the fundamentals of the language: basic syntax, types, loops, conditional statements and of course use the core of the Q# libraries for Qubits manipulations: Gates, Measurements, Simulations etc.

Contrary, to the maths prerequisites that are underestimated in Quantum Katas introduction, <strong>you absolutely do not need to be a hardcore programmer to get started with Q# and Quantum Katas</strong>.

Let us just point out that the Q# QDK is much more that just a mere Domain Specific Language (DSL) on top of the .NET CLI. It implements a rich <a href="https://docs.microsoft.com/en-us/quantum/language/type-model" target="_blank">type system</a> and comes with an extensive library suite adapted to Quantum Programming. For example, operations are distinguished from functions. In addition, operations have advanced <a href="https://docs.microsoft.com/en-us/quantum/language/type-model#functors" target="_blank">functors</a> support such as <a href="https://en.wikipedia.org/wiki/Adjoint_functors" target="_blank">adjoint</a> and <a href="https://en.wikipedia.org/wiki/Quantum_logic_gate#Controlled_(cX_cY_cZ)_gates" target="_blank">controlled</a> version which makes this very impressive from a language design perspective. No doubt that there are great engineers and researchers at work in the QuArc Team. This also proves that this is a real investment for Microsoft, not just a toy to do some buzz.

<h3>Physics</h3>
Good news here: <strong>you do not necessarily need any previous knowledge on quantum mechanics to get started</strong>. Contrary to maths and computer science, I did not study quantum mechanics. I learned recently the basics.

I would recommend nevertheless some quick onboarding tour on the fundamental concepts on quantum mechanics (see the <a href="#quantum-mechanics">recommended resources below</a>). Good news this is fascinating. I hope you will enjoy as much as I did.

<h2>Some tips and a compilation of good resources available on the web</h2>
While the Quantum Katas, and more generally the Microsoft documentation, point to a lot of great ressources. I thought that it would be interesting sharing what helped me the most.

<h3 id="quantum-mechanics">Accept (quickly) the principles of quantum mechanics</h3>
Before you can start with quantum programming, you just need to <em>accept</em> some of the fundamentals of quantum mechanics: <a href="https://en.wikipedia.org/wiki/Quantum_superposition" target="_blank">superposition</a> and <a href="https://en.wikipedia.org/wiki/Quantum_entanglement" target="_blank">entanglement</a>. I think that you do not need much more than this. I also chose the wording <em>accept</em>, on purpose. Pr Richard Feynman even said to his students:

<blockquote>If you think you understand quantum mechanics, you don't understand quantum mechanics.
</blockquote>
So my advice here is to accept these principles and quick, otherwise you would be stuck there for a very long time. You will have plenty of time to meditate on this but if you want to start quantum computing this will slow you down. And, before I forget, let me also warn you with a common mistake, we beginners do to reassure ourselves when confronted with the shocking reality of quantum mechanics. It is tempting to think that <em>a Qubit in superposition is still Zero or(exclusively) One but because we cannot observe it for some obscure reasons, it is just a modelisation of the possible outcomes by probabilities</em>. That's incorrect: with superposition, they <strong>are</strong> both $|0\rangle$ and $|1\rangle$ <em>at the same time</em>. Yes this is crazy! But there's another world down there at subatomic scale, with different laws...

<iframe width="500" height="281" src="https://www.youtube.com/embed/7B1llCxVdkE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><p>I personally liked this video on superposition and decoherence. Visualizations are great.</p>

I also saw some amazing animations on this website (in French): <a href="http://toutestquantique.fr/dualite/">toutestquantique.fr</a><br />
From the same authors, this video illustrates well the wave-particle duality.

<iframe width="500" height="281" src="https://www.youtube.com/embed/JlsPC2BW_UI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><p>French are not only good at playing soccer (I mean football), they also create great videos on wave-particle duality.</p>

<h3>Do not spend too much time on the Bloch Sphere and quantum circuit visualizations</h3>
The Quantum Katas take an approach "by code" with Q#. This has been really adapted for me. But with other didactic approaches I followed when I started, the Bloch Sphere is often used to represent and visualize 1-Qubit states.

Indeed, a Qubit in the arbitrary (superposed) state $\ket{\psi}$ can be written $\alpha \ket{0} + \beta \ket{1}$, $\alpha, \beta \in \mathbb{C}$ but also $ cos(\frac{\theta}{2}) \ket{0} + e^{i\phi} sin(\frac{\theta}{2})\ket{1}$, $\theta, \phi \in \mathbb{R}$. This leads to a 3D visualization on the <a href="https://en.wikipedia.org/wiki/Bloch_sphere" target="_blank">Bloch Sphere</a>. I allows you to <em>see</em> the actions of the <a href="https://en.wikipedia.org/wiki/Quantum_logic_gate#Notable_examples" target="_blank">most commonly used 1-Qubit gates,</a> such as Hadamard and Pauli gates.. However, again in my humble opinion with my little experience, this has not brought much to me to understand quantum computing and its concepts. In addition, keep in mind that this visualization is limited to 1-Qubit states. You will quickly manipulate multi Qubits systems so the Bloch sphere will not help you much there.


When starting to learn quantum computing, a reference often cited is <a href="https://algassert.com/quirk" target="_blank">Quirk</a>. While it's an amazing project, building visual quantum circuits has not really helped me to "get" the fundamentals of quantum computing and why it can achieve for example these exponential speed ups.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/1200px-Bloch_sphere.svg_.png' caption="The Bloch Sphere and its 3D representation. This is very popular, but has not helped me much while trying to get into quantum computing." size_class="small"  %}

<h3>Adopt quickly the bra-ket notations and get used to tensorial product</h3>
If you come with a mathematical background you probably have not worked with <a href="https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation" target="_blank">bra-ket notations</a> before. If everybody use them in quantum mechanics and computing this is for a reason. As you will learn in the Quantum Katas tutorials, the canonical base for a 3-Qubit systems is composed of the 8 vectors $\ket{000}$, $\ket{001}$, $\ket{010}$... which is much more handy to write compared to a $\mathbb{C}$ 8-dimensional vector for each. Remember, a $N$-Qubit state is represented by a $2^{N}$ dimensional vector. Convince yourself that the bra-ket notations are consistent with the matrix representation you are more familiar with and after that <strong>stick and embrace bra-ket notations</strong>. I also advise you to review the <a href="https://en.wikipedia.org/wiki/Tensor_product" target="_blank">tensor product</a> properties, which is used intensively in quantum computing. In my mathematical studies I had encountered it sometimes (more frequently as an exercise), here it plays a central role.

<h3>Watch this PhD comics video - 6min</h3>
This one is more advanced than the video mentioned in the introduction. Yet, it gives you an amazing tour on what quantum computing is in only 6 minutes.

<iframe width="500" height="281" src="https://www.youtube.com/embed/T2DXrs0OpHU" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><p>From Youtube's description: theoretical Physicists John Preskill and Spiros Michalakis describe how things are different in the Quantum World and how that can lead to powerful Quantum Computers.</p>

<h3>Watch this conference from Andrew Helwer - 1h30</h3>
The conference is lead by a young talented researcher. With humility and great clarity, he onboards an audience of computer scientists to quantum computing. The attendees' questions are also relevant.

<iframe width="500" height="281" src="https://www.youtube.com/embed/F_Riqjdh2oM" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><p>Andrew Helwer's talk: Quantum computing for computer scientists.</p>

<h3 id="notebooks">Use Jupyter notebooks for your Quantum Katas</h3>
When completing Quantum Katas. You will have the choice to run them as Q# projects or <a href="https://docs.microsoft.com/en-us/quantum/install-guide/qjupyter" target="_blank">Jupyter notebooks</a>. I strongly encourage you to use the notebooks. You will benefit from great well formatted tutorials with $ \LaTeX $ formulas.

Quickly, Jupyter is a Python based opensource project which allows you to write code in cells embedded within a web page called a notebook. The code in cells is remotely executed by a webserver <em>kernel</em>. Here the Q# team distributed a Jupyter kernel: <a href="https://github.com/microsoft/iqsharp" target="_blank">IQSharp</a>, performing Q# execution for notebooks. This may sounds a little bit complicated but just follow the instructions to have this setup, you will not regret it.

By the way, I recommend installing Jupyter <a href="https://medium.com/@eleroy/jupyter-notebook-in-a-virtual-environment-virtualenv-8f3c3448247" target="_blank">with pip and virtual environment</a>. With Python, I am not a big fan of Conda and global installs and have always been a promoter of the use of <a href="https://realpython.com/python-virtual-environments-a-primer/" target="_blank">virtual environments</a>.

<h3>Understanding Deutsch&ndash;Jozsa is a good first objective</h3>
After following, the first tutorials and katas on Qubits, Superposition, Measurements etc. I strongly advise you to start with <a href="https://en.wikipedia.org/wiki/Deutsch%E2%80%93Jozsa_algorithm">Deutsch-Jozsa algorithm</a>. Even the problem it solves does not sound <em>sexy</em>, it is definitely the simplest example where quantum computing <em>achieves</em> an exponential speedup.

Shortly, it allows "with one oracle evaluation" to determine if a function $f: \lbrace 0, 1 \rbrace^{N} \rightarrow \lbrace 0, 1 \rbrace$ is either constant or balanced (output the same number of zeros and ones). With a classical computing you would need in the worst case $2^{N-1}+1$ evaluations but with Deutsch-Jozsa algorithm and a quantum computer you would just need one evaluation of the oracle. There are a lot of great explanations of how this works, including the Quantum Katas tutorials. I really think this should be the first one you should try to really understand. It's definitely simpler that <a href="https://en.wikipedia.org/wiki/Shor%27s_algorithm" target="_blank">Shor's</a> or <a href="https://en.wikipedia.org/wiki/Grover%27s_algorithm" target="_blank">Grover's</a> algorithms.

The Quantum Teleportation is often depicted to be the <em>Hello World</em> of quantum programming. However, Deutsch-Jozsa is the algorithm that will really give you the intuition on why the quantum computing provides these incredible algorithmic speedups. If you are interesting on a well explained blog post about Quantum Teleportation, <a href="https://techcommunity.microsoft.com/t5/educator-developer-blog/quantum-teleportation-in-q/ba-p/380602" target="_blank">I would recommend this one.</a>

That's all for this onboarding tour and tips compilation. I hope that you are now really excited to give a try to Quantum Katas. Happy quantum coding!


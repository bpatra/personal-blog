---
layout: post
status: publish
published: true
title: Baby twins deep learning classification with Inception-ResNetV1
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2020-04-27 09:10:28 +0000'
date_gmt: '2020-04-27 09:10:28 +0000'
categories:
- Programming
- Algorithms
- Machine Learning
tags:
- python
- deeplearning
- tensorflow
- GPU
- keras
- machine learning
- neural networks
comments: []
---

Deeplearning techniques have proven to be the most efficient AI tools for computer vision. In this blog post we use a deeplearning convolutional neural network to build a classifier&nbsp;on my baby twins pictures.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/superlittleLandJ-300x281.jpg' caption="A photo of my two girls with annotations. It will be used for building&nbsp;the face recognition dataset. In the blog post, their faces have been blurred for anonymization." position_class="image-right" %}

When it comes to machine learning practical experiments, the first thing anybody needs are some data. When experimenting for hobby, we often rely on some open and popular dataset such as <a href="https://en.wikipedia.org/wiki/MNIST_database">MNIST</a> or the <a href="https://www.kaggle.com/lakshmi25npathi/imdb-dataset-of-50k-movie-reviews">IMDB reviews</a>. However, it is useful for improving to be confronted with challenges on fresh and unworked data.

Since July 2019 (9-months at the time of the writing), I am the happy father of two lovely twin baby girls: L and J. If I have free private data at scale, it is definitely photos of my kids. Indeed, all our families have been taking pictures of them and, thanks to Whatsapp and other communications means, I have been able to collect a great part of them.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Untitled-2-300x238.jpg' caption="Deeplearning and Convnet neural networks are now the state-of-the-art methods for computer vision. Here are Convnet visualizations on a L. photo." %}

In this post, we will use a state-of-the-art deep learning architecture: <a href="https://arxiv.org/abs/1602.07261" target="_blank"><em>Inception ResNetV1</em></a> to build a classifier for photo portraits of my girls. We also take benefit of some pretrained weights from facenet dataset. Before that, we will make a detour by tricking a little bit the problem: this will allow us to check our code snippets and review some nice visualization techniques. Then, the <em>InceptionResNetV1</em> based model will allow us to achieve some interesting accuracy results. We will experiment using <a href="https://keras.io/" target="_blank">Keras</a> backed by <a href="https://www.tensorflow.org/" target="_blank">Tensorflow</a>. We conducted the computing intensive tasks on a GPU machine hosted on <a href="https://azure.microsoft.com" target="_blank">Microsoft Azure</a>.

The code source is available here:&nbsp;<a href="https://github.com/bpatra/twins-recognizer">on Github</a>. The dataset is obviously composed of personal pictures of my family that I do not want to let openly accessible. In this blog post, the faces of my babies have been <strong>intentionally blured to preserve their privacy</strong>. Of course, the algorithms whose results are presented here were run with non obfuscated data.

In this post and in the <a href="https://github.com/bpatra/twins-recognizer" target="_blank">associated source code</a> we reuse some of the models and snippets from the (excellent) book <a href="https://www.amazon.com/Deep-Learning-Python-Francois-Chollet/dp/1617294438" target="_blank">Deep Learning with Python by Fran&ccedil;ois Chollet</a>. We also leverage the <em>InceptionResNetv1</em> implementation <a href="https://sefiks.com/2018/09/03/face-recognition-with-facenet-in-keras/" target="_blank">from Sefik Ilkin Serengil</a>.

Let us start this post by explaining the problem and why it is not as easy as it may seems to be.

<h2>A more complex topic that it seems</h2>
While my baby girls L and J are not identical twins, they definitely are sisters, they do look alike a lot! In addition, the photos were taken since their first days in this world to their 8 months. It is no secret that babies change a lot during their first months. They were born weighing around 2.5 kgs, now they are close to 9 kgs. Even family members whom saw them in their first days have difficult times distinguish them now.

In addition, following their grandmother's home country tradition L and J were shaved at the age of 4 months. Their haircut is not a way to distinguish them: we have photos before the shaving, during hair regrowth and now with middle to long hairs. Also, many photos were taken with a woolen hat or anything else. Consequently, we will be pushing a little the limits of face recognition.

Our objective in this series of experimentation is to build a photo classifier. Precisely, given a photo we would like to make a 2-class prediction: <em>"Is this photo is the one of L or J?"</em>. We assume then that each picture contains one and only one portrait of one of my two baby girls.

I have collected 1000 raw photos that will be used to create the dataset.

<h2>Building the dataset</h2>
<h3>Photo tagging</h3>
In the raw datasets, some photos contain only L, others only J, some both and some none of them. We exploit these photos to extract face pictures for each girl. To do so, we need to locate precisely the faces in the photos first.

For efficient annotation, I have used an opensource tagging software: <a href="https://github.com/microsoft/VoTT" target="_blank">VoTT</a> which is supported by Microsoft. The tagging is pretty straightforward and you can quickly annotate the photos with a very intuitive interface. It took me between one and two hours&nbsp;to tag the full dataset.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-12.49.47-1024x516.png' caption="Efficient photo annotation with the VoTT software. Note also the FC Nantes outfits..." %}

One of the worries of twins parents, is the fear to favor one child over the other. Well, I am not concerned and data speak for me. Here are the results: after the tagging we have a very well balanced tags repartition with a little more than 600 tags for each of the girls.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-11.11.38-178x300.png' caption="The tag repartitions of L and J." %}

Now we will build the picture dataset: where each picture contains the portrait of one of the kid. VoTT provides the tag location within the picture as a JSON format. Therefore, it is easy to crop all files to produce a dataset where each image contains only one kid's face, see <a href="https://github.com/bpatra/twins-recognizer/blob/blogpost1/crop_raw_files.py" target="_blank">this code snippet</a>.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Extract2.png' caption="The extraction process from tagged photos to square cropped images." %}

<h3>Splitting the dataset: train, validation, test</h3>
As always for any machine learning training procedure, one must separate the original dataset between: 1) training data that will be used to fit the model and 2) validation data that will be used to measure performance of the tuned algorithms. Here we go&nbsp;further by keeping also a third untouched test dataset.

It is always easier to work with an equally balanced dataset. Luckily this is almost the case with the original data. Consequently after processing (mainly shuffling and splitting) we obtain the following repartition in our file system:

<script src="https://gist.github.com/bpatra/943790e9a85d8c03e9213a9a2078214e.js"></script>

The code snippets for splitting and shuffling the dataset is available <a href="https://github.com/bpatra/twins-recognizer/blob/blogpost1/prepare_set.py" target="_blank">here</a>.

<h2>Machine setup - GPU Powered VM</h2>
The experiments are conducted with Python 3.6 and Tensorflow GPU 1.15. We use the high level deeplearning library Keras 2.2.4.

We have setup an Ubuntu 18.04 <a href="https://docs.microsoft.com/en-us/azure/virtual-machines/nc-series" target="_blank">NC6 GPU VM on Microsoft Azure</a>. The NC-series VM use Nvidia Tesla K80 graphic card and Interl Xecon E5-2690 for CPU. With the NC6 version we benefit from 1 GPU and 6 vCPU, this setup maked the following computations perfectly acceptable: all experiments lasted less than few minutes.

This is the second time I do the setup of an Ubuntu machine with Cuda/cudNN and Tensorflow, same as before this was a real pain. The <a href="https://www.tensorflow.org/install/gpu" target="_blank">official documentation from Tensorflow</a> is totally incorrect and guides you in the wrong direction. Finally, I managed to have a successful setup with the following Tensorflow-gpu 1.15.0, Keras 2.2.4 and Cuda 10.0 thanks to this <a href="https://stackoverflow.com/a/60185628/1569150" target="_blank">StackOverflow post</a>.

For efficient development, I use VSCode with the new <a href="https://code.visualstudio.com/blogs/2019/07/25/remote-ssh" target="_blank">SSH Remote extensions</a> which make remote development completely seamless. The experiments are also conducted with IPython Jupyter notebook. And once again VSCode provides out-of-the-shelf <a href="https://code.visualstudio.com/docs/remote/ssh#_forwarding-a-port-creating-ssh-tunnel" target="_blank">SSH tunneling</a> to simplify everything.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-15.33.09-e1587935894377.png' caption="Tensorflow outputs confirm that its primary computing device is our Tesla K80 GPU." %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-15.39.52-e1587935965787.png' caption="The nvidia-smi command shows load on the GPU from the Python process." %}

<h2>First, a simplified problem with tricked data to get started</h2>
The experiments provided in this section can be found in <a href="https://github.com/bpatra/twins-recognizer/blob/blogpost1/Twins-Recognition-FAKEDATA.ipynb">this notebook</a>.

Here we will make a small detour by <del datetime="2020-04-26T19:57:35+00:00">simplifying</del> tricking the challenge. We will add easily detectable geometrical shapes in the images.

<h3>Drawing obvious shapes on image classes</h3>
When tackling a datascience project, I always think it is great to start really simple. Here, I wanted to make sure that my code snippets were ok so I decided to trick (temporarily) the problem. Indeed, I drawed geometrical shapes on image classes. Precisely, for any J photo, a rectangle is drawn and, for any L photo, an ellipse is inserted. The size, the shape ratio and the filling color are left random. You can see with the two following examples what this looks like:

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/fakeL-298x300.jpg' caption="An ellipse is drawn on all L photos, for train, validation and test sets." %}

&nbsp;

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/fakeJ-300x290.jpg' caption="A rectangle with random filling color on all J images." %}

Of course this completely workarounds and tricks the face recognition problem. Anyway that's a good starting point to test our setup and code experimentation snippets.

<h3>A simple Convnet trained from scratch</h3>
For this simplified task we use the basic Convnet architecture introduced by Francois Chollet in his book (see the beginning of the post). Basically, it consists of 4 <em>2D-convolutional</em> layers followed by <em>MaxPooling</em> layers. This constitutes the convolutional base of the model. Then the tensors are flatten and a series of <em>Dense</em> and <em>Dropout</em> layers are added to perform the final classification parts.

<script src="https://gist.github.com/bpatra/ab96c1ad1bd4dfc53b26fc4a2070a89a.js"></script>

<h3>97%+ accuracy</h3>
Actually this is no surprise that we are able to achieve great classification performance. The algorithms performs without difficulty. To do so we used the standard <a href="https://nanonets.com/blog/data-augmentation-how-to-use-deep-learning-when-you-have-limited-data-part-2/" target="_blank">Data-augmentation techniques</a>. Note that for this task we skipped the rotations.

<script src="https://gist.github.com/bpatra/1a82598911d01549ebcd0524c2286cd8.js"></script>

After running the training on 30 epochs we observe the following learning curves.

<script src="https://gist.github.com/bpatra/f7c836eea7f4030a8c656a4bf2964935.js"></script>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-16.08.134.png' caption="Training and validation accuracy on tricked data. We achieve strong accuracy without surprise." %}

Now that the results seem satisfactory without sign of overfitting (the validation accuracy grows and stalls). It is time to measure performance on the test sets composed of the 200 pictures left aside.

Accuracy is a key indicator but even with a 2-class classification problem, it is a common error to ignore more subtle information such as the <a href="https://en.wikipedia.org/wiki/Confusion_matrix" target="_blank">confusion matrix</a>. Using the following snippet and the <a href="https://scikit-learn.org/" target="_blank">scikit learn library</a>. We are able to collect a full classification report along a confusion matrix. Again, here all signals are green, and we see the results of a very efficient classifier. Yet, let us not forget that the game has been tricked!

<script src="https://gist.github.com/bpatra/fd302a09afdb54c57b95a3908059cf62.js"></script>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/confusion_matrix_fakedata-300x232.jpg' caption="The confusion matrix with tricked data. We see excellent accuracy, precision and recall." %}

<h3>Going beyond and observe Conv2d learnings with an activation model</h3>
Again, we use a technique well exposed in the Fran&ccedil;ois Chollet's book.

The idea is to build a multi output model based on the successive outputs of the base convolutional layers. Thanks to the successive ReLu layers, we can plot the activation maps from the outputs of these layers. The following visuals illustrate well that our Convnet base model has successfully learned the geometrical shape: the curved stroke of ellipses and the squared edges of rectangles.

<script src="https://gist.github.com/bpatra/584290fbd46f8267e5f4f63eecfe1b6c.js"></script>

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/down_layer_1output-300x246.jpg' caption="On the extracted feature on the bottom layer from the L picture with ellipse. We see in green the activated regions. The ellipsis is strongly activated but also the pacifier." %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/down_layers-300x213.jpg' caption="From the bottom layers of our neural network model, the ellipsis are obviously the most activated regions of the input picture." %}

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/uperlayers-300x152.jpg' caption="With upper layers, it is visible that the patterns that is captured for the classification is the curve of the stroke path of our ellipsis. Similarly, the square corners of the rectangles are captured." %}

<h2>Back to the real face recognition problem</h2>
Now it is time to get back to our original problem: classification of my baby girls without relying on any trick, just with face recognition on the original images. The simple Convnet in the previous section will not be sufficient to build a classifier with significant accuracy. We will need  bigger artillery.

The experiments provided in this section can be found in <a href="https://github.com/bpatra/twins-recognizer/blob/blogpost1/Twins-Recognition-REALDATA.ipynb">this notebook</a>.

<h3>Using the <em>InceptionResNetV1</em> as a base model</h3>
<em>InceptionResNetV1</em> is a deep learning model that has proven to be one of the <a href="https://arxiv.org/abs/1602.07261">state-of-the-art</a> very deep architecture for convolutional networks. It also uses the concept <a href="https://en.wikipedia.org/wiki/Residual_neural_network">Residual Neural Networks</a>.

We use its implementation provided originally by <a href="https://sefiks.com/2018/09/03/face-recognition-with-facenet-in-keras/" target="_blank">Sefik Ilkin Serengil</a> whom was also reusing parts of the implementation provided by <a href="https://github.com/davidsandberg/" target="_blank">David Sandberg</a>.

For our classification problem, we use <em>InceptionResNetV1</em> as the base (then very deep) network. On top of it we flatten the tensors and bring Dense and Dropout layers to serve as classification.

<script src="https://gist.github.com/bpatra/8a98c630326457d682f66d07e7dfb5fd.js"></script>

<h3>Achieving nearly 0.80 accuracy</h3>
We conducted some experiments when trying to make <em>InceptionResNetV1</em> without any prior weights tuning, which means without using pre-trained experimentations (sometimes called Transfer Learning). Without any surprise, the model could not reach significant validation accuracy (i.e. significantly above 0.6 in accuracy). Our dataset, even with data augmentation, is too small to let a deep architecture "learn" what are the key elements that constitute the characteristics of a human face.

Therefore, we reuse pretrained weights from <a href="https://arxiv.org/abs/1503.03832" target="_blank">facenet</a> database, provided by David Sandberg and Sefik Ilkin Serengil in <a href="https://sefiks.com/2018/09/03/face-recognition-with-facenet-in-keras/" target="_blank">his blog post</a>.

<script src="https://gist.github.com/bpatra/8a80e1f723580cf7a9b706df9dcb93e6.js"></script>

Thanks to our GPU we were able to retrain the full model composed of a <em>InceptionResNetV1</em> base with our top layers classifiers. We did not even have to recourse to fine-tuning techniques where the first layers weights need to be frozen.

After a dozen of minutes of training, I was happy to see the following training and validation accuracy curves.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-11.18.18-300x195.png' caption="The training and validation accuracy over the epochs. We see that the validation accuracy reaches 0.80 accuracy." %}

This shows all the positive signs of a successfully trained ML algorithm. Therefore, let us examine the performance on the test dataset, i.e. the one that has not been fed to the algorithm before.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/Screenshot-2020-04-26-at-12.04.22-300x259.png' caption="The final classification report and confusion matrix. We achieves nearly 0.80 of accuracy." %}

The classification reports and confusion matrix on the test dataset confirm the measure on the validation set. We achieve nearly 80% of accuracy. One interesting thing is, from the report, J. looks to be a little be more difficult for our model to classify than L. Honestly, I have no assumption on what could cause this. A deeper analysis by examining layers in the spirit of what has been presented above could be conducted.

<h2>Conclusion</h2>
I did not spend time trying to tune so much the <em>InceptionResNetV1</em> hyperparameters. I also tweaked but only a little the top layers. No doubt that there is room for great improvements here. This can constitute a follow up blog post.

Also, I did not confront other algorithms and deeplearning architectures. I quickly gave a try to the <a href="https://sefiks.com/2018/08/06/deep-face-recognition-with-keras/">Deepface Keras implementation</a> but without significant results. I did not spend time investigating why this was not working. Once again this could be part of an interesting follow up. Ideally, I would also benchmark this <a href="https://github.com/ageitgey/face_recognition" target="_blank">DLib implementation</a>.

By conducting these experiments, I confirm that it is nearly impossible to perform "real" recognition on faces without some kind of pretrained models if you have at hands this small amount of face data.

Finally, I learnt a lot. It is always a good thing to try things on your own data. This is how you learn to tackle real-life problems in datascience.


{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2020/04/JPrediction-278x300.jpg' caption="Our classifier works: it is now able at 80% accuracy to recognize between my two baby girls." %}

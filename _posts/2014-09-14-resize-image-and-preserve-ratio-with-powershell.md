---
layout: post
status: publish
published: true
title: Resize image and preserve ratio with Powershell
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2014-09-14 18:32:22 +0000'
date_gmt: '2014-09-14 16:32:22 +0000'
categories:
- Programming
- Scripting
- Web Development
tags:
- bitmap
- jpeg
- powershell
- ratio
- SEO
comments:
- id: 15557
  author: Ilya
  author_email: kutsev@gmail.com
  author_url: ''
  date: '2016-04-14 09:42:02 +0000'
  date_gmt: '2016-04-14 09:42:02 +0000'
  content: "Awesome script, works like a charm!\r\n\r\nI had to replace all '&amp;quot'
    to ' symbols and that it worked fine"
- id: 16313
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-05-13 08:28:42 +0000'
  date_gmt: '2016-05-13 08:28:42 +0000'
  content: Oh sorry, this is because of the multiple Wordpress migrations some &quote
    replaced some of the double quotes in my scripts....
- id: 19097
  author: Develop3r
  author_email: Develop3r@hotmail.com
  author_url: ''
  date: '2016-10-27 16:07:28 +0000'
  date_gmt: '2016-10-27 16:07:28 +0000'
  content: Thanks for the code works great, I want to change the target output to
    a new folder by setting $imageTarget any thoughts on how I would achieve this
- id: 19107
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-10-27 20:30:04 +0000'
  date_gmt: '2016-10-27 20:30:04 +0000'
  content: "Yes.\r\nFirst your extract the folder full path from the target file name
    and if it does not exist you create it.\r\nYou can insert something like that
    at the beginning of MakePreviewImages.ps1\r\n\r\n[code language=\"powershell\"]\r\n$folderPath
    = [System.IO.Path]::GetDirectoryName($targetPath)\r\nif(!(Test-Path $folderPath)){\r\n
    \  New-Item $folderPath -ItemType Directory\r\n}\r\n[/code]"
- id: 19201
  author: beebleep
  author_email: info@beebleep.rocks
  author_url: ''
  date: '2016-11-01 10:40:46 +0000'
  date_gmt: '2016-11-01 10:40:46 +0000'
  content: "Thanks for this awesome code, does exactly what i needed! Do you btw know
    a way to save to the same file i.e. overwrite the source file instead of creating
    a new one?\r\nCan I also change the location of the script?\r\n\r\nGet-ChildItem
    c:\\totally\\some\\where\\else -Recurse -Include *.jpg | Foreach-Object{\r\n   $newName
    = $_.FullName.Substring(0, $_.FullName.Length - 4) + \"_resized.jpg\"\r\n     c:\\mylocation\\MakePreviewImages.ps1
    $_.FullName $newName 75\r\n   }\r\n\r\nI tried the above but it resulted in 'out
    of memory' errors"
- id: 19202
  author: benoitpatra
  author_email: benoit.patra@gmail.com
  author_url: http://www.benoitpatra.com
  date: '2016-11-01 11:07:20 +0000'
  date_gmt: '2016-11-01 11:07:20 +0000'
  content: "Remind that with Powershell you have access to the .NET framework. This
    is the case here, we access real .NET Bitmap classes. So the same methods and
    techniques are available.\r\nIt looks like that the Save() method does not contain
    a parameter allowing override of an image. You need to delete it on the disk first\r\nhttp://stackoverflow.com/questions/8905714/overwrite-existing-image\r\n\r\nI
    am surprised of your Out of Memory errors. In the script you mention, the images
    are processed one by one. There is probably a memory leak. \r\nI am sorry but
    I do not have time to investigate right now.\r\nCan you try adding $graph.Dispose()
    before $bmpResized.Dispose() ?"
- id: 58313
  author: Andrew
  author_email: supermankelly@hotmail.co.uk
  author_url: ''
  date: '2020-02-24 11:58:13 +0000'
  date_gmt: '2020-02-24 11:58:13 +0000'
  content: "Hi,\r\n\r\nI have current folder as C:\\Data\\ImageResizeTest but seems
    to check under Users for the images. Which part of the script sets the source
    path? So it can be passed as a string?\r\n\r\nGet-ChildItem : Cannot find path
    'C:\\Users\\akelly\\.images' because it does not exist.\r\n\r\nThank you!\r\nAndrew"
- id: 58315
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2020-02-24 17:14:16 +0000'
  date_gmt: '2020-02-24 17:14:16 +0000'
  content: "Actually the original script is a procedure (or function) that writes
    the image at the variable $imageTarget.\r\n\r\nIn the latter script I give a small
    example : here the script recursively resizes all pictures in under the \".images\"
    folder located the current directory.  So there is no place where the script looks
    for \"Users\" directory especially.\r\n\r\nI think that your command line current
    directory is C:\\Users\\akelly (that usually the default) and if you have taken
    my second script \"as-is\" it will also look for the \".images\" directory that
    does not exist on your machine. This explains your error.\r\n\r\nWhat you probably
    want is to ask the script to look into your target directory, just tell it to
    do so:\r\n\r\n[code language=\"\"]\r\nGet-ChildItem \"C:\\Data\\ImageResizeTest\"
    -Recurse -Include *.jpg | Foreach-Object{\r\n   $newName = $_.FullName.Substring(0,
    $_.FullName.Length - 4) + \"_resized.jpg\"\r\n     ./MakePreviewImages.ps1 $_.FullName
    $newName 75\r\n   }\r\n[/code]"
- id: 58332
  author: Andrew
  author_email: supermankelly@hotmail.co.uk
  author_url: ''
  date: '2020-02-26 14:07:37 +0000'
  date_gmt: '2020-02-26 14:07:37 +0000'
  content: "Thanks for reply.  I've now got it working from any required folder and
    call the code as a function since I want it all on one script. I require images
    to be under 1000x1000px. And this works great thanks for those larger on both
    x and y axis. (Example 1194x2189px resized to 545x1000px)\r\n\r\nBut what I currently
    need is the follow...\r\n\r\n1) The code won't resize an image where one axis
    is already under the resize number (in my case 1000px). So an image 600x1500 will
    not resize using height 1000 x width 1000. Can the script be changed to do the
    resize?\r\n2) Also as per the working example, even though 1000x1000 was hard-code
    it stayed in proportion and didn't stretch which is great, but is there an option
    to add the white space so it is the 1000x1000 as specified. \r\n3) How can I change
    this to work for png files?\r\n\r\nAbove is what is important but next on my list
    to work out is...\r\n\r\n4) Do you have any code which can add an additional 30px
    of white around an image? \r\n5) Do you have any script to remove white and make
    a transparent png?\r\n\r\nThanks\r\nAndrew\r\n\r\nFunction ResizeImage(){\r\n
    \   Param ( [Parameter(Mandatory=$True)] [ValidateNotNull()] $imageSource,\r\n
    \   [Parameter(Mandatory=$True)] [ValidateNotNull()] $imageTarget,\r\n    [Parameter(Mandatory=$true)][ValidateNotNull()]
    $quality )\r\n\r\n\r\n    if (!(Test-Path $imageSource)){throw( \"Cannot find
    the source image\")}\r\n    if(!([System.IO.Path]::IsPathRooted($imageSource))){throw(\"please
    enter a full path for your source path\")}\r\n    if(!([System.IO.Path]::IsPathRooted($imageTarget))){throw(\"please
    enter a full path for your target path\")}\r\n    if ($quality -lt 0 -or $quality
    -gt 100){throw( \"quality must be between 0 and 100.\")}\r\n \r\n    [void][System.Reflection.Assembly]::LoadWithPartialName(\"System.Drawing\")\r\n
    \   $bmp = [System.Drawing.Image]::FromFile($imageSource)\r\n \r\n    #hardcoded
    canvas size...\r\n    $canvasWidth = 1000.0\r\n    $canvasHeight = 1000.0\r\n
    \r\n    #Encoder parameter for image quality\r\n    $myEncoder = [System.Drawing.Imaging.Encoder]::Quality\r\n
    \   $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)\r\n
    \   $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder,
    $quality)\r\n    # get codec\r\n    $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|where
    {$_.MimeType -eq 'image/jpeg'}\r\n \r\n    #compute the final ratio to use\r\n
    \   $ratioX = $canvasWidth / $bmp.Width;\r\n    $ratioY = $canvasHeight / $bmp.Height;\r\n
    \   $ratio = $ratioY\r\n    if($ratioX -le $ratioY){\r\n      $ratio = $ratioX\r\n
    \   }\r\n \r\n    #create resized bitmap\r\n    $newWidth = [int] ($bmp.Width*$ratio)\r\n
    \   $newHeight = [int] ($bmp.Height*$ratio)\r\n    $bmpResized = New-Object System.Drawing.Bitmap($newWidth,
    $newHeight)\r\n    $graph = [System.Drawing.Graphics]::FromImage($bmpResized)\r\n
    \r\n    $graph.Clear([System.Drawing.Color]::White)\r\n    $graph.DrawImage($bmp,0,0
    , $newWidth, $newHeight)\r\n \r\n    #save to file\r\n    $bmpResized.Save($imageTarget,$myImageCodecInfo,
    $($encoderParams))\r\n    $graph.Dispose()\r\n    $bmpResized.Dispose()\r\n    $bmp.Dispose()\r\n}\r\n\r\n$imageSourcePath
    = \"C:\\Data\\ImageResizeTest\\images\"\r\n$imageExt = \"jpg\"\r\n$newImageLabel
    = \"_resized\"\r\n\r\nGet-ChildItem $imageSourcePath -Recurse -Include *.$imageExt
    | Foreach-Object{\r\n   $newName = $_.FullName.Substring(0, $_.FullName.Length
    - 4) + \"$newImageLabel.$imageExt\"\r\n   \r\n   ResizeImage $_.FullName $newName
    100\r\n   }"
- id: 58334
  author: Andrew
  author_email: supermankelly@hotmail.co.uk
  author_url: ''
  date: '2020-02-26 15:08:11 +0000'
  date_gmt: '2020-02-26 15:08:11 +0000'
  content: "Resolved 3) and 5)\r\n\r\nI'm not sure why it didn't work the first time
    I tried but..\r\n- switching MineType image/jpeg to image/png \r\n- Change $imageExt
    = \"png\"\r\n\r\nChange \"White\" to \"Transparent\" (But only works for png as
    jpg created with black background)\r\n    $graph.Clear([System.Drawing.Color]::Transparent)\r\n\r\nI
    don't PS so a learning curve for me! Running in debug mode line by line in VS
    Code is helping a lot."
- id: 58335
  author: Andrew
  author_email: supermankelly@hotmail.co.uk
  author_url: ''
  date: '2020-02-26 15:13:11 +0000'
  date_gmt: '2020-02-26 15:13:11 +0000'
  content: Actually I didn't solve 5). Using Transparent only retains transparency.
    It doesn't make a white background transparent :(
- id: 58337
  author: Andrew
  author_email: supermankelly@hotmail.co.uk
  author_url: ''
  date: '2020-02-26 17:11:50 +0000'
  date_gmt: '2020-02-26 17:11:50 +0000'
  content: "Can ignore 1)  it does resize where one side is under the specified size.
    This image was a PNG which wasn't being picked up because I hadn't solved that
    bit yet!\r\n\r\nI should learn to write one message at the end of my day, I know!"
- id: 59337
  author: Benoit Patra
  author_email: benoit.patra@gmail.com
  author_url: https://www.benoitpatra.com
  date: '2020-04-27 18:49:30 +0000'
  date_gmt: '2020-04-27 16:49:30 +0000'
  content: "Hi Andrew,\r\nSorry for late reply. Actually I do not think the image
    manipulation .NET libraries we are using can do 5). Removing transparency is one
    thing but adding transparency is another. Indeed, it needs to be \"smart somewhere\"
    to make such a change.\r\n\r\nFor sure this can be done by any image manipulation
    software such as Gimp: https://www.gimp.org/. I do not know any commandline solution
    that could do that out-of-the-box. You may want to have a look at the imagemagick
    library (https://www.imagemagick.org/)."
---
My recently created company website <a href="http://www.keluro.com">Keluro </a>has two blogs: <a href="http://keluro.com/fr/blog">one in french</a> and <a href="http://www.keluro.com/blog">one in english</a>. The main blog pages are a preview list of the existing posts. I gave the possibility to the writer to put a thumbnail&nbsp;image in the preview. It's a simply <img /> tag where a css class is responsible for the resizing and to display the image in a 194px X 194px box while keeping the original aspect ratio. Most of the time this preview is a reduction of an image that is displayed in the blog post. Everything was fine until I found out that the these blog pages did not received a good mark while inspecting them with <a title="Page Speed Insights" href="http://developers.google.com/speed/pagespeed/insights/">PageSpeedInsights </a>. It basically says that the thumbnails were not optimized enough... For SEO reasons I want these blog pages to load quickly so I needed to resize these images once for all even if it has to duplicate the image.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2014/09/drawingresizingposh.jpg' title="Resizing two pictures with landscape and portrait aspect ratio to make them fill a given canvas." caption="Resizing two pictures with landscape and portrait aspect ratio to make them fill a given canvas." %}

I think that most of us already had&nbsp;to do such kind of image resizing task. You can use many available software to do that: Paint, Office Picture Manager, Gimp, Inkscape etc. However, when it comes to manipulate&nbsp;many pictures, it could be really useful to use a script. Let me share with you this Powershell script that you can use to resize your .jpg pictures. Note that there is also a quality parameter (from 1 to 100) that you can use if you need to compress more the image.

<script src="https://gist.github.com/bpatra/22678266076663c4b594daa56f69c383.js"></script>

Now suppose that you have saved and named the script above "MakePreviewImages.ps1". You may use it in a loop statement such as the following one where we assume that MakePreviewImages.ps1 is located under the current directory and the images are in a subfolder called "images".

<script src="https://gist.github.com/bpatra/efba7d86edad94a8f2c9039e599f5255.js"></script>

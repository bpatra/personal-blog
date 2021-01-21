---
layout: page
title: "Benoit's streaming channel"
sitemap: false
---

Welcome to my live streaming channel, powered by iAdvize  

{% include image-caption.html imageurl='/assets/images/logo_iadvize.webp' title="Benoit Patra" position_class="image-center" size_class="no-border"%}

<script src="https://player.live-video.net/1.2.0/amazon-ivs-player.min.js"></script>
<video id="video-player" playsinline></video>
<script>
  if (IVSPlayer.isPlayerSupported) {
    const player = IVSPlayer.create();
    player.attachHTMLVideoElement(document.getElementById('video-player'));
    player.load("https://894f4aa67ee2.eu-west-1.playback.live-video.net/api/video/v1/eu-west-1.566014947214.channel.KPy1sLklZobs.m3u8");
    player.play();
  }
</script>

<section class="contact-form chat-form">
    <h3>Chat with Benoit's live audience</h3>
      <div class="message-container" id="chat-list">
      </div>
</section>


<section class="contact-form">
  <div id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form"
      class="validate gh-subscribe-form" target="_blank" novalidate>
      <input type="email" value="" name="EMAIL" class="required email subscribe-email" id="mce-EMAIL" placeholder="Type your message to Benoit...">
      <input type="submit" name="subscribe" id="mc-embedded-subscribe" class="button" onclick="addToList()">
  </div>
</section>

<script>

  function addToList(){
    var node = document.createElement("DIV");
    var toAdd = document.getElementById("mce-EMAIL").value;
    var textnode = document.createTextNode(toAdd);
    node.appendChild(textnode);
    document.getElementById("chat-list").appendChild(node); 
  }

</script>



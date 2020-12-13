---
layout: post
status: publish
published: true
title: 'I finally migrated away from Wordpress to Jekyll'
author:
  display_name: Benoit Patra
  login: benoitpatra
  email: benoit.patra@gmail.com
  url: https://www.benoitpatra.com
author_login: benoitpatra
author_email: benoit.patra@gmail.com
author_url: https://www.benoitpatra.com
date: '2020-05-02 15:13:32 +0000'
date_gmt: '2020-05-02 13:13:32 +0000'
featured: true
featured_image_thumbnail:
featured_image: /assets/images/legacy-wp-content/2020/05/qubit-preview.png
hidden: true
categories:
- DevOps
- Web Development
tags:
- jekyll
- github
- azure
- Wordpress
- source control
- migrations
- SEO
comments: []
---

When I started this blog in 2013 I did not want to spend too much time and headache on hosting. I wanted to blog mainly on algorithms and machine learning stuff, I was not so much into Web Development at that time, I wanted to published right away. In those days, the de-facto solution for blog hosting was Wordpress. I did go with a first Wordpress.com hosted solution and my first posts were live. I quickly realized that Wordpress and the least I can say is that I deeply regreted my choice. Try to migitigate by moving my Wordpress blog to Azure, OVH etc. For all subsequent projects, such as Keluro or Talentoday Website, I avoided Wordpress and got into Jekyll a simple static website generator. I posted [in the past about Jekyll](/tag/jekyll/). Yet this blog was still under the evil Wordpress. In this post, I'll describe my migration from an OVH hosted Wordpress to a Jekyll hosted on Azure Static Web Apps leveraging Github actions.

For the solution, I hesitated between a github pages hosted solution or Azure Static Web Apps. Github pages looked to have made some great progress since 2016, when [I posted about](/2016/02/12/hosting-jekyll-generated-site-on-azure-web-app-using-teamcity-automated-deployment/) and pointed some lack of features for a proper hosting. Now both Azure Static Web Apps or Github pages offer free TLS certificates, proper DNS records and the caching mecanism look ok to me. Finally, I decided to go with Azure Static Web Apps because I need

trl;dr yes that's another Wordpress to Jekyll post!
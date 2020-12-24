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

When I started this blog in 2013 I did not want to spend too much time and headache on hosting. I wanted to blog mainly on algorithms and machine learning stuff, I was not so much into Web Development at that time, I wanted to published right away. In those days, the de-facto solution for blog hosting was Wordpress. I did go with a first Wordpress.com hosted solution and my first posts were live. I quickly realized that Wordpress and the least I can say is that I deeply regretted my choice. Try to mitigate by moving my Wordpress blog to Azure, OVH etc. For all subsequent projects, such as Keluro or Talentoday Website, I avoided Wordpress and got into Jekyll a simple static website generator. I posted [in the past about Jekyll](/tag/jekyll/). Yet this blog was still under the evil Wordpress. In this post, I'll describe my migration from an OVH hosted Wordpress to a Jekyll hosted on Azure Static Web Apps leveraging Github actions.

For the solution, I hesitated between a github pages hosted solution or Azure Static Web Apps. Github pages looked to have made some great progress since 2016, when [I posted about](/2016/02/12/hosting-jekyll-generated-site-on-azure-web-app-using-teamcity-automated-deployment/) and pointed some lack of features for a proper hosting. Now both Azure Static Web Apps or Github pages offer free TLS certificates, proper DNS records and the caching policy looks ok to me. Finally, I decided to go with Azure Static Web Apps because the build process I set it up based on Github actions is much more transparent. 

trl;dr yes that's another Wordpress to Jekyll post!

In the following, I'll describe the steps for a successful, and I hope, painless migration.

# Import your posts from Wordpress

Well if you are on the Wordpress, you know that most problem are (unsuccessfully) tackled by a plugin. I tried to use the [`Jekyll Exporter`](https://wordpress.org/plugins/jekyll-exporter/) plugin  of course that was unsuccessfully. 

Then I decided to go with the basic [Jekyll importer](https://import.jekyllrb.com/docs/wordpress/)

````
 JekyllImport::Importers::WordPress.run({
      "dbname"         => "",
      "user"           => "",
      "password"       => "",
      "host"           => "localhost",
      "port"           => "3306",
      # other stuff
    })
``` 


## Use an SQL Dump and a docker MySQL

You'll notice that you need to connect the remote Wordpress database. With OVH hosted Wordpress, database are not accessible directly from the internet (which is a good thing). My advice is that you should not probably try to access the database and modify the settings of the VPC. While it is feasible, it is quicker to use an SQL dump from OVH (click export)

Then, you can start a MySQL database directly in a docker image. You do not even have to map to a volume because it is just a matter of minutes to use this database to generate you jekyll formated post. Once you have an empty SQL dea
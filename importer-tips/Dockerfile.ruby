FROM ruby:2.7.2

RUN apt-get update && apt-get install -y locales
RUN echo "en_US UTF-8" > /etc/locale.gen
RUN locale-gen en_US.UTF-8

ENV SITE_ENV=production
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /blog

RUN gem install bundler
RUN gem install unidecode sequel mysql2 htmlentities
RUN gem install jekyll-import
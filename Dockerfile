FROM debian:wheezy
# Cribbed from https://github.com/CenturyLinkLabs/ruby-base-image/blob/master/1.9/Dockerfile

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      curl \
      libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev \
      libpq-dev \
      git \
  && rm -rf /var/lib/apt/lists/*

ENV RUBY_MAJOR 1.9
ENV RUBY_VERSION 1.9.3-p547

RUN echo 'gem: --no-document' >> /.gemrc

RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN gem install --no-document bundler pg
RUN git config --global color.ui auto \
    && git config --global user.email "kevin@littlejohn.id.au" \
    && git config --global user.name "Kevin Littlejohn" \
    && git config --global push.default current \
    && git config --global github.user silarsis
RUN cd /usr/local && git clone git://github.com/rubygems/rubygems.org
ADD database.yml /usr/local/rubygems/config/database.yml
RUN cd /usr/local/rubygems && bundle install vendor/bundler_gems
RUN cd /usr/local/rubygems && rake db:create db:migrate

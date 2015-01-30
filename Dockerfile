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

ENV RUBY_MAJOR 2.0
ENV RUBY_VERSION 2.0.0-p481

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
WORKDIR /usr/local/rubygems.org
ADD database.yml /usr/local/rubygems.org/config/database.yml
ADD redis.rb /usr/local/rubygems.org/config/initializers/redis.rb
RUN echo "gem 'therubyracer'" >> Gemfile
RUN bundle install --path vendor/bundle
ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh

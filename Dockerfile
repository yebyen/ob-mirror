
ARG RVM_RUBY_VERSIONS="2.6.2"
FROM kingdonb/docker-rvm
ENV APPDIR="/home/${RVM_USER}/ob-mirror"

# install 'ex' to do some manhandling of the schema file for loading
RUN apt-get update && apt-get install -y --no-install-recommends \
  vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists/*

# set the time zone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "America/New_York" > /etc/timezone
RUN unlink /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# migrate the database
RUN mkdir ${APPDIR}
WORKDIR ${APPDIR}
COPY sqlite.schema /tmp/
RUN touch /tmp/sqlite.schema && ex -c '1d2|$d|x' /tmp/sqlite.schema
RUN sqlite3 beegraph.sqlite < /tmp/sqlite.schema

RUN chown ${RVM_USER} ${APPDIR}/beegraph.sqlite ${APPDIR}
USER ${RVM_USER}
ENV RUBY=2.6.2

# include the ruby-version and Gemfile for bundle install
ADD Gemfile Gemfile.lock .ruby-version ${APPDIR}/
RUN  bash --login -c 'bundle install'

# include the app source code
ADD .   ${APPDIR}
# the app is executed through the README file
CMD  bash -c 'source /etc/profile.d/rvm.sh && ./README'

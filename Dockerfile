
ARG RVM_RUBY_VERSIONS="2.6.2"
FROM kingdonb/docker-rvm
ENV APPDIR="/home/${RVM_USER}/ob-mirror"

# install 'ex' to do some manhandling of the schema file for loading
RUN apt-get update && apt-get install -y --no-install-recommends \
  vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir ${APPDIR}
COPY sqlite.schema /tmp/
RUN chown ${RVM_USER} ${APPDIR} /tmp/sqlite.schema
USER ${RVM_USER}
ENV RUBY=2.6.2

ADD Gemfile Gemfile.lock .ruby-version ${APPDIR}/
WORKDIR ${APPDIR}
RUN  bash --login -c 'bundle install'

ADD .   ${APPDIR}

CMD  bash -c 'source /etc/profile.d/rvm.sh && ./README'

# migrate the database
RUN touch /tmp/sqlite.schema && ex -c '1d2|$d|x' /tmp/sqlite.schema
RUN sqlite3 beegraph.sqlite < /tmp/sqlite.schema

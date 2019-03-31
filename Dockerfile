
ARG RVM_RUBY_VERSIONS="2.6.2"
FROM kingdonb/docker-rvm
ENV APPDIR="/home/${RVM_USER}/ob-mirror"

RUN mkdir ${APPDIR} && chown ${RVM_USER} ${APPDIR}
USER ${RVM_USER}
ENV RUBY=2.6.2

ADD Gemfile Gemfile.lock .ruby-version ${APPDIR}/
WORKDIR ${APPDIR}
RUN  bash --login -c 'bundle install'

ADD .   ${APPDIR}

CMD  bash -c 'source /etc/profile.d/rvm.sh && ./README'

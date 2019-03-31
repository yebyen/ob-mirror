
ARG RVM_RUBY_VERSIONS="2.6.2"
FROM kingdonb/docker-rvm
USER ${RVM_USER}
ENV RUBY=2.6.2

ADD .   /home/rvm/ob-mirror
WORKDIR /home/rvm/ob-mirror

RUN  bash --login -c 'bundle install'

CMD  bash -c 'source /etc/profile.d/rvm.sh && ./README'

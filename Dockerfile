
ARG RVM_RUBY_VERSIONS="2.6.2"
FROM kingdonb/docker-rvm
USER ${RVM_USER}
ENV RUBY=2.6.2
CMD rvm ${RUBY} do irb

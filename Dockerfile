# or v1.0-onbuild
FROM fluent/fluentd:stable-debian-onbuild

USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo -u fluent gem install \
        fluentd-ui \
        fluent-plugin-elb-access-log \
        fluent-plugin-elasticsearch \
 && sudo -u fluent gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

USER fluent
ENTRYPOINT ["\/bin\/bash", "\/auto_entryPoint.sh"]
CMD ["fluentd-ui", "start"]

EXPOSE 9292 24224 5140


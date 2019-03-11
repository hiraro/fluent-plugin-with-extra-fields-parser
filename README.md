# fluent-plugin-with-extra-fields-parser


## Installation

```
$ /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-with-extra-fields-parser
```

## Usage

```
####
## Source descriptions:
##

## syslog
<source>

  # I want to process the syslog of my yamaha rtx1100...

  # example output format 1.
  # [INSPECT] PP[01][out][101] TCP xxx.xxx.xx.xxx:xxx > xxx.xx.
xx.xxx:80 (2016/02/23 10:59:24)

  # example output format 2.
  # PP[01] Rejected at IN(2000) filter: TCP xx.xxx.xxx.xx:xxx

  type syslog
  tag raw.rtx1100
  format none

</source>

####
## Output descriptions:
##

<match raw.rtx1100.**>

  # ...so I use tagomoris/fluent-plugin-parser

  type parser
  key_name message

  # ...and repeatedly/fluent-plugin-multi-format-parser

  format multi_format
  remove_prefix raw
  add_prefix parsed

  <pattern>

      # ...and this plugin

      format with_extra_fields

      base_format /^\[INSPECT\]\s+(?<target>.+)\[(?<direction>.+)\]\[(?<filter_num>\d+)\]\s+(?<proto>.+)\s+(?<src_ip>.+):(?<src_port>.+)\s+>\s+(?<dest_ip>.+):(?<dest_port>.+)\s+\((?<time>.+)\)$/
      time_format '%Y/%m/%d %H:%M:%S'

      # ...to embed log_type field

      extra_fields { "log_type": "inspect" }

  </pattern>
  <pattern>

      format with_extra_fields

      base_format /^(?<target>.+)\s+Rejected\s+at\s+(?<direction>.+)\((?<filter_num>\d+)\)\s+filter:\s+(?<proto>.+)\s+(?<src_ip>.+):(?<src_port>.+)\s+>\s+(?<dest_ip>.+):(?<dest_port>.+)$/

      extra_fields { "log_type": "reject" }

  </pattern>
</match>


<match parsed.rtx1100.**>

  # you'll get log_type here.
  # so, rewrite the tag using the log_type field
  # with fluent/fluent-plugin-rewrite-tag-filter

  type rewrite_tag_filter

  rewriterule1 log_type   ^inspect$       rtx1100.inspect
  rewriterule2 log_type   ^reject$        rtx1100.reject

</match>

<match rtx1100.inspect.**>

  # and store into elasticsearch
  # with uken/fluent-plugin-elasticsearch

  type elasticsearch
  logstash_format true
  logstash_prefix rtx1100-inspect
  include_tag_key true
  tag_key @log_name
  hosts localhost:9200
  buffer_type memory
  num_threads 1
  flush_interval 60
  retry_wait 1.0
  retry_limit 17

</match>

<match rtx1100.reject.**>

  type elasticsearch
  logstash_format true
  logstash_prefix rtx1100-reject
  include_tag_key true
  tag_key @log_name
  hosts localhost:9200
  buffer_type memory
  num_threads 1
  flush_interval 60
  retry_wait 1.0
  retry_limit 17

</match>
```


## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/hiraro/fluent-plugin-with-extra-fields-parser).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

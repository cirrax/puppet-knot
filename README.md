# knot puppet module


#### Table of Contents

1. [Overview](#overview)
1. [Usage](#usage)
1. [Reference](#reference)
1. [Contributing](#contributing)

## Overview

Puppet module to install knot dns and optionaly create dns records in the domain.

## Usage

Although it should be possible to use this module without hiera, the intenion is to use
hiera for all configurations.

This said, the following manifest is enough:

```puppet
include 'knot'
```

A domain configuration could look like: 
```yaml
knot::domains:
  exampe.org:
    comment: 'example.org domain'
      zone_soa_mname: 'ns0.example.org.'
      manage_zone: true
      zone_nameservers:
        - 'ns0.example.org.'
      zone_records:
      - rname: 'ns0'
        rcontent: '127.0.0.1'
      - rname: 'ns0'
        rtype: 'AAAA'
        rcontent: '::1'
```

## Reference

The detailed configuration of all parameters is found in the REFERENCE.md file generated from
the strings in the manifests.

## Contributing

Please report bugs and feature request using GitHub issue tracker.

For pull requests, it is very much appreciated to check your Puppet manifest with puppet-lint
and the available spec tests in order to follow the recommended Puppet style guidelines
as Voxpupuli lives themn.

### Authors

This module is mainly written by [Cirrax GmbH](https://cirrax.com).

See the [list of contributors](https://github.com/cirrax/puppet-knot/graphs/contributors)
for a list of all contributors.

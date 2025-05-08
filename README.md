# Puppet sf_facts module

## Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Links](#links)

## Description

This module contains Puppet facts related to Solarflare NICs.

### solarflare_adapters fact

This fact returns Array of physical adapters, each containing an Array of network interface names, belonging to the physical card.

## Usage

Please find some examples below.

### Example 1. Check if there is any Solarflare NIC in the system

```puppet
if $facts.get('solarflare_adapters', []).length > 0 {
  # Do something if any Solarflare NIC is present
}
```

### Example 2. Configure each Solarflare NIC using `jay7x/sfboot` module

```puppet
$facts.get('solarflare_adapters', []).each |$nics| {
  # Use 1st NIC of a physical card to configure global parameters
  sfboot_adapter { $nics[0]:
    boot_image       => 'all',
    firmware_variant => 'full-feature',
  }

  # Configure per-NIC parameters
  $nics.each |$nic| {
    sfboot_adapter { $nic:
      boot_type => 'pxe',
      switch_mode => 'partitioning-with-sriov',
      vf_count => 2,
      pf_count => 4,
      pf_vlans => [0, 100, 110, 120],
    }
  }
}
```

## Limitations

* This module was tested on the following OS list at the moment:
  * Debian 11, 12

## Links

* `jay7x/sfboot` module: <https://github.com/jay7x/puppet-sfboot>

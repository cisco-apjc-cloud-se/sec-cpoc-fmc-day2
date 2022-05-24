### New NAT Policy ###
resource "fmc_ftd_nat_policies" "dmz_nat" {
  name = "CPOC DMZ NAT Policy"
  description = "CPOC DMZ NAT Policy built by Terraform"
}

data "fmc_network_objects" "any_ipv4" {
  name = "any-ipv4"
}

resource "fmc_ftd_manualnat_rules" "internet_snat" {
  nat_policy = fmc_ftd_nat_policies.dmz_nat.id
  description = "Internet Egress Source NAT to Interface"
  nat_type = "dynamic"
  section = "after_auto"
  target_index = 1
  source_interface {
    id = data.fmc_security_zones.inside.id
    type = data.fmc_security_zones.inside.type
  }
  destination_interface {
    id = data.fmc_security_zones.internet.id
    type = data.fmc_security_zones.internet.type
  }
  original_source {
    id = data.fmc_network_objects.any_ipv4.id
    type = data.fmc_network_objects.any_ipv4.type
  }
  translate_dns = false

  pat_options {
    interface_pat = true
  }
}

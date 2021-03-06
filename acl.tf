### New Access Policy ###
resource "fmc_access_policies" "dmz_acp" {
  name = "CPOC DMZ Access Policy built by Terraform"
  default_action = "block" # permit
  # default_action_base_intrusion_policy_id = data.fmc_ips_policies.ips_policy.id
  default_action_send_events_to_fmc = "true"
  default_action_log_begin          = "true"
  default_action_log_end            = "true"
  # default_action_syslog_config_id  = data.fmc_syslog_alerts.syslog_alert.id
}

resource "fmc_access_rules" "inside_internet" {
  acp                 = fmc_access_policies.dmz_acp.id
  section             = "mandatory"
  name                = "Inside-Internet"
  action              = "allow"
  enabled             = true
  # enable_syslog = true
  # syslog_severity = "alert"
  send_events_to_fmc  = true
  log_files           = false
  log_end             = true
  # ips_policy = data.fmc_ips_policies.ips_policy.id
  # syslog_config = data.fmc_syslog_alerts.syslog_alert.id
  # new_comments = [ "New", "comment" ]

  source_zones {
    source_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
  destination_zones {
    destination_zone {
      id    = data.fmc_security_zones.internet.id
      type  = data.fmc_security_zones.internet.type
    }
  }
}

resource "fmc_access_rules" "inside_inside" {
  acp                 = fmc_access_policies.dmz_acp.id
  section             = "mandatory"
  name                = "Inside-Inside"
  action              = "allow"
  enabled             = true
  # enable_syslog = true
  # syslog_severity = "alert"
  send_events_to_fmc  = true
  log_files           = false
  log_end             = true
  # ips_policy = data.fmc_ips_policies.ips_policy.id
  # syslog_config = data.fmc_syslog_alerts.syslog_alert.id
  # new_comments = [ "New", "comment" ]

  source_zones {
    source_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
  destination_zones {
    destination_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
}

resource "fmc_access_rules" "internet_ingress" {
  acp                 = fmc_access_policies.dmz_acp.id
  section             = "mandatory"
  name                = "Internet-IKS-IngressLB"
  action              = "allow"
  enabled             = true
  # enable_syslog = true
  # syslog_severity = "alert"
  send_events_to_fmc  = true
  log_files           = false
  log_end             = true
  # ips_policy = data.fmc_ips_policies.ips_policy.id
  # syslog_config = data.fmc_syslog_alerts.syslog_alert.id
  # new_comments = [ "New", "comment" ]

  source_zones {
    source_zone {
      id    = data.fmc_security_zones.internet.id
      type  = data.fmc_security_zones.internet.type
    }
  }
  destination_zones {
    destination_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
  source_networks {
    source_network {
      id = data.fmc_network_objects.any_ipv4.id
      type =  data.fmc_network_objects.any_ipv4.type
    }
  }
  destination_networks {
    destination_network {
      id = fmc_host_objects.iks1_ingress_int.id
      type = fmc_host_objects.iks1_ingress_int.type
    }
  }
  destination_ports {
    destination_port {
      id = data.fmc_port_objects.http.id
      type =  data.fmc_port_objects.http.type
    }
  }
}

#orchestration

resource "pagerduty_event_orchestration" "my_orchest" {
  name = "Cisco Orchestration"
  description = "Send events to a pair of services"
  team = data.pagerduty_team.cisco-terraformteam.id
}

resource "pagerduty_service" "serverservice" {
  name                    = "serverservice"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Ciscoescalationpolicy1.id
  alert_creation          = "create_alerts_and_incidents"
  incident_urgency_rule {
      type    = "constant"
      urgency = "severity_based"
    }
  
}

resource "pagerduty_service" "criticalservice" {
  name                    = "criticalservice"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Ciscoescalationpolicy1.id
  alert_creation          = "create_alerts_and_incidents"
  incident_urgency_rule {
      type    = "constant"
      urgency = "severity_based"
    }
  alert_grouping_parameters{
    type   = "content_based"
    config{
      aggregate = "all"
      fields = ["summary","severity"]
    }
  }
}

resource "pagerduty_service" "warningservice" {
  name                    = "warningservice"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Ciscoescalationpolicy1.id
  alert_creation          = "create_alerts_and_incidents"
  incident_urgency_rule {
      type    = "constant"
      urgency = "severity_based"
    }
}

resource "pagerduty_service" "unrouted" {
  name                    = "unrouted"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.Ciscoescalationpolicy1.id
  alert_creation          = "create_alerts_and_incidents"
  incident_urgency_rule {
      type    = "constant"
      urgency = "severity_based"
    }
  alert_grouping_parameters{
    type   = "content_based"
    config{
      aggregate = "all"
      fields = ["summary","severity"]
    }
  }
}


#route for orchestration

resource "pagerduty_event_orchestration_router" "router" {
  event_orchestration = pagerduty_event_orchestration.my_orchest.id
  set {
    id = "start"
     rule {
        label = "critical alerts"
      condition {
        expression = "event.severity  matches 'critical'"
      }
      actions {
        route_to = pagerduty_service.criticalservice.id
      }
    }
    
    rule {
      label = "Events relating to our disk"
      condition {
        expression = "event.summary matches part 'DISK at 99%'"
      }
      condition {
        expression = "event.source matches part 'prod-datapipe03'"
      }
      actions {
        route_to = pagerduty_service.serverservice.id
      }
    }
    
    rule {
        label = "warning alerts"
      condition {
        expression = "event.severity  matches 'warning'"
      }
      actions {
        route_to = pagerduty_service.warningservice.id
      }
    }
  } 
  catch_all {
    actions {
      route_to = pagerduty_service.unrouted.id
    }
    
  }
}

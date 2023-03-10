
data "pagerduty_user" "AnudeepVaduka" {
  email = "avaduka@cisco.com"
}
data "pagerduty_team" "cisco-terraformteam" {
  name = "cisco-terraformteam"
}
data "pagerduty_priority" "p1" {
  name = "P1"
}
resource "pagerduty_user" "user1" {
  name = "Saroj Kumar"
  role    = "admin"
  email = "saroj@cisco.com"
  description   = "user details"
  job_title = "user1"
}

resource "pagerduty_user" "user2" {
  name = "Divi venkat"
  role    = "user"
  email = "divi@cisco.com"
  description   = "user details"
  job_title = "user2"
}
resource "pagerduty_team_membership" "team1" {
  user_id = "PGU47PQ"
  team_id = "PS2RTWK"
  role    = "manager"
}

resource "pagerduty_team_membership" "cisco-terraformteam" {
  user_id = pagerduty_user.user1.id
  team_id = "PS2RTWK"
  role    = "manager"
}

resource "pagerduty_team_membership" "cisco-terraformteam2" {
  user_id = pagerduty_user.user2.id
  team_id = "PS2RTWK"
  role    = "responder"
}

#escalation policy

resource "pagerduty_escalation_policy" "Ciscoescalationpolicy1" {
  name      = "Cisco Escalation Policy1"
  num_loops = 2
  teams     = ["PS2RTWK"]

  rule {
    escalation_delay_in_minutes = 10
    target {
      type = "user_reference"
      id   = "PGU47PQ"
    }
    target {
      type = "user_reference"
      id   = pagerduty_user.user1.id
    }
  }
}



data "pagerduty_user" "AnudeepVaduka" {
  email = "avaduka@cisco.com"
}
data "pagerduty_team" "cisco-terraformteam" {
  name = "cisco-terraformteam"
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

#code to backup terraform state file
provider "aws" {
   region ="us-east-1"
   access_key = "AKIAVFXNYMGJ4CUKI7PP"
  secret_key = "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"
   }

resource "aws_s3_bucket" "terraform_state_s3" {
 bucket = "terraform-grafana-pagerduty-state"
}

resource "aws_s3_bucket_versioning" "terraform_version" {
 bucket = aws_s3_bucket.terraform_state_s3.id
 versioning_configuration {
  status = "Enabled"
  }
}

terraform {
  backend "s3" {
    #Replace this with your bucket name!
    bucket         = "terraform-grafana-pagerduty-state"
    key            = "pd/s3/terraform.tfstate"
    region         = "us-east-1"
    access_key = "AKIAVFXNYMGJ4CUKI7PP"
  secret_key = "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"
        }
}

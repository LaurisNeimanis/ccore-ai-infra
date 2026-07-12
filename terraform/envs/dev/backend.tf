# -----------------------------------------------------------------------------
# LOCAL BACKEND — DEMO ONLY
# -----------------------------------------------------------------------------
# This backend is intentionally local.
# - No S3 bucket
# - No remote locking
# - No remote state
#
# In real production you ALWAYS use:
#   backend "s3" {
#     bucket         = "company-terraform-state"
#     key            = "envs/dev/terraform.tfstate"
#     region         = "eu-central-1"
#     use_lockfile   = true
#   }
# -----------------------------------------------------------------------------
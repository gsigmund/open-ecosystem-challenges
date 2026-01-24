# ============================================================================
# Integration Test - Root Configuration
# ============================================================================
#
# Note: This test uses a separate mock API on port 9000 to avoid conflicts
#
# Run from the intermediate/ directory:
#   make test-integration
# ============================================================================

provider "google" {
  project = "the-modular-metropolis"
  region  = var.region

  # Point to the TEST mock GCP API (separate instance on port 30105)
  storage_custom_endpoint = "http://localhost:9000/storage/v1/"
  sql_custom_endpoint     = "http://localhost:9000/"

  # Skip authentication since we're using a mock API
  access_token = "a-super-secure-token"
}

# ============================================================================
# Test: Apply Infrastructure and Verify Districts
# ============================================================================
run "apply_districts" {
  command = apply

  assert {
    condition = (
      output.districts["north-market"].vault.name == "cloudhaven-north-market-vault" &&
      output.districts["south-bazaar"].vault.name == "cloudhaven-south-bazaar-vault" &&
      output.districts["scholars-district"].vault.name == "cloudhaven-scholars-district-vault"
    )
    error_message = "Invalid vault name for district."
  }

  assert {
    condition = (
      output.districts["north-market"].ledger.disk_size == 20 &&
      output.districts["south-bazaar"].ledger.disk_size == 10 &&
      output.districts["scholars-district"].ledger.disk_size == 50
    )
    error_message = "Invalid disk size for district."
  }
}

module "vazz-account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = "vazz-account@gft-aws.com"
    AccountName  = "vazz-account"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Infrastructure"
    # Syntax for nested OU
    # ManagedOrganizationalUnit = "Network (ou-sa0f-8eu78feo)"
    SSOUserEmail     = "vazz-account@gft-aws.com"
    SSOUserFirstName = "Vazz"
    SSOUserLastName  = "Acc"
  }

  account_tags = {
    "ABC:Owner"       = "vazz-account@gft-aws.com"
    "ABC:Division"    = "Infrastructure"
    "ABC:Environment" = "Dev"
    "ABC:CostCenter"  = "123456"
    "ABC:Vended"      = "true"
    "ABC:DivCode"     = "102"
    "ABC:BUCode"      = "ABC003"
    "ABC:Project"     = "123456"
  }

  change_management_parameters = {
    change_requested_by = "Network team"
    change_reason       = "Creating new account"
  }

  custom_fields = {
    custom1 = "a"
    custom2 = "b"
  }

  account_customizations_name = "network_customizations"
}


data "aws_lambda_invocation" "SSO" {
  function_name = aws_lambda_function.lambda_function_SSO.function_name

  input = <<JSON
{
  "target_Id": "${module.vazz-account.accountid}",
  "key2": "value2"
}
JSON
}

output "result_entry" {
  value = jsondecode(data.aws_lambda_invocation.SSO.result)["key1"]
}

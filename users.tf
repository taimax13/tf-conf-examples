##Because Terraform and JavaScript have separate type systems, 
##this provider must therefore translate values from the vars 
##mapping into JavaScript and translate the result value from JavaScript.

terraform {
  required_providers {
     javascript = {
      source = "apparentlymart/javascript"
      version = "0.0.1"
    }
 
  }
}

resource "random_string" "random" {
  length           = 8
  special          = true
  override_special = "/@£$"
}

data "local_file" "getJsonFile" {
    filename = "/home/talexm/Documents/vscodepr/terraform/project1/tf-conf-examples/1/users.json"
}

locals {
   json_data = jsondecode(data.local_file.getJsonFile.content)
}

output "users" {
  value = [
    [ for k, v in local.json_data.users :  v ]
    #for s in local.json_data.users: yamlencode({"key":join("",["user["],[index(local.json_data.users,s)],["].name"]), "value":s.name, "key":1, "b":2})
    # }) #bcrypt(random_string.random.result)
  ]

}



terraform {
  backend "s3" {
	    bucket   = "tfstatefileprash"
	    key = "tfstate_version"
	    region = "ap-south-1"
	    encrypt = false
	    access_key  = "***"
	    secret_key  = "****"
 }
}

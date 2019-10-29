backend "s3" {
	bucket   = "tfstatefileprash"
	key = "tfstate_version"
	region = "us-east-1"
	encrypt = false
	access_key  = "AKIAZ4XPBOBOTCV5KNWC"
	secret_key  = "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"
	#auth_url    = "https://identity-3.eu-de-1.cloud.sap/v3"
	#domain_name = "hcm"
}
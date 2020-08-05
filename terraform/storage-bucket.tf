terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    region                      = "ru-central"
    bucket                      = "cloud-sergey-werk-terraform-state"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true

    # Real AWS should reply to a simple metadata request.
    # Skip it since it doesn't supported by Yandex-Object-Storage (yet?).
    skip_metadata_api_check = true

    # Terraform variables are not allowed here.

    # NOT WORKING! (aws-sdk-go doesn't support loading configuration for non-aws endpoints, Aug 2020)
    #shared_credentials_file = "~/current/otus-devops/yc/storage_credeintials"
    #profile = "default"

    # Checked with Terraform 0.12.29
    # There are three options:
    # 1. to specify `access_key` and `access_key` here,
    # 2. to set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env. variables,
    # 3. to set AWS_SHARED_CREDENTIALS_FILE env. variable.
    #

    # NOT WORKING with Yandex Object Storage.
    # encrypt = "true"

    # State Locking is supported via AWS DynamoDB (nothing similar in Yancex Cloud)
  }
}

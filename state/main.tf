provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias   = "ephemeral"
  profile = "ephemeral"
  region  = "eu-west-2"
}

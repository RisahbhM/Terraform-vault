provider "aws" {
  region = "us-west-1"
}

provider "vault" {
  address = "http://13.57.240.243:8200" # Corrected address with "http://"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = " 9326cc3c-8302-9374-4d17-8bb72030fb72"
      secret_id = " ce6437fe-b779-db44-de35-93a3b94a47b8"
    }
  }
}

data "vault_kv_secret_v2""example" {
  mount = "kv"
  name  = "rishma-secret"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-07d2649d67dbe8900"
  instance_type = "t2.micro"

  tags = {
    Name   = "rishma"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}



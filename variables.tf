variable "secret" {
  default = {
    Password = "password"
    Role = "arn:aws:iam::XXXXXXXXXX:role/sftp_example_role"
    HomeDirectory = "/example-bucket"
    PublicKey = "ssh-rsa- ..."
  }
  type = map(string)
}

variable "bucket_name" {
  default = "example-bucket"
}

variable "secret_name" {
  default = "SFTP/example"
}



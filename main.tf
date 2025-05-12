variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "zone_id" {
  default = "Z040862479ELHY34R71D"
}

variable "tools" {
  default = {
    vault = {
      instance_type = "t2.micro"
      ports          = 8200
    }
  }
}

module "tool-infra" {
  source = "./module-infra"
  for_each = var.tools
  ami_id = var.ami_id
  instance_type = each.value["instance_type"]
  name = each.key
  port = each.value["port"]
  zone_id = var.zone_id
}
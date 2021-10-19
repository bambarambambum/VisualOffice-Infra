variable "vpc_cidr_private" {
    description = "CIDR for the Private subnet"
    default = "172.28.1.0/24"
}

variable "vpc_cidr_external" {
    description = "CIDR for the External subnet"
    default = "172.28.2.0/24"
}
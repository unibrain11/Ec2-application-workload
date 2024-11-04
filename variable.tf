variable "region" {
    default = "us-east-1"
  
}
variable "os_name" {
    default = "ami-06b21ccaeff8cd686"
  
}
variable "instance_type" {
    default = "t3.micro"
  
}
variable "key_name" {
    default = "uctesting"
  
}
variable "vpc-cidr" {
    default = "10.0.0.0/16"
  
}
variable "subnet-cidr" {
    default = "10.0.1.0/24"
  
}
variable "subnet-az" {
    default = "us-east-1"
  
}
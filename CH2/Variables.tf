# azure service principal info
variable "subscription_id" {
  default = "***************"
}

# client_id or app_id
variable "client_id" {
  default = "***************"
}

variable "client_secret" {
  default = "******************"
}

# tenant_id or directory_id
variable "tenant_id" {
  default = "************************"
}

# admin Username
variable "admin_username" {
  default = "PrasannaAdmin"
}

# admin password
variable "admin_password" {
  default = "Terra@prasanna123"
}

# service variables
variable "prefix" {
  default = "prasademo"
}

variable "PrasannaStorage" {
  default = "prasademostrg123456"
}
variable "location" {
  default = "eastus"
}

variable "vmsize" {
  default = "Standard_F2"
}



variable "webcount" {
  default = 1
}

variable "appcount" {
  default = 1
}




variable "systemtag" {
    type = string
    default = "Production"
    description = "Name of the system or environment"
}

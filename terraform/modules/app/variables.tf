variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image for reddit app"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable folder_id {
  description = "Folder for modules"
}
variable initial_count {
  description = "Initial number of app instances"
  default     = 1
}

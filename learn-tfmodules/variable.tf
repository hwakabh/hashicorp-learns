// validation with length
variable "user_id" {
  type        = string // length will not work with type=number
  description = "6-digit User ID"
  validation {
    condition     = length(var.user_id) == 6
    error_message = <<-EOF
      "Use ID should be exactly 6 digits."
    EOF
  }
}

// validation with fixed elements
locals {
  company = ["google", "apple", "facebook", "amazon"]
}
variable "user_company" {
  type        = string
  description = "Company of user"
  # sensitive = true
  validation {
    condition     = contains(local.company, var.user_company)
    error_message = "Company should be GAFA with lower case"
  }
}

// envar validation with string pattern
// can be referred with `TF_VAR_GREET` in shell
variable "GREET" {
  type        = string
  description = "Say Greeting message"

  validation {
    condition     = can(regex("^hel", var.GREET))
    error_message = "Lets say hello though"
  }
}

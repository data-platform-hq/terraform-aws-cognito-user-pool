variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Cognito user pool
################################################################################
variable "name" {
  description = "Name of the user pool"
  type        = string
}

variable "account_recovery_mechanisms" {
  description = "List of account recovery mechanisms"
  type = list(object({
    name     = string # Recovery method for a user. Can be of the following: verified_email, verified_phone_number, and admin_only
    priority = number # Positive integer specifying priority of a method with 1 being the highest priority
  }))
  default = []
}

variable "admin_create_user_config" {
  description = "Configuration block for creating a new user profile"
  type = object({
    allow_admin_create_user_only = optional(bool, true) # Set to True if only the administrator is allowed to create user profiles
    invite_message_template = optional(object({         # Invite message template structure
      email_message = optional(string, null)            # Message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively
      email_subject = optional(string, null)            # Subject line for email messages
      sms_message   = optional(string, null)            # Message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively
    }), null)
  })
  default = {}
}

variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Valid values: phone_number, email, or preferred_username"
  type        = list(string)
  default     = []
}

variable "auto_verified_attributes" {
  description = "Attributes to be auto-verified. Valid values: email, phone_number"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "When true, DeletionProtection prevents accidental deletion of your user pool"
  type        = bool
  default     = false
}

variable "device_configuration" {
  description = "Configuration block for the user pool's device tracking"
  type = object({
    challenge_required_on_new_device      = optional(bool) # Whether a challenge is required on a new device. Only applicable to a new device
    device_only_remembered_on_user_prompt = optional(bool) # Whether a device is only remembered on user prompt. false equates to "Always" remember, true is "User Opt In," and not using a device_configuration block is "No."
  })
  default = null
}

variable "email_configuration" {
  description = "Configuration block for configuring email"
  type = object({
    configuration_set      = optional(string) # Email configuration set name from SES
    email_sending_account  = optional(string) # Email delivery method to use. COGNITO_DEFAULT for the default email functionality built into Cognito or DEVELOPER to use your Amazon SES configuration
    from_email_address     = optional(string) # Sender’s email address or sender’s display name with their email address
    reply_to_email_address = optional(string) # REPLY-TO email address
    source_arn             = optional(string) # ARN of the SES verified email identity to use. Required if email_sending_account is set to DEVELOPER
  })
  default = null
}

variable "email_verification_message" {
  description = "String representing the email verification message. Conflicts with verification_message_template configuration block email_message argument"
  type        = string
  default     = null
}

variable "email_verification_subject" {
  description = "String representing the email verification subject. Conflicts with verification_message_template configuration block email_subject argument"
  type        = string
  default     = null
}

variable "lambda_config" {
  description = "Configuration block for the AWS Lambda triggers associated with the user pool"
  type = object({
    create_auth_challenge          = optional(string) # ARN of the lambda creating an authentication challenge
    custom_message                 = optional(string) # Custom Message AWS Lambda trigger
    define_auth_challenge          = optional(string) # Defines the authentication challenge
    post_authentication            = optional(string) # Post-authentication AWS Lambda trigger
    post_confirmation              = optional(string) # Post-confirmation AWS Lambda trigger
    pre_authentication             = optional(string) # Pre-authentication AWS Lambda trigger
    pre_sign_up                    = optional(string) # Pre-registration AWS Lambda trigger
    pre_token_generation           = optional(string) # Allow to customize identity token claims before token generation
    user_migration                 = optional(string) # User migration Lambda config type
    verify_auth_challenge_response = optional(string) # Verifies the authentication challenge response
    kms_key_id                     = optional(string) # The Amazon Resource Name of Key Management Service Customer master keys
    custom_email_sender = optional(object({
      lambda_arn     = string                   # The Lambda Amazon Resource Name of the Lambda function that Amazon Cognito triggers to send email notifications to users
      lambda_version = optional(string, "V1_0") # The Lambda version represents the signature of the "request" attribute in the "event" information Amazon Cognito passes to your custom email Lambda function
    }), null)
    custom_sms_sender = optional(object({
      lambda_arn     = string                   # The Lambda Amazon Resource Name of the Lambda function that Amazon Cognito triggers to send SMS notifications to users
      lambda_version = optional(string, "V1_0") # The Lambda version represents the signature of the "request" attribute in the "event" information Amazon Cognito passes to your custom SMS Lambda function
    }), null)
  })
  default = null
}

variable "mfa_configuration" {
  description = "Multi-Factor Authentication (MFA) configuration for the User Pool. Valid values are OFF, ON and OPTIONAL"
  type        = string
  default     = "OFF"
}

variable "password_policy" {
  description = "Configuration blocked for information about the user pool password policy"
  type = object({
    minimum_length                   = optional(number)
    require_lowercase                = optional(bool)
    require_numbers                  = optional(bool)
    require_symbols                  = optional(bool)
    require_uppercase                = optional(bool)
    temporary_password_validity_days = optional(number)
  })
  default = null
}

variable "schemas" {
  description = "List of schema attributes of a user pool"
  type = list(object({
    attribute_data_type      = string                # Attribute data type. Must be one of Boolean, Number, String, DateTime
    developer_only_attribute = optional(bool)        # Whether the attribute type is developer only
    mutable                  = optional(bool)        # Whether the attribute can be changed once it has been created
    name                     = string                # Name of the attribute
    required                 = optional(bool)        # Whether a user pool attribute is required
    number_attribute_constraints = optional(object({ # (Required when attribute_data_type is Number) Configuration block for the constraints for an attribute of the number type
      min_value = number                             # Minimum value of an attribute that is of the number data type
      max_value = number                             # Maximum value of an attribute that is of the number data type
    }), null)
    string_attribute_constraints = optional(object({ # (Required when attribute_data_type is String) Constraints for an attribute of the string type
      min_length = number                            # Minimum length of an attribute value of the string type
      max_length = number                            # Maximum length of an attribute value of the string type
    }), null)
  }))
  default = []
}

variable "sms_authentication_message" {
  description = "String representing the SMS authentication message. The Message must contain the {####} placeholder, which will be replaced with the code"
  type        = string
  default     = null
}

variable "sms_configuration" {
  description = "Configuration block for Short Message Service (SMS) settings"
  type = object({
    external_id    = string           # External ID used in IAM role trust relationships
    sns_caller_arn = string           # ARN of the Amazon SNS caller
    sns_region     = optional(string) # The AWS Region to use with Amazon SNS integration
  })
  default = null
}

variable "sms_verification_message" {
  description = "String representing the SMS verification message. Conflicts with verification_message_template configuration block sms_message argument"
  type        = string
  default     = null
}

variable "software_token_mfa_enabled" {
  description = "Boolean whether to enable software token Multi-Factor (MFA) tokens, such as Time-based One-Time Password (TOTP)"
  type        = bool
  default     = false
}

variable "attributes_require_verification_before_update" {
  description = "A list of attributes requiring verification before update. If set, the provided value(s) must also be set in auto_verified_attributes"
  type        = list(string)
  default     = []
}

variable "advanced_security_mode" {
  description = "Mode for advanced security, must be one of OFF, AUDIT or ENFORCED"
  type        = string
  default     = null
}

variable "username_attributes" {
  description = "Whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with alias_attributes"
  type        = list(string)
  default     = null
}

variable "username_case_sensitive" {
  description = "Whether username case sensitivity will be applied for all users in the user pool through Cognito APIs"
  type        = bool
  default     = false
}

variable "verification_message_template" {
  description = "Configuration block for verification message templates"
  type = object({
    default_email_option  = optional(string) # Default email option. Must be either CONFIRM_WITH_CODE or CONFIRM_WITH_LINK
    email_message         = optional(string) # Email message template. Must contain the {####} placeholder. Conflicts with email_verification_message argument
    email_message_by_link = optional(string) # Email message template for sending a confirmation link to the user, it must contain the {##Click Here##} placeholder
    email_subject         = optional(string) # Subject line for the email message template. Conflicts with email_verification_subject argument
    email_subject_by_link = optional(string) # Subject line for the email message template for sending a confirmation link to the user
    sms_message           = optional(string) # SMS message template. Must contain the {####} placeholder. Conflicts with sms_verification_message argument
  })
  default = null
}

################################################################################
# Cognito User Identity Provider resource
################################################################################

variable "identity_providers" {
  description = "List of identity providers configuration"
  type = list(object({
    provider_name     = string                 # The provider name
    provider_type     = string                 # The provider type
    attribute_mapping = optional(map(string))  # The list of maps of attribute mapping of user pool attributes
    idp_identifiers   = optional(list(string)) # The list of identity providers
    provider_details  = optional(map(string))  # The map of identity details, such as access token
  }))
  default = []
}

################################################################################
# Cognito User Pool Domain
################################################################################

variable "user_pool_domain" {
  description = "Configuration of Cognito User Pool Domain"
  type = object({
    domain          = string           # For custom domains, this is the fully-qualified domain name, such as auth.example.com. For Amazon Cognito prefix domains, this is the prefix alone, such as auth
    certificate_arn = optional(string) # he ARN of an ISSUED ACM certificate in us-east-1 for a custom domain
  })
  default = null
}

################################################################################
# Cognito User Pool Client
################################################################################
variable "user_pool_clients" {
  description = "List of Cognito User Pool Clients configuration"
  type = list(object({
    name                                 = string                 # Name of the application client
    access_token_validity                = optional(number)       # Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used
    allowed_oauth_flows_user_pool_client = optional(bool)         # Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools
    allowed_oauth_flows                  = optional(list(string)) # List of allowed OAuth flows (code, implicit, client_credentials)
    allowed_oauth_scopes                 = optional(list(string)) # List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)
    analytics_configuration = optional(object({
      application_arn  = optional(string) # Application ARN for an Amazon Pinpoint application. Conflicts with external_id and role_arn
      application_id   = optional(string) # Application ID for an Amazon Pinpoint application
      external_id      = optional(string) # ID for the Analytics Configuration. Conflicts with application_arn
      role_arn         = optional(string) # ARN of an IAM role that authorizes Amazon Cognito to publish events to Amazon Pinpoint analytics. Conflicts with application_arn
      user_data_shared = optional(bool)   # If set to true, Amazon Cognito will include user data in the events it publishes to Amazon Pinpoint analytics
    }), null)
    auth_session_validity                         = optional(number)       # Amazon Cognito creates a session token for each API request in an authentication flow. AuthSessionValidity is the duration, in minutes, of that session token
    callback_urls                                 = optional(list(string)) # List of allowed callback URLs for the identity providers
    default_redirect_uri                          = optional(string)       # Default redirect URI. Must be in the list of callback URLs
    enable_token_revocation                       = optional(bool)         # Enables or disables token revocation
    enable_propagate_additional_user_context_data = optional(bool)         # Activates the propagation of additional user context data
    explicit_auth_flows                           = optional(list(string)) # List of authentication flows
    generate_secret                               = optional(bool)         # Should an application secret be generated
    id_token_validity                             = optional(number)       # Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used
    logout_urls                                   = optional(list(string)) # List of allowed logout URLs for the identity providers
    prevent_user_existence_errors                 = optional(bool)         # Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool
    read_attributes                               = optional(list(string)) # List of user pool attributes the application client can read from
    refresh_token_validity                        = optional(number)       # Time limit, between 60 minutes and 10 years, after which the refresh token is no longer valid and cannot be used
    supported_identity_providers                  = optional(list(string)) # List of provider names for the identity providers that are supported on this client
    token_validity_units = optional(object({
      access_token  = optional(string) # Time unit in for the value in access_token_validity, defaults to hours
      id_token      = optional(string) # Time unit in for the value in id_token_validity, defaults to hours
      refresh_token = optional(string) # Time unit in for the value in refresh_token_validity, defaults to days
    }), null)
    write_attributes = optional(list(string)) # List of user pool attributes the application client can write to
  }))
  default = []
}


################################################################################
# Cognito Managed User Pool Client
################################################################################

variable "managed_user_pool_clients" {
  description = "List of Cognito Managed User Pool Clients configuration"
  type = list(object({
    name                                 = string                 # Unique name of Cognito Managed User Pool Client. Used internally
    name_pattern                         = optional(string)       # (Required, one of name_pattern or name_prefix) Regular expression that matches the name of the desired User Pool Client. Must match only one User Pool Client
    name_prefix                          = optional(string)       # (Required, one of name_prefix or name_pattern) String that matches the beginning of the name of the desired User Pool Client. Must match only one User Pool Client
    access_token_validity                = optional(number)       # Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used
    allowed_oauth_flows_user_pool_client = optional(bool)         # Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools
    allowed_oauth_flows                  = optional(list(string)) # List of allowed OAuth flows (code, implicit, client_credentials)
    allowed_oauth_scopes                 = optional(list(string)) # List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)
    analytics_configuration = optional(object({
      application_arn  = optional(string) # Application ARN for an Amazon Pinpoint application. Conflicts with external_id and role_arn
      application_id   = optional(string) # Application ID for an Amazon Pinpoint application
      external_id      = optional(string) # ID for the Analytics Configuration. Conflicts with application_arn
      role_arn         = optional(string) # ARN of an IAM role that authorizes Amazon Cognito to publish events to Amazon Pinpoint analytics. Conflicts with application_arn
      user_data_shared = optional(bool)   # If set to true, Amazon Cognito will include user data in the events it publishes to Amazon Pinpoint analytics
    }), null)
    auth_session_validity                         = optional(number)       # Amazon Cognito creates a session token for each API request in an authentication flow. AuthSessionValidity is the duration, in minutes, of that session token
    callback_urls                                 = optional(list(string)) # List of allowed callback URLs for the identity providers
    default_redirect_uri                          = optional(string)       # Default redirect URI. Must be in the list of callback URLs
    enable_token_revocation                       = optional(bool)         # Enables or disables token revocation
    enable_propagate_additional_user_context_data = optional(bool)         # Activates the propagation of additional user context data
    explicit_auth_flows                           = optional(list(string)) # List of authentication flows
    id_token_validity                             = optional(number)       # Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used
    logout_urls                                   = optional(list(string)) # List of allowed logout URLs for the identity providers
    prevent_user_existence_errors                 = optional(bool)         # Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool
    read_attributes                               = optional(list(string)) # List of user pool attributes the application client can read from
    refresh_token_validity                        = optional(number)       # Time limit, between 60 minutes and 10 years, after which the refresh token is no longer valid and cannot be used
    supported_identity_providers                  = optional(list(string)) # List of provider names for the identity providers that are supported on this client
    token_validity_units = optional(object({
      access_token  = optional(string) # Time unit in for the value in access_token_validity, defaults to hours
      id_token      = optional(string) # Time unit in for the value in id_token_validity, defaults to hours
      refresh_token = optional(string) # Time unit in for the value in refresh_token_validity, defaults to days
    }), null)
    write_attributes = optional(list(string)) # List of user pool attributes the application client can write to
  }))
  default = []
}

################################################################################
# Cognito User Group
################################################################################

variable "user_groups" {
  description = "List of Cognito User Groups"
  type = list(object({
    name        = string           # The name of the user group
    description = optional(string) # The description of the user group
    precedence  = optional(number) # The precedence of the user group
    role_arn    = optional(string) # The ARN of the IAM role to be associated with the user group
  }))
  default = []
}

################################################################################
# Cognito user pool
################################################################################

resource "aws_cognito_user_pool" "this" {
  count                      = var.create ? 1 : 0
  name                       = var.name
  tags                       = var.tags
  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  deletion_protection        = var.deletion_protection ? "ACTIVE" : "INACTIVE"
  email_verification_message = var.email_verification_message
  email_verification_subject = var.email_verification_subject
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message
  sms_verification_message   = var.sms_verification_message
  username_attributes        = var.username_attributes


  dynamic "account_recovery_setting" {
    for_each = length(var.account_recovery_mechanisms) != 0 ? [1] : []
    content {
      dynamic "recovery_mechanism" {
        for_each = var.account_recovery_mechanisms
        content {
          name     = recovery_mechanism.value.name
          priority = recovery_mechanism.value.priority
        }
      }
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = var.admin_create_user_config.allow_admin_create_user_only
    dynamic "invite_message_template" {
      for_each = var.admin_create_user_config.invite_message_template != null ? [1] : []
      content {
        email_message = var.admin_create_user_config.invite_message_template.email_message
        email_subject = var.admin_create_user_config.invite_message_template.email_subject
        sms_message   = var.admin_create_user_config.invite_message_template.sms_message
      }
    }
  }

  dynamic "device_configuration" {
    for_each = var.device_configuration != null ? [1] : []
    content {
      challenge_required_on_new_device      = var.device_configuration.challenge_required_on_new_device
      device_only_remembered_on_user_prompt = var.device_configuration.device_only_remembered_on_user_prompt
    }
  }

  dynamic "email_configuration" {
    for_each = var.email_configuration != null ? [1] : []
    content {
      configuration_set      = var.email_configuration.configuration_set
      email_sending_account  = var.email_configuration.email_sending_account
      from_email_address     = var.email_configuration.from_email_address
      reply_to_email_address = var.email_configuration.reply_to_email_address
      source_arn             = var.email_configuration.email_sending_account == "DEVELOPER" ? var.email_configuration.source_arn : null
    }
  }

  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [1] : []
    content {
      create_auth_challenge          = var.lambda_config.create_auth_challenge
      custom_message                 = var.lambda_config.custom_message
      define_auth_challenge          = var.lambda_config.define_auth_challenge
      post_authentication            = var.lambda_config.post_authentication
      post_confirmation              = var.lambda_config.post_confirmation
      pre_authentication             = var.lambda_config.pre_authentication
      pre_sign_up                    = var.lambda_config.pre_sign_up
      pre_token_generation           = var.lambda_config.pre_token_generation
      user_migration                 = var.lambda_config.user_migration
      verify_auth_challenge_response = var.lambda_config.verify_auth_challenge_response
      kms_key_id                     = var.lambda_config.kms_key_id
      dynamic "custom_email_sender" {
        for_each = var.lambda_config.custom_email_sender != null ? [1] : []
        content {
          lambda_arn     = var.lambda_config.custom_email_sender.lambda_arn
          lambda_version = var.lambda_config.custom_email_sender.lambda_version
        }
      }
      dynamic "custom_sms_sender" {
        for_each = var.lambda_config.custom_sms_sender != null ? [1] : []
        content {
          lambda_arn     = var.lambda_config.custom_sms_sender.lambda_arn
          lambda_version = var.lambda_config.custom_sms_sender.lambda_version
        }
      }
    }
  }

  dynamic "password_policy" {
    for_each = var.password_policy != null ? [1] : []
    content {
      minimum_length                   = var.password_policy.minimum_length
      require_lowercase                = var.password_policy.require_lowercase
      require_numbers                  = var.password_policy.require_numbers
      require_symbols                  = var.password_policy.require_symbols
      require_uppercase                = var.password_policy.require_uppercase
      temporary_password_validity_days = var.password_policy.temporary_password_validity_days
    }
  }

  dynamic "schema" {
    for_each = var.schemas
    content {
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = schema.value.developer_only_attribute
      mutable                  = schema.value.mutable
      name                     = schema.value.name
      required                 = schema.value.required

      dynamic "number_attribute_constraints" {
        for_each = schema.value.number_attribute_constraints != null && schema.value.attribute_data_type == "Number" ? [1] : []
        content {
          min_value = schema.value.number_attribute_constraints.min_value
          max_value = schema.value.number_attribute_constraints.max_value
        }
      }

      dynamic "string_attribute_constraints" {
        for_each = schema.value.string_attribute_constraints != null && schema.value.attribute_data_type == "String" ? [1] : []
        content {
          min_length = schema.value.string_attribute_constraints.min_length
          max_length = schema.value.string_attribute_constraints.max_length
        }
      }
    }
  }

  dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [1] : []
    content {
      external_id    = var.sms_configuration.external_id
      sns_caller_arn = var.sms_configuration.sns_caller_arn
      sns_region     = var.sms_configuration.sns_region
    }
  }

  dynamic "software_token_mfa_configuration" {
    for_each = var.software_token_mfa_enabled ? [1] : []
    content {
      enabled = true
    }
  }

  dynamic "user_attribute_update_settings" {
    for_each = length(var.attributes_require_verification_before_update) != 0 ? [1] : []
    content {
      attributes_require_verification_before_update = var.attributes_require_verification_before_update
    }
  }

  dynamic "user_pool_add_ons" {
    for_each = var.advanced_security_mode != null ? [1] : []
    content {
      advanced_security_mode = var.advanced_security_mode
    }
  }

  dynamic "username_configuration" {
    for_each = var.username_case_sensitive ? [1] : []
    content {
      case_sensitive = true
    }
  }

  dynamic "verification_message_template" {
    for_each = var.verification_message_template != null ? [1] : []
    content {
      default_email_option  = var.verification_message_template.default_email_option
      email_message         = var.verification_message_template.email_message
      email_message_by_link = var.verification_message_template.email_message_by_link
      email_subject         = var.verification_message_template.email_subject
      email_subject_by_link = var.verification_message_template.email_subject_by_link
      sms_message           = var.verification_message_template.sms_message
    }
  }
}

################################################################################
# Cognito User Identity Provider resource
################################################################################

resource "aws_cognito_identity_provider" "this" {
  for_each = {
    for k, v in var.identity_providers :
    v.provider_name => v if var.create
  }
  user_pool_id      = aws_cognito_user_pool.this[0].id
  provider_name     = each.value.provider_name
  provider_type     = each.value.provider_type
  provider_details  = each.value.provider_details
  idp_identifiers   = each.value.idp_identifiers
  attribute_mapping = each.value.attribute_mapping
}

################################################################################
# Cognito User Pool Domain
################################################################################

resource "aws_cognito_user_pool_domain" "this" {
  count           = var.create && var.user_pool_domain != null ? 1 : 0
  domain          = var.user_pool_domain.domain
  user_pool_id    = aws_cognito_user_pool.this[0].id
  certificate_arn = var.user_pool_domain.certificate_arn
}

################################################################################
# Cognito User Pool Client
################################################################################

resource "aws_cognito_user_pool_client" "this" {
  for_each = {
    for k, v in var.user_pool_clients :
    v.name => v if var.create
  }
  name                                          = each.value.name
  user_pool_id                                  = aws_cognito_user_pool.this[0].id
  access_token_validity                         = each.value.access_token_validity
  allowed_oauth_flows_user_pool_client          = each.value.allowed_oauth_flows_user_pool_client
  allowed_oauth_flows                           = each.value.allowed_oauth_flows
  allowed_oauth_scopes                          = each.value.allowed_oauth_scopes
  auth_session_validity                         = each.value.auth_session_validity
  callback_urls                                 = each.value.callback_urls
  default_redirect_uri                          = each.value.default_redirect_uri
  enable_token_revocation                       = each.value.enable_token_revocation
  enable_propagate_additional_user_context_data = each.value.enable_propagate_additional_user_context_data
  explicit_auth_flows                           = each.value.explicit_auth_flows
  generate_secret                               = each.value.generate_secret
  id_token_validity                             = each.value.id_token_validity
  logout_urls                                   = each.value.logout_urls
  prevent_user_existence_errors                 = each.value.prevent_user_existence_errors ? "ENABLED" : "LEGACY"
  read_attributes                               = each.value.read_attributes
  refresh_token_validity                        = each.value.refresh_token_validity
  supported_identity_providers                  = each.value.supported_identity_providers
  write_attributes                              = each.value.write_attributes

  dynamic "analytics_configuration" {
    for_each = each.value.analytics_configuration != null ? [1] : []
    content {
      application_arn  = each.value.analytics_configuration.application_arn
      application_id   = each.value.analytics_configuration.application_id
      external_id      = each.value.analytics_configuration.external_id
      role_arn         = each.value.analytics_configuration.role_arn
      user_data_shared = each.value.analytics_configuration.user_data_shared
    }
  }

  dynamic "token_validity_units" {
    for_each = each.value.token_validity_units != null ? [1] : []
    content {
      access_token  = each.value.token_validity_units.access_token
      id_token      = each.value.token_validity_units.id_token
      refresh_token = each.value.token_validity_units.refresh_token
    }
  }
}

################################################################################
# Cognito Managed User Pool Client
################################################################################

resource "aws_cognito_managed_user_pool_client" "this" {
  for_each = {
    for k, v in var.managed_user_pool_clients :
    v.name => v if var.create
  }
  name_prefix                                   = each.value.name_prefix
  name_pattern                                  = each.value.name_pattern
  user_pool_id                                  = aws_cognito_user_pool.this[0].id
  access_token_validity                         = each.value.access_token_validity
  allowed_oauth_flows_user_pool_client          = each.value.allowed_oauth_flows_user_pool_client
  allowed_oauth_flows                           = each.value.allowed_oauth_flows
  allowed_oauth_scopes                          = each.value.allowed_oauth_scopes
  auth_session_validity                         = each.value.auth_session_validity
  callback_urls                                 = each.value.callback_urls
  default_redirect_uri                          = each.value.default_redirect_uri
  enable_token_revocation                       = each.value.enable_token_revocation
  enable_propagate_additional_user_context_data = each.value.enable_propagate_additional_user_context_data
  explicit_auth_flows                           = each.value.explicit_auth_flows
  id_token_validity                             = each.value.id_token_validity
  logout_urls                                   = each.value.logout_urls
  prevent_user_existence_errors                 = each.value.prevent_user_existence_errors ? "ENABLED" : "LEGACY"
  read_attributes                               = each.value.read_attributes
  refresh_token_validity                        = each.value.refresh_token_validity
  supported_identity_providers                  = each.value.supported_identity_providers
  write_attributes                              = each.value.write_attributes

  dynamic "analytics_configuration" {
    for_each = each.value.analytics_configuration != null ? [1] : []
    content {
      application_arn  = each.value.analytics_configuration.application_arn
      application_id   = each.value.analytics_configuration.application_id
      external_id      = each.value.analytics_configuration.external_id
      role_arn         = each.value.analytics_configuration.role_arn
      user_data_shared = each.value.analytics_configuration.user_data_shared
    }
  }

  dynamic "token_validity_units" {
    for_each = each.value.token_validity_units != null ? [1] : []
    content {
      access_token  = each.value.token_validity_units.access_token
      id_token      = each.value.token_validity_units.id_token
      refresh_token = each.value.token_validity_units.refresh_token
    }
  }
}

################################################################################
# Cognito User Group
################################################################################

resource "aws_cognito_user_group" "this" {
  for_each = {
    for k, v in var.user_groups :
    v.name => v if var.create
  }
  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.this[0].id
  description  = each.value.description
  precedence   = each.value.precedence
  role_arn     = each.value.role_arn
}

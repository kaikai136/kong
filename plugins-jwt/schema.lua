local typedefs = require "kong.db.schema.typedefs"

return {
    name = "jwt-custom",
    fields = {
        { protocols = typedefs.protocols_http },
        { config = {
            type = "record",
            fields = {
                { uri_param_name = {
                    type = "string",
                    default = "token",
                }, },
                { key_claim_name = { type = "string", default = "iss" }, },
                { secret_is_base64 = { type = "boolean", default = false }, },
                { add_header_uid = { type = "boolean", default = true }, },
                { add_header_uname = { type = "boolean", default = true }, },
                { clear_header_jwt = { type = "boolean", default = false }, },
                { anonymous = { type = "string" }, },
                { run_on_preflight_OPTIONS_request = { type = "boolean", default = true }, },
                { maximum_expiration = {
                    type = "number",
                    default = 0,
                    between = { 0, 31536000 },
                }, },
                { header_name = {
                    type = "string",
                    default = "Authorization",
                }, },
            },
        },
        },
    },
    entity_checks = {
        { conditional = {
            if_field = "config.maximum_expiration",
            if_match = { gt = 0 },
            then_field = "config.claims_to_verify",
            then_match = { contains = "exp" },
        }, },
    },
}

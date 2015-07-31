defmodule Excoap.Code do
  def decode(<<class :: size(3), detail :: size(5)>>) do
    case {class, detail} do
      {0, 00} -> :empty
      {0, 01} -> :get
      {0, 02} -> :post
      {0, 03} -> :put
      {0, 04} -> :delete
      {2, 01} -> :created
      {2, 02} -> :deleted
      {2, 03} -> :valid
      {2, 04} -> :changed
      {2, 05} -> :content
      {4, 00} -> :bad_request
      {4, 01} -> :unauthorized
      {4, 02} -> :bad_option
      {4, 03} -> :forbidden
      {4, 04} -> :not_found
      {4, 05} -> :method_not_allowed
      {4, 06} -> :not_acceptable
      {4, 12} -> :precondition_failed
      {4, 13} -> :request_entity_too_large
      {4, 15} -> :unsupported_content_format
      {5, 00} -> :internal_server_error
      {5, 01} -> :not_implemented
      {5, 02} -> :bad_gateway
      {5, 03} -> :service_unavailable
      {5, 04} -> :gateway_timeout
      {5, 05} -> :proxying_not_supported
    end
  end

  def encode(code) do
    {class, detail} = case code do
                        :empty                      -> {0, 00}
                        :get                        -> {0, 01}
                        :post                       -> {0, 02}
                        :put                        -> {0, 03}
                        :delete                     -> {0, 04}
                        :created                    -> {2, 01}
                        :deleted                    -> {2, 02}
                        :valid                      -> {2, 03}
                        :changed                    -> {2, 04}
                        :content                    -> {2, 05}
                        :bad_request                -> {4, 00}
                        :unauthorized               -> {4, 01}
                        :bad_option                 -> {4, 02}
                        :forbidden                  -> {4, 03}
                        :not_found                  -> {4, 04}
                        :method_not_allowed         -> {4, 05}
                        :not_acceptable             -> {4, 06}
                        :precondition_failed        -> {4, 12}
                        :request_entity_too_large   -> {4, 13}
                        :unsupported_content_format -> {4, 15}
                        :internal_server_error      -> {5, 00}
                        :not_implemented            -> {5, 01}
                        :bad_gateway                -> {5, 02}
                        :service_unavailable        -> {5, 03}
                        :gateway_timeout            -> {5, 04}
                        :proxying_not_supported     -> {5, 05}
                      end
    <<class :: size(3), detail :: size(5)>>
  end
end

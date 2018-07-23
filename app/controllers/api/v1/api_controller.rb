class Api::V1::Controller < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken
end
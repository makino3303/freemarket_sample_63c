require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

def use_s3?
  Rails.application.secrets.aws_access_key_id && Rails.application.secrets.aws_secret_access_key && 'ap-northeast-1' && 'freemarket63c'
end

CarrierWave.configure do |config|
  if use_s3?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'freemarket63c'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/freemarket63c'
  end
end
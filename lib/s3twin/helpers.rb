module S3twin::Helpers
  class << self

    def prompt_payload(payload)
      payload['source_bucket'] ||= ask('Source Bucket:')
      payload['source_access_key'] ||= ask('Source Access Key:')
      payload['source_secret_key'] ||= ask('Source Secret Key:')
      payload['destination_bucket'] ||= ask('Destination Bucket:')
      payload['destination_access_key'] ||= ask('Destination Access Key:')
      payload['destination_secret_key'] ||= ask('Destination Secret Key:')
      return payload
    end

    def generate_env(payload)
      env = "IRON_TOKEN='#{payload['iron_token']}'
IRON_PROJECT_ID='#{payload['iron_project_id']}'

SOURCE_S3_BUCKET='#{payload['source_bucket']}'
SOURCE_AWS_ACCESS_KEY_ID='#{payload['source_aws_access_key_id']}'
SOURCE_AWS_SECRET_ACCESS_KEY='#{payload['source_aws_secret_access_key']}'

DESTINATION_S3_BUCKET='#{payload['destination_s3_bucket']}'
DESTINATION_AWS_ACCESS_KEY_ID='#{payload['destination_aws_access_key_id']}'
DESTINATION_AWS_SECRET_ACCESS_KEY='#{payload['destination_aws_secret_access_key']}'"
      return env
    end

  end
end


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

  end
end


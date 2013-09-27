require 'aws-sdk'

class Twin
  # these exist for ironworker compatibility. It should probaby be seperated out to a wrapper.
  attr_accessor :source_s3_bucket, :source_aws_access_key_id, :source_aws_secret_access_key, :destination_s3_bucket, :destination_aws_access_key_id, :destination_aws_secret_access_key
  def run
    params = {
      'source_s3_bucket' => source_s3_bucket,
      'source_aws_access_key_id' => source_aws_access_key_id,
      'source_aws_secret_access_key' => source_aws_secret_access_key,
      'destination_s3_bucket' => destination_s3_bucket,
      'destination_aws_access_key_id' => destination_aws_access_key_id,
      'destination_aws_secret_access_key' => destination_aws_secret_access_key
    }
    Twin.go(params)
  end

  # Real stuff starts here
  class << self
    def go(params)
      puts 'Starting S3Twin run'
      @source = AWS::S3.new(
        :access_key_id => params['source_aws_access_key_id'],
        :secret_access_key => params['source_aws_secret_access_key'])
      @source_bucket = @source.buckets[params['source_s3_bucket']]

      @destination = AWS::S3.new(
        :access_key_id => params['destination_aws_access_key_id'],
        :secret_access_key => params['destination_aws_secret_access_key'])
      @destination_bucket = @destination.buckets[params['destination_s3_bucket']]

      @source_bucket.objects.each do |obj|
        dest_key = @destination_bucket.objects[obj.key] 
        begin
          unless dest_key.exists?
            puts "Creating: #{obj.key}"
            obj.copy_to(dest_key, :acl => public_acl(obj))
          else
            unless etag_match(obj.key,obj.etag)
              puts "Updating: #{obj.key}"
              obj.copy_to(dest_key, :acl => public_acl(obj))
            else
              puts "Skipping: #{obj.key}"
            end
          end
        rescue AWS::S3::Errors::AccessDenied
          puts "Access Denied: #{obj.key}"
        end
      end
      puts 'Completed S3Twin run'
    end

    private
    def public_acl(object)
      object.acl.grants.each do |grant|
        if grant.grantee.uri == 'http://acs.amazonaws.com/groups/global/AllUsers'
          case grant.permission.name.to_s
          when 'read'
            return 'public_read'
          when 'read_write'
            return 'public_read_write'
          else 
            return 'private'
          end
        else
          return nil
        end
      end
    end

    def etag_match(key,etag)
     etag == @destination_bucket.objects[key].etag
    end
  end
end

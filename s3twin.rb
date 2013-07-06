require 'aws-sdk'

source_bucket = params[:source_bucket] || raise('Please set source bucket')
source_access_key = params[:source_access_key] || raise('Please set source AWS Access Key')
source_secret_key = params[:source_secret_key] || raise('Please set source AWS Secret Key')

destination_bucket = params[:destination_bucket] || raise('Please set destination bucket')
destination_access_key = params[:destination_access_key] || raise('Please set destination AWS Access Key')
destination_secret_key = params[:destination_secret_key] || raise('Please set destination AWS Secret Key')

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
    end
  end
end

def etag_match(key,etag)
 etag == @destination_bucket.objects[key].etag
end

puts 'Starting S3Twin run'
@source = AWS::S3.new(
  :access_key_id => source_access_key,
  :secret_access_key => source_secret_key)
@source_bucket = @source.buckets[source_bucket]

@destination = AWS::S3.new(
  :access_key_id => destination_access_key,
  :secret_access_key => destination_secret_key)
@destination_bucket = @destination.buckets[destination_bucket]

@source_bucket.objects.each do |obj|
  dest_key = @destination_bucket.objects[obj.key] 
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
end
puts 'Completed S3Twin run'

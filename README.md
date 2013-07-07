# S3 Twin

Take a mirror of a S3 bucket. It leverages [aws-sdk's](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html#copy_to-instance_method) `copy_to` function to do the heavy lifting at Amazon, similar to [s3cmd](http://s3tools.org/s3cmd-sync).  
Supports local usage or remote workers some of which may support scheduling - to keep a bucket's twin up to date.

One way copy only i.e. will not keep two buckets in sync.  
Carries across Public ACLs only; there is no support for S3 features like server side encryption.

If an object exists in the source bucket and does not exist in the destiantion bucket then the object is copied.  
If an object exists in both buckets and the [etags](http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html) are identical the object is not copied, if the etags do not match the object is copied.  
Does not remove objects from the destination bucket that have been deleted from the source bucket.  

Please note; while this works it's the first release so the API may change drastically.  


## Installation

```shell
$ gem install s3twin
```


## Usage

```shell
$ s3twin help
$ s3twin go # run twin now locally
```


#### Configuration

`$ s3twin init # initialise a .env file`

The configuration payload can be set via an argument `--payload=key:value key2:value2` or `.env` file.  
If neither of those are present the user will be prompted for input.

_Example with payload:_
```bash
$ s3twin go --payload=source_bucket:bar source_access_key:foo source_secret_key:world destination_bucket:bar destination_access_key:foo destination_secret_key:world
```


### Remote Workers

Currently only [iron.io](https://iron.io/) IronWorker tasks (including scheduled) are supported.

#### IronWorker Usage

Create a new project at [https://hud.iron.io](https://hud.iron.io/), collect your Iron Token and Project ID.

`$ s3twin ironworker help`  
`$ s3twin ironworker upload # upload worker code`  
`$ s3twin ironworker go # run worker once now`  
`$ s3twin ironworker schedule --time # schedule worker for the future`  

Optionally create, or append, your `.env` file:

```bash
IRON_TOKEN='foo'
IRON_PROJECT_ID='bar'
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

require 'iron_worker_ng'

module S3twin
  class Ironworker < Thor
    class_option :name, :type => :string, :default => 'S3Twin'
    class_option :credentials, :type => :hash, :default => {
      'token' => ENV['IRON_TOKEN'],
      'project_id' => ENV['IRON_PROJECT_ID']
    }

    desc 'upload NAME', 'Upload our worker'
    def upload
      client = IronWorkerNG::Client.new(prompt_credentials(options['credentials']))
      code = IronWorkerNG::Code::Base.new
      code.runtime = 'ruby'
      code.name = options['name']
      code.full_remote_build = true
      code.merge_exec('lib/s3twin/twin.rb','Twin')
      code.merge_gem 'aws-sdk'
      client.codes.create(code)
    end

    desc 'go WORKER', 'Queue a worker'
    def go
      payload = S3twin::Helpers.prompt_payload(options['payload'])
      client = IronWorkerNG::Client.new(prompt_credentials(options['credentials']))
      client.tasks.create(options['name'],payload)
      puts "#{options['name']} queued! Details at https://hud.iron.io/"
    end

    method_option :time, :type => :hash, :default => {}
    desc 'schedule WORKER', 'Schedule a worker'
    def schedule(name='S3Twin')
      payload = S3twin::Helpers.prompt_payload(options['payload'])
      time = prompt_time(options['time'])
      client = IronWorkerNG::Client.new(prompt_credentials(options['credentials']))
      schedule = client.schedules.create(options['name'],payload,time)
      puts "#{options['name']} scheduled! (id:#{schedule.id})"
    end

    private
    def prompt_time(time)
      time['run_every'] ||= ask('The amount of time, in seconds, between runs. By default, the task will only run once. Must be greater than 60:').to_i
      #time['end_at'] ||= ask('The time tasks will stop being queued. Should be a time or datetime:')
      #time['run_times'] ||= ask('Number of times the task will run:')
      #time['priority'] ||= ask('The priority queue to run the job in. Higher values means tasks spend less time in the queue once they come off the schedule:', :limited_to => ['0','1','2'])
      return time
    end
    
    def prompt_credentials(credentials)
      credentials['token'] ||= ask('Iron.io Token:')
      credentials['project_id'] ||= ask('Iron.io project ID:')
      return credentials
    end
  end
  
  class S3twinCLI < Thor
    desc 'ironworker SUBCOMMAND ...ARGS', 'IronWorker tasks'
    subcommand 'ironworker', Ironworker
  end
end
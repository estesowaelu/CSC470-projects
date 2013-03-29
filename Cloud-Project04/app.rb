require "rubygems"
gem "aws-sdk"
require "aws-sdk"
require "optparse"
require "pp"
require "json"

class SNSClient
	def self.parse(args)
		sns = AWS::SNS.new
		# cw = AWS::CloudWatch.new
		op=OptionParser.new do | opts |
			opts.on("-m", "writes hello") do
				puts "Hey, user."
			end
			opts.on("-d", "executes functions for project 4") do
				puts "======================================="
				puts "==========CSC470 Project 04============"
				puts "======================================="

				sns1 = 'CSC470Test-Alpha'
				sns2 = 'CSC470Test-Beta'

				alpha = create_topic(sns, sns1)
				set_name(sns, alpha, sns1)
				beta = create_topic(sns, sns2)
				set_name(sns, beta, sns2)
				print_topics(sns)

				delete_topic(sns, sns2, beta)
				print_topics(sns)

				email1 = 'address01@example.com'
				email2 = 'address02@example.com'
				sms1 = '###########'
				http1 = 'http://endpoint.example.com'

				# subscription
				e1sub = subscribe_topic(sns, alpha, 'email', email1)
				e2sub = subscribe_topic(sns, alpha, 'email-json', email2)
				e3sub = subscribe_topic(sns, alpha, 'sms', sms1)
				e4sub = subscribe_topic(sns, alpha, 'http', http1)

				puts "You have one minute to confirm your subscriptions..."
				puts "... starting...... NOW!"
				sleep(60)

				# subscription confirmation
				# e1con = confirm_subscription(sns, alpha, email1)
				# e2con = confirm_subscription(sns, alpha, email2)
				# e3con = confirm_subscription(sns, alpha, sms1)
				# e4con = confirm_subscription(sns, alpha, http1)

				print_topics(sns)

				print_subscriptions(sns)

				message = "This is a test of Tim Honeywell's Project 4 for CSC470, Spring 2013."
				publish_message(sns, alpha, message)

				# cw.metrics.
				# cw.alarms.create("SNS-high", )
			end
		end
		op.parse!(args)
	end
	
	def self.create_topic(sns, name)
		puts '===>> creating list: ' + name
		t = sns.client.create_topic(:name => name)
		t.topic_arn
	end

	def self.set_name(sns, topic_arn, name)
		sns.client.set_topic_attributes(:topic_arn => topic_arn, :attribute_name => 'DisplayName', :attribute_value => name)
	end

	def self.print_topics(sns)
		puts '===>> printing topics'
		tlist = sns.client.list_topics.data
		tlist[:topics].each { |val|
			t = sns.client.get_topic_attributes(:topic_arn => val[:topic_arn])[:attributes]
			puts "------------------------------------"
			puts "Topic ARN: " + t['TopicArn']
			puts "Topic name: " + t['DisplayName']
			puts "Topic owner: " + t['Owner']
			puts "Topic subscriptions: " + t['SubscriptionsConfirmed']
			puts "Topic policy: \n" + t['Policy']
		}
	end	

	def self.delete_topic(sns, name, arn)
		puts '===>> deleting list: ' + name
		sns.client.delete_topic(:topic_arn => arn)
	end

	def self.subscribe_topic(sns, topic, protocol, endpoint)
		puts '===>> subscribing endpoint'
		sns.client.subscribe(:topic_arn => topic, :protocol => protocol, :endpoint => endpoint).data[:subscription_arn]
	end

	def self.confirm_subscription(sns, topic, endpoint)
		puts '===>> confirming subscription'
		puts "Enter token to subscribe " + endpoint + ": "
		token = gets.chomp
		sns.client.confirm_subscription(:topic_arn => topic, :token => token)
		puts '===>> subscription confirmed'
	end

	def self.print_subscriptions(sns)
		puts '===>> printing subscriptions'
		sns.client.list_subscriptions[:subscriptions].each { |val|
			puts "------------------------------------"
			# subscription arn
			puts "Subscription ARN: " + val[:subscription_arn]
			# topic arn
			puts "Topic ARN: " + val[:topic_arn]
			# owner
			puts "Owner: " + val[:owner]
			# delivery policy
			t = sns.client.get_topic_attributes(:topic_arn => val[:topic_arn])[:attributes]
			puts "Policy: \n" + t['Policy']
		}
	end

	def self.publish_message(sns, topic, message)
		puts '===>> publishing message: ' + message
		sns.client.publish(:topic_arn => topic, :message => message)
		puts '===>> message published'
	end
	
end

pclient=SNSClient.parse(ARGV)

require "rubygems"
gem "aws-sdk"
require "aws-sdk"
require "optparse"
require "pp"
require "json"

class SQSClient
	def self.parse(args)
		sqs = AWS::SQS.new()
		op=OptionParser.new do | opts |
			opts.on("-m", "writes hello") do
				puts "Hey, user."
			end
			opts.on("-d", "executes functions for project 6") do
				puts "======================================="
				puts "==========CSC470 Project 06============"
				puts "======================================="

				sqs1 = 'csc470test'
				sqs2 = 'csc470test2'

				queue1 = create_queue(sqs, sqs1)
				queue2 = create_queue(sqs, sqs2)

				# print queue attributes
				print_queue_details(sqs, queue1)
				print_queue_details(sqs, queue2)

				# list queues
				list_queues(sqs)

				# send messages
				message1 = "test1"
				message2 = "test2"
				message3 = "test3"
				sent1 = send_message(queue1, message1)
				sent2 = send_message(queue1, message2)
				sent3 = send_message(queue1, message3)

				# delete queue
				delete_queue(queue2)

				# list queues
				list_queues(sqs)

				# print number of messages in queue
				queue_message_count(sqs, queue1, '1')

				# print message from queue
				puts "trying to fetch one message"
				print_message(sqs, queue1, 1)

				# print messages from queue
				puts "trying to fetch multiple messages"
				print_message(sqs, queue1, 10)

				# print number of messages in queue
				queue_message_count(sqs, queue1, '1')

				# delete queue
				delete_queue(queue1)

				# list queues
				list_queues(sqs)

			end
		end
		op.parse!(args)
	end
	
	def self.create_queue(sqs, name)
		puts '===>> creating queue: ' + name
		queue = sqs.queues.create(name)
		puts '===>> created queue ' + name
		queue
	end

	def self.print_queue_details(sqs, queue)
		puts '===>> queue details'
		# puts "------------------------------------"
		# arn
		puts queue.arn
		# creation time
		puts 'created on: 		' + queue.created_timestamp.to_s
		# last modified
		puts 'last modifed on: 	' + queue.last_modified_timestamp.to_s
		# message retention period
		seconds = queue.message_retention_period.to_s
		hours = (queue.message_retention_period/60/60).to_s
		puts 'messages retained for: 	' + seconds + ' seconds (' + hours + ' hours)'
	end

	def self.list_queues(sqs)
		puts '===>> listing queues'
		pp sqs.queues.collect(&:url)
	end

	def self.send_message(queue, message)
		puts '===>> sending message...'
		sent = queue.send_message(message)
	end

	def self.delete_queue(queue)
		puts '===>> deleting queue'
		queue.delete
		sleep(60)
		puts '===>> queue deleted!'
	end

	def self.queue_message_count(sqs, queue, id)
		puts '>>> approximate message count in queue ' + id + ': ' + queue.approximate_number_of_messages.to_s
	end

	def self.print_message(sqs, queue, limit)
		messages =  queue.receive_messages(:limit => limit)
		if messages.is_a? Array
			messages.each do |message|
				puts "---> message: " + message.body
			end
		else
			puts "---> message: " + messages.body
		end
	end

end

pclient=SQSClient.parse(ARGV)

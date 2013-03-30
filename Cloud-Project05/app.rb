require "rubygems"
gem "aws-sdk"
require "aws-sdk"
require "optparse"
require "pp"
require "json"
require 'open-uri'

class DDBClient
	def self.parse(args)
		ddb = AWS::DynamoDB.new
		op=OptionParser.new do | opts |
			opts.on("-m", "writes hello") do
				puts "Hey, user."
			end
			opts.on("-d", "executes functions for project 5") do
				puts "======================================="
				puts "==========CSC470 Project 05============"
				puts "======================================="

				ddb1 = 'CSC470Table01'
				ddb2 = 'CSC470Table02'

				puts "===>> Constructing tables..."
				table1 = create_table(ddb, ddb1)
				table2 = create_table_ranged(ddb, ddb2)
				puts "...check it out on the AWS console..."
				sleep 1 while table1.status == :creating
				sleep 1 while table2.status == :creating
				puts "===>> Tables constructed. In theory, at least."

				list_tables(ddb)

				describe_table(table1)
				describe_table(table2)

				put_data(table1)
				put_data(table2)

				puts "\nPress enter to continue"
				continue = gets

				# query/scan data
				query_scan(table1)
				query_scan(table2)
				# delete data
				# alter data

				change_capacity(table1, 2, 1)
				change_capacity(table1, 2, 0)
				change_capacity(table2, 2, 1)
				change_capacity(table2, 2, 0)

				describe_table(table1)
				describe_table(table2)

				puts "===>> Deconstructing tables..."
				delete_table(table1)
				delete_table(table2)
				puts "===>> Tables deconstructed. In theory, at least."
				puts "...check it out on the AWS console..."

				list_tables(ddb)
			end
		end
		op.parse!(args)
	end

	def self.create_table (client, name)
		client.tables.create(name, 1, 1,
			:hash_key => { :zip => :string },
			:latitude => { :latitude => :number},
			:longitude => { :longitude => :number},
			:city => { :city => :string },
			:state => { :state => :string },
			:mail_city => { :mail_city => :string },
			:mail_type => { :mail_type => :string })
	end

	def self.create_table_ranged (client, name)
		client.tables.create(name, 1, 1,
			:hash_key => { :city => :string },
			:range_key => { :zip => :string },
			:latitude => { :latitude => :number},
			:longitude => { :longitude => :number},
			:state => { :state => :string },
			:mail_city => { :mail_city => :string },
			:mail_type => { :mail_type => :string })
	end

	def self.list_tables(client)
		puts '===>> printing table list'
		client.tables.each do |table|
			puts table.name
		end
	end

	def self.delete_table(table)
		table.delete
	end

	def self.describe_table(table)
		puts '===>> printing table information'
		puts table.name + ", " + table.read_capacity_units.to_s + "/" + table.write_capacity_units.to_s
		puts table.hash_key.name.to_s + ": " + table.hash_key.type.to_s
		if table.has_range_key?
			puts table.range_key.name.to_s + ": " + table.range_key.type.to_s
		end
	end

	def self.full_chomp(laced)
		laced.chomp('"').reverse.chomp('"').reverse
	end

	def self.put_data(table)
		puts "===>> Fetching data..."
		url = 'https://s3.amazonaws.com/depasquale/datasets/zipcodes.txt'
		datafile = open(url) {|f| f.readlines }

		items = []

		puts "===>> Parsing data..."
		if table.has_range_key?
			40.times do |i|
				ibits = datafile[i].chomp.split(',')
				ibits.map! {|item| full_chomp(item)}
				items.push({:zip => ibits[0], :latitude => ibits[1].to_f,
					:longitude => ibits[2].to_f, :city => ibits[3],
					:state => ibits[4], :mail_city => ibits[5],
					:mail_type => ibits[6]})
				if items.length == 20
					block_push(items, table)
					items = []
				end
			end
			if items.length > 0
				block_push(items, table)
			end
		else
			20.times do |i|
				ibits = datafile[i].chomp.split(',')
				ibits.map! {|item| full_chomp(item)}
				items.push({:zip => ibits[0], :latitude => ibits[1].to_f,
					:longitude => ibits[2].to_f, :city => ibits[3],
					:state => ibits[4], :mail_city => ibits[5],
					:mail_type => ibits[6]})
			end
			block_push(items, table)
		end
	end

	def self.block_push(block, target)
		puts "===>> Data parsed, ready to store:"		
		puts block
		puts "===>> Storing data..."
		target.batch_put(block)
		puts "===>> Data stored."
	end

	def self.change_capacity(table, value, target)
		puts "===>> altering table..."
		puts "...check it out on the AWS console..."
		if target == 1
			table.read_capacity_units = value
		else
			table.write_capacity_units = value
		end
		sleep(45)
		puts "===>> Tables altered. In theory, at least."
	end

	def self.query_scan(target)
		puts "===>> new scan..."
		if target.has_range_key?
			puts "======================== ARECIBO"
			results = target.items.where(:city).equals("ARECIBO")
			results.each do |item|
				puts "========================"
				tmp = item.attributes
				tmp.each { |(name, value)| puts "#{name} = #{value}" }
			end
			puts "======================== greater than ARECIBO"
			results = target.items.where(:city).greater_than("ARECIBO")
			results.each do |item|
				puts "========================"
				tmp = item.attributes
				tmp.each { |(name, value)| puts "#{name} = #{value}" }
			end
		else
			puts "======================== greater than 00610"
			results = target.items.where(:zip).greater_than("00610")
			results.each do |item|
				puts "========================"
				tmp = item.attributes
				tmp.each { |(name, value)| puts "#{name} = #{value}" }
			end
		end
	end

end

pclient=DDBClient.parse(ARGV)

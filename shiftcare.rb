require 'json'

def load_client_data(file_name)
  JSON.parse(File.read(file_name))
end

def search_clients_by_name(data, query)
  clients = data.select { |client| client['full_name'].downcase.include?(query.downcase) }

  if clients.empty?
    puts "No clients found with a name matching '#{query}'."
  else
    puts "Clients with names matching '#{query}':"
    clients.each do |client|
      puts "ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
    end
  end
end

def find_duplicate_emails(data)
  email_count = Hash.new(0)
  duplicates = []

  data.each do |client|
    email = client['email']
    if email_count[email] == 1
      duplicates << email
    end
    email_count[email] += 1
  end

  if duplicates.empty?
    puts "No clients with duplicate emails found."
  else
    puts "Clients with duplicate emails:"
    duplicates.each do |email|
      clients = data.select { |client| client['email'] == email }
      clients.each do |client|
        puts "ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
      end
    end
  end
end

# Main program
client_data = load_client_data('clients.json')

while true
  puts "Select an option:"
  puts "1. Search clients by name"
  puts "2. Find clients with duplicate emails"
  puts "3. Exit"
  print "Enter your choice: "

  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter a name to search: "
    query = gets.chomp
    search_clients_by_name(client_data, query)
  when 2
    find_duplicate_emails(client_data)
  when 3
    exit
  else
    puts "Invalid choice. Please enter a valid option."
  end
end

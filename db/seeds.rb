# frozen_string_literal: true

app = FactoryBot.create :application
user = FactoryBot.create :user

puts "\e[32mApplication created: #{app.name}\e[0m \n\033[1mUID:\033[0m #{app.uid} \n\033[1mSECRET:\033[0m #{app.secret}\n\n"
puts "\e[32mUser created: #{user.id}\e[0m \n\033[1memail:\033[0m #{user.email} \n\033[1mpassword:\033[0m Pa$$w0rd\n\n"

# Generate 100 tasks for the user
FactoryBot.create_list :task, 100, user: user
puts "\e[32m100 Tasks created for user #{user.id}\e[0m\n\n"
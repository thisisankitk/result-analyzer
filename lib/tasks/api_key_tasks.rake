namespace :api_key do
  desc "Generate an API key"
  task generate: :environment do
    key = ApiKey.create!
    puts "Generated API Key: #{key.access_token}"
  end
end

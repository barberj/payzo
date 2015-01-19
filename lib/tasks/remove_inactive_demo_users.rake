desc "Removes demo users inactive for more than 1 hour"
task :remove_inactive_demo_users => :environment do
  User.where("demo is true AND last_active_at < ?", 1.hour.ago).destroy_all
end
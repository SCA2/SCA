namespace :spec do
  desc "Run mailer specs in production environment"
  task css_mailers: [:set_production_env, :environment] do
    Rake::Task['spec:mailers'].invoke
  end

  desc "Custom dependency to set production environment"
  task :set_production_env do
    Rails.env = "production"
  end
end

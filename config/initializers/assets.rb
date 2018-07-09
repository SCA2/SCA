Rails.application.configure do

  # Be sure to restart your server when you modify this file.

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Add additional assets to the asset load path
  # config.assets.paths << Emoji.images_path

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  config.assets.precompile += %w( search.js )

  # Precompile for html mail
  config.assets.precompile += %w( mailers.scss )

  # Precompile for Foundation.
  config.assets.precompile += %w( vendor/modernizr.js )

end
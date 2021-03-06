# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

# require "thor"

namespace :config do
  namespace :deprecated do
    desc "Generate database.yml"
    task :"database.yml" do
      puts "Copying database.yml"
      copy_file "lib/templates/config/deprecated/database.yml", "config/database.yml"
    end

    desc "Generate secrets.yml"
    task :"secrets.yml" do
      puts "Copying secrets.yml"
      copy_file "lib/templates/config/deprecated/secrets.yml", "config/secrets.yml"
    end

    desc "Generate Gemfile.local"
    task :"Gemfile.local" do
      puts "Copying Gemfile.local"
      copy_file "lib/templates/config/deprecated/Gemfile.local", "Gemfile.local"
    end
  end

  desc "Generate config files for dotenv environmnet variables."
  task :deprecated => [:"deprecated:database.yml", :"deprecated:secrets.yml", :"deprecated:Gemfile.local"]

  desc "Generate database.yml"
  task :"database.yml" do
    puts "Copying database.yml"
    copy_file "lib/templates/config/current/database.yml", "config/database.yml"
  end

  desc "Generate secrets.yml"
  task :"secrets.yml" do
    puts "Copying secrets.yml"
    copy_file "lib/templates/config/current/secrets.yml", "config/secrets.yml"
  end

  desc "Generate cipher iv, key"
  task :cipher do
    cipher = EasyCipher::Cipher.new
    puts "key: #{cipher.key64}"
    puts "iv: #{cipher.iv64}"
  end

end

task :config => [:"config:database.yml", :"config:secrets.yml"] do
  puts "Installed basic configuration files for development and test."
  puts "See config/database.yml.example, config/secrets.yml.example for more info."
  puts "You may also wish to create a Gemfile.local to include gems specific to your environment."
end


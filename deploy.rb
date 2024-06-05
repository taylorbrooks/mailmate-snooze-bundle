#!/usr/bin/env ruby

require 'fileutils'

SOURCE = 'Snooze'
TARGET = 'Snooze.mmBundle'

deploy_path = File.join(ENV['HOME'], 'Library/Application Support/MailMate/Bundles/', TARGET)
FileUtils::rm_rf(deploy_path) if File.exists?(deploy_path)
FileUtils::cp_r SOURCE, deploy_path

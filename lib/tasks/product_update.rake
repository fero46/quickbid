load "#{Rails.root.join("lib", "tasks")}/database_actions.rb"
require 'pathname'

namespace :product do
  desc "Erstelle eine Auction"
  task :update => :environment do
    print_out "Starte Produkt Update #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
    print_out "Durchsuche Plugin Ordner"
    plugin_folder = Rails.root.join("lib", "tasks", "plugins")
    connector = DatabaseActions.new
    res = Dir.glob("#{plugin_folder}/*.rb").map do |file|
      importer = load_importer file
      if importer
        print_out "[#{importer.class.name}] - #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}: Import start" 
        importer.import connector 
        print_out "[#{importer.class.name}] - #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}: Import beendet}"
      end
    end
  end
end


def print_out string
  print "#{string}\n"
end

def read_configurator
  conf = []
  File.open("#{Rails.root.join("lib", "tasks")}/importer.conf").each do |line|
    conf << line
  end
  conf
end


def should_load? string
  @config =@config || read_configurator
  @config.any? { |conf| conf == string }
end

def load_importer file
  load file
  basename = Pathname.new(file).basename.to_s
  basename.slice! ".rb"
  basename.capitalize.constantize.new if should_load? basename
end


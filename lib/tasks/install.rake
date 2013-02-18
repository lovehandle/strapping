def prompt(*args)
  print *args
  STDIN.gets.chomp
end

def name
  @name
end

def set_name
  @name = prompt("Please enter an Application Name: ")
end

def rename_application

  puts "Renaming application to #{name}"

  Dir.glob("#{Rails.root}/**/*.*") do |file_name|
    text = File.open(file_name, 'r'){ |file| file.read }
    if text.gsub!("Strapping", name)
      File.open(file_name, 'w'){|file| file.write(text)}
    end
  end

  puts "Application has been renamed to #{name}"
end

def create_database_config
  puts "Creating database.yml"
  FileUtils.cp("#{Rails.root}/config/database.yml.sample", "#{Rails.root}/config/database.yml")
end

def create_database
  puts "Creating databases"
  Rake::Task['db:create:all'].execute  
end

def clear_readme
  puts "Clearing README.md"
  File.open("#{Rails.root}/README.md","w") {|file| file.write("== #{name}") }
end

def remove_install_task
  puts "Removing install task"
  FileUtils.rm("#{Rails.root}/lib/tasks/install.rake")
end

namespace :strapping do
  desc "Installs the app"
  task :install do
    set_name
    rename_application
    create_database_config
    create_database
    clear_readme
    remove_install_task
  end
end

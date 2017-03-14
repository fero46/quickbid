
new_user= true

if new_user
  f = File.open(Rails.root.join("db/jihi_usernames"), "rb") 
  usernames =[]  # start with an empty array
  f.each_line {|line| usernames.push line}
  usernames.each{|name| name.gsub!(/\s+/, "")}
  counter = 0
  User.destroy_all
  usernames.each do |username|
    bot=User.new(:email=> "mail#{counter}@fashionfly.de", :password=>"mypass1983kmaras46", :password_confirmation=>"mypass1983kmaras46",:username=>username, :skip_terms => true)
    bot.bot=true
    bot.skip_confirmation!
    bot.skip_confirmation_notification!
    bot.save!
    counter=counter+1
  end
end

category_file = "db/jihi/index.category"
category_path = "db/jihi/"


def read_categories(_path, _file, parent = nil)
  order = 0
  parent_id = parent == nil ? nil : parent.id
  leaf = false
  file = File.open(_file, "rb")

  file.each_line do |line|
    line.strip!
    leaf = !File.directory?("#{_path}/#{line}")
    category = Category.create(:name => line, 
                               :order_value => order, 
                               :category_id => parent_id,
                               :is_leaf => leaf)
    read_categories("#{_path}/#{line}", "#{_path}/#{line}/index.category", category) unless leaf
    order= order + 10
  end
end

#
# Read the categories
#
Category.destroy_all
read_categories(category_path,category_file)

#@categories = Category.all

#for category in @categories
#  category.image=File.open("db/images/#{category.name}.jpg")
#  category.save!
#end

# VariationGroup.create(:name => 'size')

#
# Creates the Admin
#
#

User.destroy_all(role: User.ADMIN)

default  = "changeMe!"
admins = [{email: "admin@jihi.de", name: "Admin" }]

admins.each do |admin|
  user = User.new(:email => admin[:email], :password => default, :password_confirmation => default, :username => admin[:name], :skip_terms => true)
  user.role = User.ADMIN
  user.skip_confirmation!
  user.terms=1
  user.save!
end
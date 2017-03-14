parent_computer = Category.find_by_name('computer')

Category.create(name: "software", category_id: parent_computer.id, :order_value => 40, is_leaf: true)
Category.create(name: "hardware", category_id: parent_computer.id, :order_value => 50, is_leaf: true)
Category.create(name: "tablets", category_id: parent_computer.id, :order_value => 60, is_leaf: true)

parent_entertainment = Category.find_by_name('entertainment')
Category.create(name: "movie_music", category_id: parent_entertainment.id, :order_value => 30, is_leaf: true)
Category.create(name: "dj_studio", category_id: parent_entertainment.id, :order_value => 40, is_leaf: true)
Category.create(name: "speaker", category_id: parent_entertainment.id, :order_value => 50, is_leaf: true)

parent = Category.create(name: "lifestyle", category_id: nil, :order_value => 50, is_leaf: false)
Category.create(name: "uhren", category_id: parent.id, :order_value => 0, is_leaf: true)
Category.create(name: "livingstyle", category_id: parent.id, :order_value => 10, is_leaf: true)

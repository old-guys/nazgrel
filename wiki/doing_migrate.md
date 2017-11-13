## add comment in migration

Database schemas change rapidly as project progresses. And it can be difficult to track
purpose of each table and each column in a large project with multiple team members.

The solution for this problem is to document data models right from Rails migrations.

Rails 5 allows to specify comments for tables, column and indexes in migrations.
These comments are stored in database itself.

Currently **only** MySQL and PostgreSQL supports adding comments.

We can add comments in migration as shown below.

```ruby
class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products, comment: 'Products table' do |t|
      t.string :name, comment: 'Name of the product'
      t.string :barcode, comment: 'Barcode of the product'
      t.string :description, comment: 'Product details'
      t.float :msrp, comment: 'Maximum Retail Price'
      t.float :our_price, comment: 'Selling price'

      t.timestamps
    end

    add_index :products, :name,
              name: 'index_products_on_name',
              unique: true,
              comment: 'Index used to lookup product by name.'
  end
end
```

add comment to exist table and columns:

```ruby
change_table_comment :table_name, 'comment'
change_column_comment :table_name, :column_name, 'comment'
```

while raise

```shell
NotImplementedError: ActiveRecord::ConnectionAdapters::Mysql2Adapter does not support changing table comments
```

use gem `migration_comments`

## references

- [adding comments migrations](https://blog.bigbinary.com/2016/06/21/rails-5-supports-adding-comments-migrations.html)
- [Comments for your migrations](https://github.com/pinnymz/migration_comments)

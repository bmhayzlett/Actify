#ActiveRecordLite

ActiveRecordLite is an Object-Relational Mapping tool inspired by ActiveRecord.
It allows users to create and modify rows in database tables.

In order to use ActiveRecordLite, please download the repo and run "bundle install".
1. Enter pry or irb to test the program's functionality.
2. Tables in the test database include "cats", "humans", and "houses".
    To start using ActiveRecordLite for a table, run the following code, with
    class Cat as an example:
    ```ruby
    class Cat < SQLObject
      self.finalize!
    end
    ```
3.  You may now test code functionality such as:
    ```ruby
    Cat.all
    ```



[More on ActiveRecord!](https://en.wikipedia.org/wiki/Active_record_pattern)

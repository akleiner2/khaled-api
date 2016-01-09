class CreateQuotes < ActiveRecord::Migration
    def up
        create_table :khaled_quotes do |t|
            t.string :quote
        end
    end

    def down
        drop_table :khaled_quotes
    end
end

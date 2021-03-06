# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


class CreateRestoreTransfers < ActiveRecord::Migration
  def change
    create_table :restore_transfers do |t|
      t.references :bag, null: false
      t.integer :from_node_id, null: false
      t.integer :to_node_id, null: false
      t.references :restore_status, null: false
      t.references :protocol, null: false
      t.string :link, null: false
      t.timestamps null: false
    end
  end
end

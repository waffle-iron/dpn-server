# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

class AddTimestampsToMessageDigests < ActiveRecord::Migration

  class Bag < ActiveRecord::Base
  end

  class MessageDigest < ActiveRecord::Base
    belongs_to :bag
  end

  def up
    add_column :message_digests, :created_at, :datetime
    MessageDigest.all.each do |md|
      md.update!(created_at: md.bag.created_at)
    end
    execute("
      ALTER TABLE `message_digests`
      MODIFY created_at
      TIMESTAMP
      DEFAULT CURRENT_TIMESTAMP NOT NULL;
    ")
  end

  def down
    remove_column :message_digests, :created_at
  end
end

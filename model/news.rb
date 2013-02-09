# -*- encoding: utf-8 -*-
require 'sequel'
Sequel::Model.plugin(:schema)

Sequel.connect("sqlite://news.db")

class News < Sequel::Model
  plugin :validation_helpers

  @@kinds = {1 => 'ガーデン', 2 => '外壁塗装', 3 => 'シロアリ防除'}

  unless table_exists?
    set_schema do
      primary_key :id
      integer :kind
      string :title
      string :link
      timestamp :created
    end
    create_table
  end

  def validate
    super
    validates_presence [:title]
  end

  def kinds
    @@kinds
  end

  def kind_name
    @@kinds[self.kind]
  end
end

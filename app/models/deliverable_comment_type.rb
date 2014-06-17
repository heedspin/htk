require 'plutolib/active_hash_methods'
class DeliverableCommentType < ActiveHash::Base
  self.data = [
    {id: 1, name: 'Note',       js_controller: 'CommentsController'},
    {id: 2, name: 'Complete',   js_controller: 'CompletionCommentsController'},
    {id: 3, name: 'Incomplete', js_controller: 'CompletionCommentsController'}
  ]
  include Plutolib::ActiveHashMethods

  # For deliverable_comment_type.js.erb
  ColumnType = Struct.new(:name)
  def self.columns
  	%w(id name js_controller).map { |k| ColumnType.new(k) }
  end

  def to_hash
  	self.attributes
  end

  def self.json_root
  	'comment_type'
  end
end

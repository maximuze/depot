class Product < ActiveRecord::Base
  
  default_scope :order => 'title'
  has_many :line_items
  has_many :orders, :through => :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item
  
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else 
      errors.add(:base, 'Line Items present')
      return false
    end
  end
  
  attr_accessible :description, :image_url, :price, :title
  validates :title, :description, :image_url, :presence => true 
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :title, :length => {:minimum => 10 }
  validates :image_url, :format => {
  	:with => %r{\.(gif|jpg|png)$}i, 
  	:message => 'must be a URL for GIF, JPG or PNG image.'
  	}
end

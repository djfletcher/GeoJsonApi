# == Schema Information
#
# Table name: road_edges
#
#  id               :integer          not null, primary key
#  intersection1_id :integer          not null
#  intersection2_id :integer          not null
#  street_name      :string
#  length           :float
#

class RoadEdge < ActiveRecord::Base

  has_many :road_points

  belongs_to :intersection1,
    class_name: :Intersection,
    foreign_key: :intersection1_id,
    primary_key: :id

  belongs_to :intersection2,
    class_name: :Intersection,
    foreign_key: :intersection2_id,
    primary_key: :id


  def self.offsetted(num_rows)
    RoadEdge.offset(num_rows).limit(5000)
  end

  def self.offsetted_intersection_pairs(num_rows)
    all_intersections = Intersection.all.index_by(&:id)
    RoadEdge.offsetted(num_rows).map do |edge|
      [all_intersections[edge.intersection1_id], all_intersections[edge.intersection2_id]]
    end
  end

  def self.offsetted_intersection_pairs_by_id(num_rows)
    RoadEdge.offsetted(num_rows).map(&:intersection_ids)
  end

  def intersections
    [self.intersection1, self.intersection2]
  end

  def intersection_ids
    [self.intersection1_id, self.intersection2_id]
  end

end

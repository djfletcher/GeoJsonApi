# Road Network API

This is an API that returns road network graphs for different cities around the world. Currently only data on San Francisco streets are loaded into the database. The project is ongoing and contributions or pull requests are welcome.

## API Endpoints

There are currently two endpoints exposed:
+ `http://road-network-api.herokuapp.com/intersections` returns a JSON array of `intersections`.
+ `http://road-network-api.herokuapp.com/road_edges` returns a JSON array of `road_edges`.

**Note that each of the above endpoints takes one parameter, an integer `$offset`, which corresponds to SQL's OFFSET command. This is due to the fact that each call returns a maximum of 5,000 rows, for performance reasons.**

Example using jQuery's [$.ajax method](http://api.jquery.com/jquery.ajax/):

````javascript
$.ajax({
    url: 'http://road-network-api.herokuapp.com/road_edges',
    data: {
      '$offset': 5000
    }
  })
````

## Schema

The [database](./db/schema.rb) consists of three tables: `intersections`, `road_edges`, and `road_points`. The schema for each table is as follows:

````ruby
# Table name: intersections
# =========================
#  id        :integer          not null, primary key
#  latitude  :decimal(10, 6)   not null
#  longitude :decimal(10, 6)   not null

# Table name: road_edges
# =========================
#  id               :integer          not null, primary key
#  intersection1_id :integer          not null
#  intersection2_id :integer          not null
#  street_name      :string

# Table name: road_points
# =========================
#  id           :integer          not null, primary key
#  latitude     :decimal(10, 6)   not null
#  longitude    :decimal(10, 6)   not null
#  road_edge_id :integer          not null
````

`intersections` contains only a latitude and longitude for each intersection, which are stored as [`BigDecimal`](https://ruby-doc.org/stdlib-1.9.3/libdoc/bigdecimal/rdoc/BigDecimal.html) types. `road_edges` contain a foreign key for each of the two `intersections` connected by the edge, plus its street name. `road_points` contain a latitude and longitude for that roadpoint, plus the foreign key of the `road_edge` that it falls upon.
![Build](https://github.com/k-p-jones/data_snapshots/workflows/Build/badge.svg)
# data_snapshots

Simple, flexible data snapshotting for your Rails app.

## Installation
Run the following command to add `data_snapshots` to your Gemfile:
``` shell
bundle add data_snapshots
```
Once installed, copy and run the migration:
```shell
bundle exec rails data_snapshots_engine:install:migrations
bundle exec rails db:migrate
```
## Registering a model snapshot
A model snapshot is a collection of methods that run against a model instance. Methods will be passed the instance when the snapshot is generated.

You can register your snapshots in an initializer:

```ruby
DataSnapshots.configure  do  |c|
  c.register_snapshot name: :user_assignments do |methods|
    methods[:total] = ->(instance) { instance.assignments.count }
    methods[:total_complete] = ->(instance) { instance.assignments.where(complete: true).count }
  end
end
```

## Registering a generic snapshot
A generic snapshot is a collection of methods that will not be passed a model instance when the snapshot is generated. You can declare a snapshot as generic by passing `model: false` as an argument when registering the snapshot:

```ruby
DataSnapshots.configure  do  |c|
  c.register_snapshot name: :totals, model: false do |methods|
    methods[:total_users] = ->() { User.count }
    methods[:total_assignments] = ->() { Assignments.count }
  end
end
```

## Generating model snapshots
Model snapshots can either be generated on the individual instance:
```ruby
user = User.last
user.generate_snapshot(name: :user_assignments)
```
Or you can generate them with a collection of records:
```ruby
DataSnapshots.generate_snapshots(name: :user_assignments, collection: User.all)
```

## Generating generic snapshots
Generic snapshots can be created by passing the name of the snapshot to `DataSnapshots.generate_snapshot`
```ruby
DataSnapshots.generate_snapshot(name: :total_users)
```

## Fetching snapshots
`data_snapshots` comes with a `<NAME>_snapshots` method so its easy to fetch all the snapshots taken against a particular instance:
```ruby
user.user_assignments_snapshots
```
You can fetch your generic snapshots by calling `DataSnapshots.fetch_snapshots` and passing the name of your snapshot:
```ruby
DataSnapshots.fetch_snapshots(name: :total_users)
```
This method can also be used to fetch _ALL_ model snapshots with the given name.

## Viewing snapshot data

Snapshot data is stored as JSON in the database and can be accessed easily:

```ruby
snapshot.data # => { 'key' => 'value' }
```

## License

The gem is available as open source under the terms of the  [MIT License](https://opensource.org/licenses/MIT). 

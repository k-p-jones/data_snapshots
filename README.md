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
## Registering your first snapshot
A snapshot is a collection of methods that run against a model instance. Methods will be passed the instance when they are invoked.

You can register your snapshots in an initializer:

```ruby
DataSnapshots.configure  do  |c|
  c.register_snapshot  name:  :user_assignments  do  |methods|
    methods[:total] = ->(instance) { instance.assignments.count }
    methods[:total_complete] = ->(instance) { instance.assignments.where(complete: true).count }
  end
end
```

## Generating snapshots
Snapshots can either be generated on the individual instance:
```ruby
user = User.last
user.generate_snapshot(name: :user_assignments)
```
Or you can generate them with a collection of records:
```ruby
DataSnapshots.generate_snapshots(name: :user_assignments, collection: User.all)
```

## Fetching snapshots
`data_snapshots` comes with a `<NAME>_snapshots` method so its easy to fetch all the snapshots taken against a particular instance:
```ruby
user.user_assignments_snapshots
```

## Viewing snapshot data

Snapshot data is stored as JSON in the database and can be accessed easily:

```ruby
snapshot.data # => { 'key' => 'value' }
```

## License

The gem is available as open source under the terms of the  [MIT License](https://opensource.org/licenses/MIT). 

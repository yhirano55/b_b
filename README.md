# BB

(b_b) is SQL Query Builder for [Google BigQuery](https://cloud.google.com/bigquery)

[![Gem Version](https://badge.fury.io/rb/b_b.svg)](https://badge.fury.io/rb/b_b)
[![Dependency Status](https://gemnasium.com/badges/github.com/yhirano55/b_b.svg)](https://gemnasium.com/github.com/yhirano55/b_b)
[![Build Status](https://travis-ci.org/yhirano55/b_b.svg?branch=master)](https://travis-ci.org/yhirano55/b_b)
[![Coverage Status](https://coveralls.io/repos/github/yhirano55/b_b/badge.svg?branch=master&key=201607161500)](https://coveralls.io/github/yhirano55/b_b?branch=master)
[![codebeat badge](https://codebeat.co/badges/5e694b1a-93b1-4fda-ad6e-3dc0d5afe76b)](https://codebeat.co/projects/github-com-yhirano55-b_b)

## Install

Add the following line to Gemfile:

    gem 'b_b'

and run `bundle` from your shell.

To install the gem manually from your shell, run:

    gem install b_b

## Basic usage

(b_b) can build only **SQL SELECT Statement**.

```rb
BB.select("word", "corpus", "COUNT(word)").
   from("publicdata:samples.shakespeare").
   where(word_cont: "th").
   group(:word, :corpus).
   to_sql

# => "SELECT word, corpus, COUNT(word) FROM publicdata:samples.shakespeare WHERE (word CONTAINS 'th') GROUP BY word, corpus"
```

Query Reference of BigQuery's query syntax and functions is [here](https://cloud.google.com/bigquery/query-reference?hl=en).

## Examples

L(b_b)z ==============33

### SELECT clause

```ruby
BB.select(:id, :name, :state).to_sql
# => "SELECT id, name, state"

BB.select("id", "name", "COUNT(*)").to_sql
# => "SELECT id, name, COUNT(*)"
```

### FROM clause

```ruby
BB.from("publicdata:samples.shakespeare").to_sql
# => "SELECT * FROM publicdata:samples.shakespeare"

BB.from("[applogs.events_20120501]", "[applogs.events_20120502]", "[applogs.events_20120503]").to_sql
# => "SELECT * FROM [applogs.events_20120501], [applogs.events_20120502], [applogs.events_20120503]"

BB.from("applogs.events_", on: Date.new(2012, 5, 1)).to_sql
# => "SELECT * FROM applogs.events_20120501"

BB.from("mydata.people", from: Date.new(2014, 3, 25), to: Date.new(2014, 3, 27)).to_sql
# => "SELECT * FROM TABLE_DATE_RANGE(mydata.people, TIMESTAMP('2014-03-25'), TIMESTAMP('2014-03-27'))"

BB.from(BB.from("publicdata:samples.shakespeare"), as: shakespeare).to_sql
# => "SELECT * FROM (SELECT * FROM publicdata:samples.shakespeare) AS shakespeare"
```

### JOIN clause

```ruby
BB.from(:customers, as: :t1).inner_join(:orders, as: :t2).on("t1.customer_id = t2.customer_id").to_sql
# => "SELECT * FROM customers AS t1 INNER JOIN orders AS t2 ON t1.customer_id = t2.customer_id"

BB.from(:customers, as: :t1).join_each(BB.select(:id, :name).from(:orders), as: :t2).on("t1.customer_id = t2.customer_id").to_sql
# => "SELECT * FROM customers AS t1 JOIN EACH (SELECT id, name FROM orders) AS t2 ON t1.customer_id = t2.customer_id"
```

### WHERE clause

```ruby
BB.where(id: 1..10, name: "donald", flag: false).to_sql
# => "WHERE (id BETWEEN 1 AND 10 AND name = 'donald' AND flag IS false)"

BB.where("id = ? OR name CONTAINS ?", 123, "john").to_sql
# => "WHERE (id = 123 OR name CONTAINS 'john')"

BB.where("id = :id AND name <> :name", id: 123, name: "trump").to_sql
# => "WHERE (id = 123 AND name <> 'trump')"

BB.where(id_gteq: 123, name_not_cont: "melania").to_sql
# => "WHERE (id >= 123 AND NOT name CONTAINS 'melania')"

BB.where(id: 123).or.where(id: 456).to_sql
# => "WHERE (id = 123) OR (id = 456)"

BB.not.where(id: 123).or.not.where(id: 456).to_sql
# => "WHERE (id <> 123) OR (id <> 456)"

BB.where(id: 123, name: "trump", reduce: :or).to_sql
# => "WHERE (id = 123 OR name = 'trump')"
```

### OMIT RECORD IF clause

```ruby
BB.omit_record_if("COUNT(payload.pages.page_name) <= ?", 80).to_sql
# => "OMIT RECORD IF (COUNT(payload.pages.page_name) <= 80)"
```

### GROUP BY clause

```ruby
BB.group(:age, :gender).to_sql
# => "GROUP BY age, gender"

BB.group("ROLLUP(year, is_male)").to_sql
# => "GROUP BY ROLLUP(year, is_male)"

BB.group_each(:age, :gender).to_sql
# => "GROUP EACH BY age, gender"
```

### HAVING clause

```ruby
BB.having(first_cont: "a", ngram_count_lt: 10000).to_sql
# => "HAVING (first CONTAINS 'a' AND ngram_count < 10000)"

BB.having("first CONTAINS ? AND negram_count < ?", "a", 10000).to_sql
# => "HAVING (first CONTAINS 'a' AND ngram_count < 10000)"

BB.having("first CONTAINS :first AND negram_count < :negram_count", first: "a", negram_count: 10000).to_sql
# => "HAVING (first CONTAINS 'a' AND ngram_count < 10000)"

BB.having(first: "a").or.not.having(first: "b").to_sql
# => "HAVING (first = 'a') OR (first <> 'b')"
```

### ORDER BY clause

```ruby
BB.order(:age, :gender).to_sql
# => "ORDER BY age, gender"

BB.order(age: :desc, gender: :asc).to_sql
# => "ORDER BY age DESC, gender ASC"
```

### LIMIT clause

```ruby
BB.limit(1000).to_sql
# => "LIMIT 1000"

BB.limit(1000).offset(500).to_sql
# => "LIMIT 1000 OFFSET 500"
```

## Support

### JOINS

Support methods:

- cross_join
- full_outer_join_each
- inner_join
- inner_join_each
- join
- join_each
- left_join
- left_join_each
- left_outer_join
- left_outer_join_each
- right_join
- right_join_each
- right_outer_join
- right_outer_join_each

### Suffix of hash keys

For `omit_record_if`, `where`, `having`:

| suffix | means | alias | opposite | example |
|:------:|:------|:------|:---------|:--------|
| cont | contains | `contains`, `like` | `not_cont`, `not_contains`, `not_like` | `BB.where(name_cont: "banana")` |
| eq | equals | `eql`, `equals` | `not_eq`, `not_eql`, `not_equals` | `BB.where(id_not_eq: 123)` |
| gt | greater than | *undefined* | `not_gt` | `BB.where(id_not_gt: 123)` |
| gteq | greater than or equals to | *undefined* | `not_gteq` | `BB.where(id_not_gteq: 123)` |
| lt | less than | *undefined* | `not_lt` | `BB.where(id_not_lt: 123)` |
| lteq | less than or equals to | *undefined* | `not_lteq` | `BB.where(id_not_lteq: 123)` |

## Contributing

Here's a quick guide:

1. Fork the repo.
2. Create a thoughtfully-named branch for your changes (`git checkout -b my-new-feature`).
3. Install the development dependencies by running `bundle install`.
4. Begin by running the tests.

        $ bundle exec rspec

5. Implement something.
6. Add tests for your changes.
7. Make the tests pass.
8. Commit your changes (`git commit -am 'Add feature/Fix bug/improve something'`)
9. Push the branch up to your fork on GitHub
   (`git push origin my-new-feature`) and from GitHub submit a pull request to
   b_b's `master` branch.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

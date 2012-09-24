# Cockroach

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'cockroach'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cockroach

## Usage


 There are several ways how to specify the required amount of the records:

   First way is *simple*:

     Just specify the amount of the records that are require or provide the range:

     An example:

       # a strict amount
       users_amount: 1000 # what will generate 1000 records for user factory

       # or a fuzzy way
       feeds_ratio: 1000 # what will generate a random amount of users, in the range between 500 and 2000.

     *amount* - will just generate the scrict amount of record. In the example above,
                there will be 1000 users in the database.
     *ratio*  - will pick a random amount of Feed records, within a range a range.
                By default, the limitations are obeying the following principle:
                  ( specified_number/2, specified_number * 2 )
                NB! It will *ALWAYS* be a flored Integer.

     This method is helpful, once you are dealing with data structure you can consider as simple.
     So you need to create a specific amount of records, without any subsequential creation.

   Next way is *simple subsequential*:

     You can specify the amount of records one level under the record type:

     An examples:

       # a strict amount
       business:
         amount: 1000

       # or fuzzy way:
       users:
         ratio: 1000

       # or more fuzzy way:
       users:
         ratio:
           lower_limit: 300
           upper_limit: 10000

     *amount* and *ratio* have same meaning as in the previous example.
     In the last example, the amount will be a random number, within
       ( lower_limit..upper_limit )

   Next way is *complicated subsequential*:

     It if often needed to generate a associated models, like in case when
     City'es may have many associated Place'es.
     A brief examples:

       # simple case
       cities:
         amount: 1000
         places_ratio: 300

      # or a bit more complecated
      cities:
        amount: 1000
        places:
          ratio:
            lower_limit: 100
            upper_limit: 1000
          address_amount: 1


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

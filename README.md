Bestmix
=======

Bestmix is a simple pair of iOS app and Rails-based backend.
You can use it as a basic structure to build your own iOS app and  backend web API integrated with each other.
They are connected with JSON REST API supporting CRUD, pagination, caching, OAuth2 and Facebook integration.

Features
--------

### Server-Side

* Generating JSON from DB records
* HTTP caching
* Basic authentication with Email and passwrod
* Facebook login
* Call Facebook API using authorized token
* OAuth2 authorization for web API
* Admin UI

### iOS App

* Parsing JSON response and importing it into Core Data
* Pagination
* HTTP caching
* Checking reachability and display object cache if it is offline
* Getting OAuth2 authorization from web API

These features are implemented using libraries listed below.

Libraries
---------

### Server-Side

* [Ruby on Rails](http://rubyonrails.org/ ) - Web Framework
* [Devise](https://github.com/plataformatec/devise ) - Authentication
* [RABL](https://github.com/nesquena/rabl ) - JSON Formatter
* [Doorkeeper](https://github.com/applicake/doorkeeper ) - OAuth2 Provider
* [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook ) - Facebook Login
* [Koala](https://github.com/arsduo/koala ) - Facebook Library for Ruby
* [versionist](https://github.com/bploetz/versionist ) - API Versioning
* [Active Admin](http://activeadmin.info/) - Admin Interface

See [Gemfile](http://github.com/yatsu/bestmix/blob/master/server/Gemfile ) for more details

### iOS App

* [CocoaPods](http://cocoapods.org/ ) - Library Management
* [AFNetworking](https://github.com/AFNetworking/AFNetworking ) - Networking Framework
* [Reachability](https://github.com/tonymillion/Reachability ) - Network Reachability
* [SDURLCache](https://github.com/rs/SDURLCache ) - HTTP Caching
* [MagicalRecord](https://github.com/magicalpanda/MagicalRecord ) - Active Record for Core Data
* [mogenerator](https://github.com/rentzsch/mogenerator ) - Core Data Code Generation

See [Podfile](http://github.com/yatsu/bestmix/blob/master/ios/Podfile ) for more details.

Requirements
------------

### Server-Side

* Ruby >= 1.9
* MySQL (you can use another DB server by editing Gemfile)

### iOS App

* iOS >= 5.0
  * requries ARC and Storyboard

Setup
-----

### Server-Side

1. Install [Ruby on Rails](http://rubyonrails.org/ ) and [RVM](https://rvm.io/ ) if you don't have them.
2. Copy server/config/database.yml.example to server/config/database.yml and modify it.
3. Copy server/config/initializers/devise.rb.example to server/config/initializers/devise.rb and modify it (See [Devise](https://github.com/plataformatec/devise ) for details).
4. `cd server; bundle; rake db:setup`
5. `rails s` # (or setup your web server such as Apache, nginx, etc.)

### iOS App

1. Install [mogenerator](https://github.com/rentzsch/mogenerator ) and make it executable from Xcode (e.g. `ln -s /opt/brew/bin/mogenerator /usr/bin/mogenerator`)
2. Install [CocoaPods](http://cocoapods.org/ )
3. Copy ios/Bestmix/Config.h.example to ios/Bestmix/Config.h and modify it.
4. `cd ios; pod install Bestmix.xcodeproj`
5. Open Bestmix.xcworkspace and build the app

License
-------

Bestmix itself is provided under
[MIT License](http://github.com/yatsu/bestmix/blob/master/LICENSE.txt )
and it uses many other libraries.
See [Gemfile](http://github.com/yatsu/bestmix/blob/master/server/Gemfile ) and
[Podfile](http://github.com/yatsu/bestmix/blob/master/ios/Podfile ).

Future Plan
-----------

* Image Uploading
* Push Notification
* Twitter/Facebook Integration
* Testing …currently there is no testing code :(

Contributing to Bestmix
-----------------------

Send me pull requests.

[Using Pull Requests · github:help](https://help.github.com/articles/using-pull-requests )




Bestmix
=======

Bestmix is a boilerplate to build both Rails-based web app and iOS app integrated with each other.
They are connected with JSON REST API supporting CRUD, OAuth2 authentication, pagination and caching.

You can build your own app quickly by extending it.

Libraries
---------

Bestmix uses following libraries and frameworks.

### Server-Side

* [Ruby on Rails](http://rubyonrails.org/ ) - Web Framework
* [Devise](https://github.com/plataformatec/devise ) - Authentication
* [RABL](https://github.com/nesquena/rabl ) - JSON Formatter
* [Doorkeeper](https://github.com/applicake/doorkeeper ) - OAuth2 Provider
* [versionist](https://github.com/bploetz/versionist ) - API Versioning
* [Active Admin](http://activeadmin.info/) - Admin Interface

See [Gemfile](http://github.com/yatsu/bestmix/blob/master/server/Gemfile ) for more details

### iOS App

* [CocoaPods](http://cocoapods.org/ ) - Library Management
* [AFNetworking](https://github.com/AFNetworking/AFNetworking ) - Networking Framework
* [Reachability](https://github.com/tonymillion/Reachability ) - Network Reachability
* [MagicalRecord](https://github.com/magicalpanda/MagicalRecord ) - Active Record for Core Data
* [mogenerator](https://github.com/rentzsch/mogenerator ) - Core Data Code Generation

See [Podfile](http://github.com/yatsu/bestmix/blob/master/ios/Podfile ) for more details.

Setup
-----

### Server-Side

1. Install [Ruby on Rails](http://rubyonrails.org/ ) and [RVM](https://rvm.io/ ) if you don't have them.
2. Copy server/config/database.yml.example to server/config/database.yml and modify it.
3. Copy server/config/initializers/devise.rb.example to server/config/initializers/devise.rb and modify it (See [Devise](https://github.com/plataformatec/devise ) for details).
4. cd server; rails db:setup
5. rails s (or you can setup your web server like Apache, nginx, etc.)

### iOS App

1. Install [mogenerator](https://github.com/rentzsch/mogenerator ) and make it executable from Xcode (e.g. ln -s /opt/brew/bin/mogenerator /usr/bin/mogenerator)
2. Install [CocoaPods](http://cocoapods.org/ )
3. Copy ios/Bestmix/Config.h.example to ios/Bestmix/Config.h and modify it.
4. cd ios; pod install Bestmix.xcodeproj
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

Contributing to Bestmix
-----------------------

Send me pull requests.

[Using Pull Requests · github:help](https://help.github.com/articles/using-pull-requests )




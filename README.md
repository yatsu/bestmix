Bestmix
=======

__NOTE: Bestmix is under development. It works currently without authentication and caching.__

Bestmix is a set of boilerplate to build both Rails-based web app and iOS app integrated with each other.
They are connected with JSON REST API supporting authentication, pagination and caching.
You can build your own server-side and client-side quickly by extending it.

Libraries
---------

Bestmix uses following libraries and frameworks.

### Server-side

* [Ruby on Rails](http://rubyonrails.org/ ) - Web Framework
* [Devise](https://github.com/plataformatec/devise ) - Authentication
* [RABL](https://github.com/nesquena/rabl ) - JSON Generation
* [Doorkeeper](https://github.com/applicake/doorkeeper ) - OAuth2 Provider
* [versionist](https://github.com/bploetz/versionist ) - API Versioning
* [Kaminari](https://github.com/amatsuda/kaminari ) - Pagination
* [Active Admin](http://activeadmin.info/) - Admin Interface

See [Gemfile](http://github.com/yatsu/bestmix/blob/master/server/Gemfile ) for more details

### iOS App

* [CocoaPods](http://cocoapods.org/ ) - Library Management
* [AFNetworking](https://github.com/AFNetworking/AFNetworking ) - Networking Framework
* [JSONKit](https://github.com/johnezang/JSONKit ) - JSON Parser
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD ) - Progress HUD
* [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh ) - Pull-to-Refresh
* [Reachability](https://github.com/tonymillion/Reachability ) - Network Reachability

See [Podfile](http://github.com/yatsu/bestmix/blob/master/ios/Podfile ) for more details.

Setup
-----

### Server-side

1. Install [Ruby on Rails](http://rubyonrails.org/ ) and [RVM](https://rvm.io/ ) if you don't have them.
2. Copy server/config/database.yml.example to server/config/database.yml and modify it.
3. Copy server/config/initializers/devise.rb.example to server/config/initializers/devise.rb and modify it (See [Devise](https://github.com/plataformatec/devise ) for details).
4. cd server; rails db:setup
5. rails s (or you can setup your web server like Apache, nginx, etc.)

### iOS App

1. Install [CocoaPods](http://cocoapods.org/ ) if you don't have it.
2. Copy ios/Bestmix/Config.h.example to ios/Bestmix/Config.h and modify it.
3. cd ios; pod install Bestmix.xcodeproj
4. Open Bestmix.xcworkspace and build the app

License
-------

Bestmix itself is provided under
[MIT License](http://github.com/yatsu/bestmix/blob/master/LICENSE.txt )
and it uses many other libraries.
See [Gemfile](http://github.com/yatsu/bestmix/blob/master/server/Gemfile ) and
[Podfile](http://github.com/yatsu/bestmix/blob/master/ios/Podfile ).

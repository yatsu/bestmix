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
    * Set `config.mailer_sender`.
    * If you use Facebook login, enable the setting at the bottom and modify `APP_ID` and `APP_SECRET`.
4. `cd server; bundle; rake db:setup; rake db:migrate`
5. `rails s` # (or setup your web server such as Apache, nginx, etc.)
6. Open URL `http://localhost:3000/` to see the web app.
7. Open URL `http://localhost:3000/admin` to see the admin page.
    * Email: `admin@example.com`
    * password: `password`
    * See [Active Admin](http://www.activeadmin.info/ ) for more information.
    
#### Register iOS App to Web API

Open admin page: `http://localhost:3000/admin` and click "Applications".

<a href="http://www.flickr.com/photos/14555412@N05/7919712900/" title="admin_dashboard by masaki.yatsu, on Flickr"><img src="http://farm9.staticflickr.com/8172/7919712900_a4355b209f.jpg" width="500" height="382" alt="admin_dashboard"></a>

Click "New Application" at the bottom of the applications page, and input app information in the form:

* Name: `<your iOS app name>`
* Redirect url `bestmix://auth`

If you develop your own app instead of just running the sample app, change the URL schema (`bestmix`) of the above redirect URL.

<a href="http://www.flickr.com/photos/14555412@N05/7919749154/" title="admin_new_app by masaki.yatsu, on Flickr"><img src="http://farm9.staticflickr.com/8297/7919749154_ff16ea2934.jpg" width="500" height="382" alt="admin_new_app"></a>

When you submit the form, app ID and secret will be published as below.
They are used in the iOS app's config file.

<a href="http://www.flickr.com/photos/14555412@N05/7919748686/" title="admin_create_app by masaki.yatsu, on Flickr"><img src="http://farm9.staticflickr.com/8444/7919748686_b099e04ccc.jpg" width="500" height="382" alt="admin_create_app"></a>

### iOS App

1. Install [mogenerator](https://github.com/rentzsch/mogenerator ) and make it executable from Xcode (e.g. `ln -s /opt/brew/bin/mogenerator /usr/bin/mogenerator`)
2. Install [CocoaPods](http://cocoapods.org/ )
3. Copy ios/Bestmix/Config.h.example to ios/Bestmix/Config.h and modify it.
    * Set WebApiUrl (e.g. `http://localhost:3000/api/v1/`)
    * Set AuthBaseURL (e.g. `http://localhost:3000/`)
    * Set ClientID, ClientSecret and RedirectURL same as you saw in the app registration page.
4. `cd ios; pod install`
5. Open Bestmix.xcworkspace and build the app

Develop Your Own App
--------------------

### Server-Side

When you register an app to the web API, use your own custom URL schema for the callback URL in the application registration form (e.g. `myapp://auth`).

### iOS App

Create a new Xcode project with copying Bestmix.xcodeproj.

```sh
% cd ios
% cp -r Bestmix.xcodeproj MyApp.xcodeproj
% find MyApp.xcodeproj -type f | xargs perl -pi -e "s|Bestmix|MyApp|g"
% cp -r Bestmix MyApp
% mv MyApp/Bestmix-Info.plist MyApp/MyApp-Info.plist
% mv MyApp/Bestmix-Prefix.pch MyApp/MyApp-Prefix.pch
```

Modify the top line of Podfile to use the new Xcode project.

```
codeproj 'MyApp.xcodeproj'
```

Run `pod install` and open MyApp.xcworkspace.

Open target summary tab and set bundle identifier.

<a href="http://www.flickr.com/photos/14555412@N05/7921303932/" title="ios_summary by masaki.yatsu, on Flickr"><img src="http://farm9.staticflickr.com/8450/7921303932_7f1e829c75.jpg" width="500" height="321" alt="ios_summary"></a>

Open target info tab and set URL type identifier and URL schema.

<a href="http://www.flickr.com/photos/14555412@N05/7921304526/" title="ios_url by masaki.yatsu, on Flickr"><img src="http://farm9.staticflickr.com/8443/7921304526_5b92805907.jpg" width="500" height="432" alt="ios_url"></a>

Then build and run your app.

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




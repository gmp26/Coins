'use strict'

angular.module 'coinsApp', ['ngRoute']
  .config <[$routeProvider]> ++ ($routeProvider) ->
    $routeProvider.when '/', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:list', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:list/:save0', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:list/:save0/:save1', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .when '/:list/:save0/:save1/:save2', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .otherwise {
      redirectTo: '/'
    }

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
    .otherwise {
      redirectTo: '/'
    }

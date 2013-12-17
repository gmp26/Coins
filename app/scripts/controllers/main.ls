'use strict'

angular.module 'coinsApp'
  .controller 'MainCtrl', <[$scope $routeParams]> ++ ($scope, $routeParams) ->
    $scope.coins = [
      1
      2
      5
      10
      20
      50
    ]

    if $routeParams && $routeParams.list
      $scope.coins = ($routeParams.list.split '-').map (v)->+v

    $scope.averageCount = 0

    average = ->
      sum = 0
      for record in $scope.savedTotals
        sum += record.count
      if $scope.savedTotals.length > 0
        sum / $scope.savedTotals.length
      else
        ""

    $scope.addCoin = (index) ->
      $scope.sum += $scope.coins[index]
      $scope.usedCoins[*] = index

    $scope.saveTotal = ->
      $scope.savedTotals[*] = {
        sum: $scope.sum
        count: $scope.usedCoins.length
        list: ($scope.usedCoins.map (i)->$scope.coins[i]).sort (a,b)->
          if +a < +b then 1 else if +a > +b then -1 else 0
      }
      $scope.usedCoins = []
      $scope.sum = 0
      $scope.averageCount = average!

    $scope.reset = ->
      $scope.usedCoins = []
      $scope.sum = 0
      $scope.savedTotals = []

    $scope.showList = (index) ->
      record = $scope.savedTotals[index]
      record.list.join ','


    $scope.reset!


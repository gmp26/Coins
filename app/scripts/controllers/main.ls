'use strict'
{fold, span, any} = require 'prelude-ls'

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

    average = (saved) ->
      if saved.length > 0
        ((fold (+), 0, saved.map (.count)) / saved.length).toPrecision(3)
      else
        ""

    function listsEqual(xs, ys)
      if xs.length != ys.length
        false
      else
        if xs.length == 0
          true
        else
          [[x, ...xs1], [y, ...ys1]] = [xs, ys]
          (x == y && (listsEqual xs1, ys1))

    saveIf = (options, sortedList, record) ->
      [lessThan, rest] = span (.sum < record.sum), sortedList
      [sumsEqual, greaterThan] = span (.sum == record.sum), rest
      if options.unique
        if any ((it) -> listsEqual it.list, record.list), sumsEqual
          lessThan ++ sumsEqual ++ greaterThan
        else
          lessThan ++ sumsEqual ++ record ++ greaterThan
      else
        lessThan ++ sumsEqual ++ record ++ greaterThan


    $scope.addCoin = (index) ->
      $scope.sum += $scope.coins[index]
      $scope.usedCoins[*] = index

    $scope.saveTotal = ->
      if $scope.sum > 0
        record = {
          sum: $scope.sum
          count: $scope.usedCoins.length
          list: ($scope.usedCoins.map (i)->$scope.coins[i]).sort (a,b)->
            if +a < +b then 1 else if +a > +b then -1 else 0
        }
        $scope.savedTotals = saveIf {unique:true}, $scope.savedTotals, record

      $scope.usedCoins = []
      $scope.sum = 0
      $scope.averageCount = average $scope.savedTotals

    $scope.reset = ->
      $scope.usedCoins = []
      $scope.sum = 0
      $scope.savedTotals = []

    $scope.showList = (index) ->
      record = $scope.savedTotals[index]
      record.list.join ','


    $scope.reset!


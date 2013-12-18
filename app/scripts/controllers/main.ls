'use strict'
{fold, span, any, unique, tail} = require 'prelude-ls'

angular.module 'coinsApp'
  .controller 'MainCtrl', <[$scope $routeParams]> ++ ($scope, $routeParams) ->
    $scope.coins = [
      1
      2
      5
      10
      20
      50
    ].reverse!

    $scope.averageCount = 0

    average = (saved) ->
      if saved.length > 0
        ((fold (+), 0, saved.map (.count)) / saved.length).toPrecision(3)
      else
        ""

    listsEqual = (xs, ys) ->
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


    greedyList = (total, coinList, result) ->
      if total == 0 or coinList == []
        return result

      if coinList.0 > total
        return greedyList total, (tail coinList), result

      result[*] = coinList.0
      greedyList (total - coinList.0), coinList, result

    /*
    console.debug greedyList 53, [25,10,5,1], []
    console.debug greedyList 54, [25,10,5,1], []
    console.debug greedyList 70, [25,10,5,1], []
    console.debug greedyList 48, [30,24,12,6,3,1], []
    */

    isGreedy = (record) ->
      listsEqual record.list, (greedyList $scope.sum, $scope.coins, [])

    $scope.saveTotal = ->
      if $scope.sum > 0
        record = {
          sum: $scope.sum
          count: $scope.usedCoins.length
          list: ($scope.usedCoins.map (i)->$scope.coins[i]).sort (a,b)->
            if +a < +b then 1 else if +a > +b then -1 else 0
        }
        record.greedy = isGreedy record
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

    $scope.addCoin = (index) ->
      $scope.sum += $scope.coins[index]
      $scope.usedCoins[*] = index

    addCoinList = (list) ->
      for v in list
        i = $scope.coins.indexOf v
        $scope.addCoin i if i >= 0
      $scope.saveTotal!

    parseListParameter = (param) ->
      return (param.split '-')
        .map (v) -> +v
        .filter (v) -> v == ~~v and v == Math.round(v)
        .sort (a,b) -> if a < b then 1 else if a > b then -1 else 0

    if $routeParams
      if $routeParams.list
        $scope.coins = unique (parseListParameter $routeParams.list)

      for i from 0 to 2
        param = "save" + i
        if $routeParams[param]
          addCoinList parseListParameter $routeParams[param]

    console.debug $routeParams.save0
    console.debug $routeParams.save1
    console.debug $routeParams.save2



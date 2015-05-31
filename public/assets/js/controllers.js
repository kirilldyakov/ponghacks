'use strict';

/* Controllers */

var pongAppControllers = angular.module('pongAppControllers', []);

pongAppControllers.controller('leaderboardCtrl', ['$scope', '$http',
	function($scope, $http) {
		
	}
]);

pongAppControllers.controller('inputScoreCtrl', ['$scope', '$http', '$routeParams',
	function($scope, $http, $routeParams) {
		
		$http.get('/api/getUsers/').success(function(data) {
			console.log(data);
			$scope.team = data;
    	});

		$scope.submitScore = function() {
			var game = {
				winner: { id : $scope.winner.userId,
						  score: $scope.loser.score
						},
				loser : { id : $scope.loser.userId,
						  score: $scope.loser.score
						}
			};

			$http({
				method: "POST",
				url:"/api/gameResults/inputScore",
				data: game,
				headers: { 'Content-type': 'application/json'}
			})
			.success(function(data, status, headers, config) {
				$scope.winner = {},
				$scope.loser = {};
			})
			.error(function(data, status, headers, config) {
				console.error(data.error);
			});
		};
	}
]);
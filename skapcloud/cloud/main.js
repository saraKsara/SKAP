
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello new skap!");
});

Parse.Cloud.define("getBabies", function(request, response) {
  var query = new Parse.Query("Baby");
  query.equalTo("objectId", request.params.objectId);
  query.find({
    success: function(results) {
   var sum = " ";
      for (var i = 0; i < results.length; ++i) {
        sum += results[i].get("name");
        sum += " ";
    
      }
      //response.success(sum);
      response.success(results);

    },
    error: function() {
      response.error("Failed to get baby");
    }
  });
});

//[{"__type":"Pointer","className":"Baby","objectId":"EShAEXIFzG"}]

// curl -X POST \
//   -H "X-Parse-Application-Id: 4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl" \
//   -H "X-Parse-REST-API-Key: 0vU2vQqcRHuj1jQPmERCfEFivtktEsatS9kPpnXu" \
//   -H "Content-Type: application/json" \
//   -d '{"objectId":"EShAEXIFzG"}' \
//   https://api.parse.com/1/functions/getBabies

Parse.Cloud.define("getEvents", function(request, response) {
  var query = new Parse.Query("Event");
  query.equalTo("Babe", request.params.Babe);
  query.find({
    success: function(results) {
        response.success(results);
    },
    error: function() {
      response.error("Failed to get event");
    }
  });
});
// curl -X POST \
//   -H "X-Parse-Application-Id: 4EQbwofsLU6tVbseSlCoOVvWBmW7MdlLuM4GCuCl" \
//   -H "X-Parse-REST-API-Key: 0vU2vQqcRHuj1jQPmERCfEFivtktEsatS9kPpnXu" \
//   -H "Content-Type: application/json" \
//   -d '{"Babe":"EShAEXIFzG"}' \
//   https://api.parse.com/1/functions/getEvents



// PART 1: CALCULATING LST // 

/*
Author: Sofia Ermida (sofia.ermida@ipma.pt; @ermida_sofia)
This code is free and open. 
By using this code and any data derived with it, 
you agree to cite the following reference 
in any publications derived from them:
Ermida, S.L., Soares, P., Mantas, V., Göttsche, F.-M., Trigo, I.F., 2020. 
    Google Earth Engine open-source code for Land Surface Temperature estimation from the Landsat series.
    Remote Sensing, 12 (9), 1471; https://doi.org/10.3390/rs12091471
Example 1:
  This example shows how to compute Landsat LST from Landsat-8 over Coimbra
  This corresponds to the example images shown in Ermida et al. (2020)
    
*/

// link to the code that computes the Landsat LST
var LandsatLST = require('users/sofiaermida/landsat_smw_lst:modules/Landsat_LST.js')

// select region of interest, date range, and landsat satellite
var geometry = da;
var satellite = 'L8';
var date_start = '2021-06-01';
var date_end = '2021-08-31';
var use_ndvi = true;

// get landsat collection with added variables: NDVI, FVC, TPW, EM, LST
// clip image collection to city bounds
var LST = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi).map(function(image){return image.clip(da)});

// convert to Celsius for easier analysis 
var LSTc = LST.select('LST').map(function(image) {
  return image
    .subtract(273.15) // multiply by band scale for true value? 2.75e-05 
});

print(LSTc)

// PART 2: EXTRACTING LST // 
// want to extract LST values at each DA for each eimage


// define reducer - extract mean LST value at each image in the image collection for each city 
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});  


// calculate average LST value for each DA 
var reduced = LSTc.map(function(image){
  return image.reduceRegions({
    collection:da , 
    reducer: reducer, 
    scale: 30
  });
});

// flatten table 
var daLST = reduced.flatten();

// save
daLST = daLST.filter(ee.Filter.neq('mean', null))

Export.table.toDrive({
  collection: daLST,
  description: 'dissemination_areas'
})


// PART 3: EXTRACTING NDVI // 
// get landsat collection with added variables: NDVI, FVC, TPW, EM, LST
// clip image collection to city bounds
var NDVIcoll = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi).map(function(image){return image.clip(da)});

// select only NDVI
var NDVI = NDVIcoll.select('NDVI')


// calculate NDVI values for each DA 
var reducedNDVI = NDVI.map(function(image){
  return image.reduceRegions({
    collection:da , 
    reducer: reducer, 
    scale: 30
  });
});

var daNDVI = reducedNDVI.flatten();

// save
daNDVI = daNDVI.filter(ee.Filter.neq('mean', null))

Export.table.toDrive({
  collection: daNDVI,
  description: 'dissemination_areas_NDVI'
})




class PlacesAPI {
  static const googlePlacesKey = 'AIzaSyAfrR-sYnakKmLAZJ2hj0OUrp1fUwVfO0Q';
  static const googlePlaceDetailsUrl =
      "https://maps.googleapis.com/maps/api/place/details/json?placeid=GOOGLE_PLACE_ID&fields=name,rating,international_phone_number,formatted_address,geometry,photos,types,url,website,place_id&key=GOOGLE_PLACE_API_KEY";
  static const googlePhotoReferenceUrl =
      "https://maps.googleapis.com/maps/api/place/photo";
}

class TwitterAPI {
  static const twitterAuthKey = "xDVhIMQK9Ik343drjRXfrsYWt";
  static const twitterAuthSecret =
      "cwWMjyoN95AG6e4XWrADGIAKLAeTDc8uPWsO8CElntXCwQUieW";
}

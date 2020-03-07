// Import needed Android libs
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.Manifest;


// Set up the variables for the LocationManager and LocationListener
LocationManager locationManager;
MyLocationListener locationListener;

// Variables to hold the current GPS data
float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
String currentProvider = "";
float currentSpeed = 0;

PFont speedBig;

boolean hasLocation = false;

void setup () {
  fullScreen();
  //size(displayWidth, displayHeight);
  orientation(LANDSCAPE);  
  textFont(createFont("SansSerif", 26 * displayDensity));
  //textAlign(CENTER, CENTER);
  rectMode(CENTER);
  speedBig = createFont("fonts/SpaceGrotesk-Bold.ttf", 70*displayDensity);
  requestPermission("android.permission.ACCESS_FINE_LOCATION", "initLocation");
}

void draw() {
  background(0);
  ellipse(mouseX, mouseY, 40, 40);
  if (hasPermission("android.permission.ACCESS_FINE_LOCATION")) {
    textFont(speedBig, 70*displayDensity);
    textAlign(CENTER, CENTER);
    text(currentSpeed+" km/hr", width/2, height/2);

    textFont(speedBig, 14*displayDensity);
    textAlign(LEFT, TOP);

    text("Latitude: " + currentLatitude + "\n" +
      "Longitude: " + currentLongitude, 10*displayDensity, 10*displayDensity);
    textFont(speedBig, 12*displayDensity);
    textAlign(LEFT, BOTTOM);

    text("Provider: " + currentProvider + "\n" +
      "Accuracy: " + currentAccuracy, 10*displayDensity, displayHeight-(10*displayDensity));
  } else {
    text("No permissions to access location", 0, 0, width, height);
  }
}

void initLocation(boolean granted) {
  if (granted) {    
    Context context = getContext();
    locationListener = new MyLocationListener();
    locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);    
    // Register the listener with the Location Manager to receive location updates
    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
    //locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);

    hasLocation = true;
  } else {
    hasLocation = false;
  }
}

// Class for capturing the GPS data
class MyLocationListener implements LocationListener {

  public void onLocationChanged(Location location) {

    if ( location == null) {
      currentLatitude = 0;
      currentLongitude = 0;
      currentAccuracy = 0;
      currentProvider = "YOLO";
      currentSpeed = 0;
    } else {
      currentLatitude  = (float)location.getLatitude();
      currentLongitude = (float)location.getLongitude();
      currentAccuracy  = (float)location.getAccuracy();
      currentProvider  = location.getProvider();
      currentSpeed = location.getSpeed();
    }
  }

  public void onProviderDisabled (String provider) { 
    currentProvider = "";
  }


  public void onProviderEnabled (String provider) { 
    currentProvider = provider;
  }

  public void onStatusChanged (String provider, int status, Bundle extras) {
  }
}
